package com.nevigo.ai_navigo.controller;

import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.dto.UserClickDTO;
import com.nevigo.ai_navigo.service.IF_preferenceService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class recommendedController {

    private final IF_preferenceService ifPreferenceService;
    private final RestTemplate restTemplate = new RestTemplate();

    // FastAPI URL
    private static final String FASTAPI_URL = "http://127.0.0.1:5000/recommend/";

    // 공공데이터 API 기본 URL
    private static final String BASE_API_URL = "http://apis.data.go.kr/B551011/KorService1/areaBasedList1";
    private static final String BASE_API_URL_COMMON = "http://apis.data.go.kr/B551011/KorService1/detailCommon1";
    private static final String BASE_API_URL_DETAIL = "http://apis.data.go.kr/B551011/KorService1/detailIntro1";
    private static final String BASE_API_URL_DETAILIMAGE = "http://apis.data.go.kr/B551011/KorService1/detailImage1";
    private static final String BASE_API_URL_DETAIL_INFO = "http://apis.data.go.kr/B551011/KorService1/detailInfo1";

    // URL 인코딩된 서비스 키
    private static final String SERVICE_KEY = "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk%2BKzMuXzMv3zKpoylWiGbVlCLA%3D%3D";

    @GetMapping("/main/recommended")
    public String recommendedController(HttpSession session, HttpServletRequest request, Model model,
                                        @RequestParam(value = "course", required = false) String course,
                                        @RequestParam(value = "tc", required = false) String tc) throws Exception {
        // 회원 정보 확인 및 추천 cat3 결정
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        String recommendedCat3 = null;
        if (member != null) {
            String memberId = member.getMemberId();
            System.out.println("로그인된 memberId: " + memberId);
            recommendedCat3 = callFastAPI(memberId);
        } else {
            System.out.println("비로그인 상태 - 인기 여행지 추천");
            recommendedCat3 = ifPreferenceService.getPopularCat3();
        }

        if (recommendedCat3 == null) {
            System.out.println("recommendedCat3 is null");
            model.addAttribute("items", new JSONArray());
            model.addAttribute("courseItems", new ArrayList<>());
            return "/recommended/recommended";
        }

        // 추천 여행지 데이터 호출 (cat3 기준)
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl(BASE_API_URL)
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("numOfRows", 9)
                    .queryParam("pageNo", 1)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "AppTest")
                    .queryParam("_type", "json")
                    .queryParam("listYN", "Y")
                    .queryParam("arrange", "Q")
                    .queryParam("cat3", recommendedCat3)
                    .build(true)
                    .toUri();

            System.out.println("최종 요청 URI: " + uri);
            HttpHeaders headers = new HttpHeaders();
            headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.set("User-Agent", "Mozilla/5.0");
            HttpEntity<?> entity = new HttpEntity<>(headers);
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
            System.out.println("응답 상태: " + response.getStatusCode());
            String responseBody = response.getBody();
            System.out.println("응답 바디: " + responseBody);

            if (response.getStatusCode() == HttpStatus.OK && responseBody != null) {
                JSONObject jsonObj = new JSONObject(responseBody);
                if (jsonObj.has("response")) {
                    JSONObject respObj = jsonObj.getJSONObject("response");
                    if (respObj.has("body") &&
                            respObj.getJSONObject("body").has("items") &&
                            respObj.getJSONObject("body").getJSONObject("items").has("item")) {

                        JSONArray items = respObj.getJSONObject("body")
                                .getJSONObject("items")
                                .getJSONArray("item");

                        // 배열을 랜덤으로 섞음
                        List<JSONObject> itemList = new ArrayList<>();
                        for (int i = 0; i < items.length(); i++) {
                            itemList.add(items.getJSONObject(i));
                        }
                        Collections.shuffle(itemList);
                        JSONArray randomItems = new JSONArray(itemList);
                        model.addAttribute("items", randomItems);
                    } else {
                        System.out.println("'item' 배열 없음.");
                        model.addAttribute("items", new JSONArray());
                    }
                } else {
                    System.out.println("'response' 키 없음.");
                    model.addAttribute("items", new JSONArray());
                }
            } else {
                System.out.println("응답 코드 200이 아니거나 바디가 null");
                model.addAttribute("items", new JSONArray());
            }
        } catch (Exception e) {
            System.out.println("공공데이터 API 오류: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("items", new JSONArray());
        }

        // 문화축제 리스트 처리
        JSONArray festivalsArray = getRecommendedFestivals();
        List<Map<String, Object>> festivalsList = new ArrayList<>();
        for (int i = 0; i < festivalsArray.length(); i++) {
            JSONObject festival = festivalsArray.getJSONObject(i);
            festivalsList.add(festival.toMap());
        }
        model.addAttribute("festivals", festivalsList);

        // 여행코스 검색 처리 (tc 파라미터 사용)
        if (tc != null && !tc.trim().isEmpty()) {
            JSONArray courseItemsJson = getTravelCourseItems(tc);
            List<Map<String, Object>> courseItems = new ArrayList<>();
            for (int i = 0; i < courseItemsJson.length(); i++) {
                JSONObject courseObj = courseItemsJson.getJSONObject(i);
                courseItems.add(courseObj.toMap());
            }
            model.addAttribute("courseItems", courseItems);
            model.addAttribute("tc", tc);
        } else {
            model.addAttribute("courseItems", new ArrayList<>());
        }

        // AJAX 요청인 경우 travel course 목록만 반환
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            return "/recommended/courseSection";
        }

        // 일반 요청은 전체 페이지 반환
        return "/recommended/recommended";
    }

    private String callFastAPI(String memberId) {
        String url = FASTAPI_URL + memberId;
        System.out.println("FastAPI 호출 URL: " + url);
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.set("User-Agent", "Mozilla/5.0");
            HttpEntity<?> entity = new HttpEntity<>(headers);
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JSONObject jsonResponse = new JSONObject(response.getBody());
                return jsonResponse.optString("cat3", null);
            }
        } catch (Exception e) {
            System.out.println("FastAPI 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    //여행코스
    private JSONArray getTravelCourseItems(String tc) {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl(BASE_API_URL)
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("numOfRows", 9)
                    .queryParam("pageNo", 1)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "AppTest")
                    .queryParam("_type", "json")
                    .queryParam("listYN", "Y")
                    .queryParam("arrange", "Q")
                    .queryParam("contentTypeId", "25")
                    .queryParam("cat3", tc)
                    .build(true)
                    .toUri();
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, new HttpEntity<>(new HttpHeaders()), String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JSONObject jsonObj = new JSONObject(response.getBody());
                if (jsonObj.has("response") &&
                        jsonObj.getJSONObject("response").has("body") &&
                        jsonObj.getJSONObject("response").getJSONObject("body").has("items") &&
                        jsonObj.getJSONObject("response").getJSONObject("body").getJSONObject("items").has("item")) {
                    return jsonObj.getJSONObject("response")
                            .getJSONObject("body")
                            .getJSONObject("items")
                            .getJSONArray("item");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new JSONArray();
    }

    private JSONArray getRecommendedFestivals() {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl("http://apis.data.go.kr/B551011/KorService1/searchFestival1")
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("numOfRows", 12)
                    .queryParam("pageNo", 1)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "AppTest")
                    .queryParam("_type", "json")
                    .queryParam("listYN", "Y")
                    .queryParam("eventStartDate", "20250206")
                    .build(true)
                    .toUri();
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, new HttpEntity<>(new HttpHeaders()), String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JSONObject jsonObj = new JSONObject(response.getBody());
                if (jsonObj.has("response") &&
                        jsonObj.getJSONObject("response").has("body") &&
                        jsonObj.getJSONObject("response").getJSONObject("body").has("items") &&
                        jsonObj.getJSONObject("response").getJSONObject("body").getJSONObject("items").has("item")) {
                    return jsonObj.getJSONObject("response")
                            .getJSONObject("body")
                            .getJSONObject("items")
                            .getJSONArray("item");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new JSONArray();
    }

    @GetMapping("main/recommend/detail")
    public String detailController(@RequestParam("contentid") String contentid,
                                   @RequestParam("contenttypeid") String contenttypeid,
                                   @RequestParam("title") String title,
                                   HttpSession session, Model model) throws Exception {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl(BASE_API_URL_COMMON)
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "AppTest")
                    .queryParam("_type", "json")
                    .queryParam("contentId", contentid)
                    .queryParam("defaultYN", "Y")
                    .queryParam("firstImageYN", "Y")
                    .queryParam("areacodeYN", "Y")
                    .queryParam("catcodeYN", "Y")
                    .queryParam("addrinfoYN", "Y")
                    .queryParam("mapinfoYN", "Y")
                    .queryParam("overviewYN", "Y")
                    .build(true)
                    .toUri();
            HttpHeaders headers = new HttpHeaders();
            headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.set("User-Agent", "Mozilla/5.0");
            HttpEntity<?> entity = new HttpEntity<>(headers);
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JSONObject jsonObj = new JSONObject(response.getBody());
                if (jsonObj.has("response")) {
                    JSONObject respObj = jsonObj.getJSONObject("response");
                    if (respObj.has("body") &&
                            respObj.getJSONObject("body").has("items") &&
                            respObj.getJSONObject("body").getJSONObject("items").has("item")) {
                        JSONArray items = respObj.getJSONObject("body")
                                .getJSONObject("items")
                                .getJSONArray("item");
                        model.addAttribute("items", items);
                    } else {
                        model.addAttribute("items", new JSONArray());
                    }
                } else {
                    model.addAttribute("items", new JSONArray());
                }
            } else {
                model.addAttribute("items", new JSONArray());
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("items", new JSONArray());
        }

        String detail = Detailintro(contentid, contenttypeid);
        model.addAttribute("detail", detail);
        String detail_info = Detialinfo(contentid, contenttypeid);
        model.addAttribute("detail_info", detail_info);
        model.addAttribute("contenttypeid", contenttypeid);
        return "/recommended/detail";
    }

    private String Detailintro(String contentid, String contenttypeid) {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl(BASE_API_URL_DETAIL)
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "AppTest")
                    .queryParam("_type", "json")
                    .queryParam("contentId", contentid)
                    .queryParam("contentTypeId", contenttypeid)
                    .build(true)
                    .toUri();
            HttpHeaders headers = new HttpHeaders();
            headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.set("User-Agent", "Mozilla/5.0");
            HttpEntity<?> entity = new HttpEntity<>(headers);
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JSONObject jsonObj = new JSONObject(response.getBody());
                if (jsonObj.has("response")) {
                    JSONObject respObj = jsonObj.getJSONObject("response");
                    if (respObj.has("body") &&
                            respObj.getJSONObject("body").has("items") &&
                            respObj.getJSONObject("body").getJSONObject("items").has("item")) {
                        JSONArray items = respObj.getJSONObject("body")
                                .getJSONObject("items")
                                .getJSONArray("item");
                        return items.toString();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Detail_intro 정보 없음";
    }

    private String Detialinfo(String contentid, String contenttypeid) throws Exception {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl(BASE_API_URL_DETAIL_INFO)
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "AppTest")
                    .queryParam("_type", "json")
                    .queryParam("contentId", contentid)
                    .queryParam("contentTypeId", contenttypeid)
                    .build(true)
                    .toUri();
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, new HttpEntity<>(new HttpHeaders()), String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JSONObject jsonObj = new JSONObject(response.getBody());
                if (jsonObj.has("response")) {
                    JSONObject respObj = jsonObj.getJSONObject("response");
                    if (respObj.has("body") &&
                            respObj.getJSONObject("body").has("items") &&
                            respObj.getJSONObject("body").getJSONObject("items").has("item")) {
                        JSONArray items = respObj.getJSONObject("body")
                                .getJSONObject("items")
                                .getJSONArray("item");
                        return items.toString();
                    }
                }
            }
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return "Detail_info 정보 없음";
    }

    @PostMapping("/recordClick")
    public ResponseEntity<String> recordUserClick(HttpSession session,
                                                  @RequestBody UserClickDTO userClickDTO) throws Exception {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        if (member != null) {
            String memberId = member.getMemberId();
            userClickDTO.setMemberid(memberId);
            ifPreferenceService.clickTravelOne(userClickDTO);
            return ResponseEntity.ok("Click recorded");
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
    }
}
