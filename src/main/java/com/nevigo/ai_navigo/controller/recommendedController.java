package com.nevigo.ai_navigo.controller;

import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.dto.UserClickDTO;
import com.nevigo.ai_navigo.service.IF_preferenceService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
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
    private static final String BASE_API_URL_KEYWORD = "http://apis.data.go.kr/B551011/KorService1/searchKeyword1";

    // URL 인코딩된 서비스 키
    private static final String SERVICE_KEY = "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk%2BKzMuXzMv3zKpoylWiGbVlCLA%3D%3D";
    private static final String SERVICE_KEY_DECODE = "zEp9kLeLZiXElh6mddTl2DXHIl44C4brxSyQojUBO6zjiy25apv9Dvh00sygk+KzMuXzMv3zKpoylWiGbVlCLA==";

    @GetMapping("main/recommended")
    public String recommended(Model model, HttpSession session) {

        return "recommended/recommended";
    };


    // [B] AI 프래그먼트
    @GetMapping("/main/recommended/ai")
    public String getAiFragment(Model model, HttpSession session,
                                @RequestParam(value = "exclude", required = false) String exclude) {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        String memberId = member != null ? member.getMemberId() : "guest";
        String url = FASTAPI_URL + memberId;
        if (exclude != null && !exclude.isEmpty()) {
            url += "?exclude=" + exclude;
        }
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.set("User-Agent", "Mozilla/5.0");
            HttpEntity<?> entity = new HttpEntity<>(headers);
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
//                JSONArray items = new JSONArray(response.getBody()); 기존
                JSONObject jsonResponse = new JSONObject(response.getBody());
                JSONArray items = jsonResponse.getJSONArray("recommendations");
                model.addAttribute("items", items);
            } else {
                model.addAttribute("items", new JSONArray());
            }
        } catch (Exception e) {
            System.out.println("FastAPI 오류: " + e.getMessage());
            model.addAttribute("items", new JSONArray());
        }
        return "recommended/ai";
    }

    // JSON 응답 전용 엔드포인트 (AJAX 호출 대상)
    // JSON 응답 전용 엔드포인트 (AJAX 호출 대상)
    @GetMapping("/main/recommended/ai/json")
    @ResponseBody
    public ResponseEntity<String> getAiFragmentJson(HttpSession session,
                                                    @RequestParam(value = "exclude", required = false) String exclude,
                                                    @RequestParam(value = "page", required = false, defaultValue = "1") String page,
                                                    @RequestParam(value = "refresh", required = false, defaultValue = "false") String refresh) {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        String memberId = member != null ? member.getMemberId() : "guest";
        String randomParam = "r=" + System.currentTimeMillis();
        String url = FASTAPI_URL + memberId;
        if (exclude != null && !exclude.isEmpty()) {
            url += "?exclude=" + exclude + "&page=" + page + "&refresh=" + refresh;
        } else {
            url += "?page=" + page + "&refresh=" + refresh;
        }
        url += "&" + randomParam;
        System.out.println("AJAX JSON 엔드포인트 호출 URL: " + url);
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.set("User-Agent", "Mozilla/5.0");
            HttpEntity<?> entity = new HttpEntity<>(headers);
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                return ResponseEntity.ok()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response.getBody());
            } else {
                return ResponseEntity.ok()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body("[]");
            }
        } catch (Exception e) {
            System.out.println("FastAPI 호출 오류: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body("[]");
        }
    }

    @GetMapping("/main/recommended/festival")
    public String getFestival(Model model, HttpSession session) throws Exception {
        // model.addAttribute("festivals", ...);
        //MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        int page = 1;
        int numOfRows = 9;

        // 문화축제 리스트 처리
        JSONArray festivalsArray = getRecommendedFestivals(page, numOfRows);
        List<Map<String, Object>> festivalsList = new ArrayList<>();
        for (int i = 0; i < festivalsArray.length(); i++) {
            JSONObject festival = festivalsArray.getJSONObject(i);
            festivalsList.add(festival.toMap());
            System.out.println(i + ": " + festival);
        }
        model.addAttribute("festivals", festivalsList);

        return "recommended/festival";
    }

    @GetMapping("/main/recommended/festivalAjax")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getFestivalAjax(@RequestParam(defaultValue = "1") int page) throws Exception {
        int numOfRows = 9; // 한 페이지 당 아이템 수
        // API에서 해당 페이지의 데이터만 가져옴
        JSONArray festivalsArray = getRecommendedFestivals(page, numOfRows);
        List<Map<String, Object>> festivalsList = new ArrayList<>();
        for (int i = 0; i < festivalsArray.length(); i++) {
            JSONObject festival = festivalsArray.getJSONObject(i);
            festivalsList.add(festival.toMap());
        }
        return ResponseEntity.ok(festivalsList);
    }





    @GetMapping("/main/recommended/popular")
    public String getPopular(Model model, HttpSession session) throws Exception {
        // model.addAttribute("festivals", ...);
        //MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");

        //인기여행지
        List<Map<String, Object>> PopularTile = ifPreferenceService.getPopularTitle10();

        // 결과를 담을 리스트(각 항목은 제목, 클릭 수, API 검색 결과를 포함)
        List<Map<String, Object>> popularTitleListResults = new ArrayList<>();

        for (Map<String, Object> popularMap : PopularTile) {
            String title = popularMap.get("title").toString();
            String clickCount = popularMap.get("clickCount").toString();

            // title을 키워드로 API 호출 -> getTitlebyCount 메서드는 매개변수로 title을 받아,
            // json array 리턴
            JSONArray keywordResultsArray = getTitlebyCount(title);

            //item
            List<Map<String, Object>> keywordResults = new ArrayList<>();
            for (int i = 0; i < keywordResultsArray.length(); i++) {
                JSONObject keywordObj = keywordResultsArray.getJSONObject(i);
                keywordResults.add(keywordObj.toMap());
            }
            // 제목, 클릭수, 그리고 API 검색결과를 하나의 Map에 담기
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("title", title);
            resultMap.put("clickCount", clickCount);
            resultMap.put("keywordResults", keywordResults);

            //list에 추가
            popularTitleListResults.add(resultMap);

            //디버깅 console
            System.out.println("Title: " + title + ", clickCount: " + clickCount);
            System.out.println("Api 결과: " + keywordResults);

            // 모델에 추가 (JSP에서 popularTitleResults로 접근)
            model.addAttribute("popularTitleListResults", popularTitleListResults);

        }

        return "recommended/popular";
    }

    @GetMapping("/main/recommended/course")
    public String getCourse(Model model) throws Exception {

//        @RequestParam(value="tc", required=false) String tc
//        // tc 파라미터가 있으면 해당하는 여행코스 데이터를 불러옴
//        if (tc != null && !tc.trim().isEmpty()) {
//            JSONArray courseItemsJson = getTravelCourseItems(tc);
//            List<Map<String, Object>> courseItems = new ArrayList<>();
//            for (int i = 0; i < courseItemsJson.length(); i++) {
//                JSONObject obj = courseItemsJson.getJSONObject(i);
//                courseItems.add(obj.toMap());
//            }
//            model.addAttribute("courseItems", courseItems);
//        } else {
//            model.addAttribute("courseItems", new ArrayList<>());
//        }

        // JSP 내부에서 ?ajax 파라미터를 이용해 전체 화면 vs. 목록만 분기 처리하므로,
        // 항상 travelcourse.jsp(합쳐진 형태)를 반환
        return "recommended/travelcourse";

    }

    @GetMapping("/main/recommended/courseAjax")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getCourseAjax(
            @RequestParam(value="tc", required=false) String tc) throws Exception {

        List<Map<String, Object>> courseItems = new ArrayList<>();
        if (tc != null && !tc.trim().isEmpty()) {
            JSONArray courseItemsJson = getTravelCourseItems(tc);
            for (int i = 0; i < courseItemsJson.length(); i++) {
                JSONObject obj = courseItemsJson.getJSONObject(i);
                courseItems.add(obj.toMap());
            }
        }
        return ResponseEntity.ok(courseItems);
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

    //인기여행지(db)
    private JSONArray getTitlebyCount(String keyword) {
        String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8);

        try {
            URI uri = UriComponentsBuilder.fromHttpUrl(BASE_API_URL_KEYWORD)
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "AppTest")
                    .queryParam("_type", "json")
                    .queryParam("listYN", "Y")
                    .queryParam("arrange", "C")
                    .queryParam("keyword", encodedKeyword)
                    .build(true)
                    .encode()
                    .toUri();


            ResponseEntity<String> response = restTemplate.exchange(
                    uri,
                    HttpMethod.GET,
                    new HttpEntity<>(new HttpHeaders()),
                    String.class
            );
            System.out.println("ketword uri: "+ uri);
            String responseBody = response.getBody();
            System.out.println("Response Body: " + responseBody);


            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JSONObject jsonObj = new JSONObject(response.getBody());
                if (jsonObj.has("response") &&
                        jsonObj.getJSONObject("response").has("body") &&
                        jsonObj.getJSONObject("response").getJSONObject("body").has("items") &&
                        jsonObj.getJSONObject("response").getJSONObject("body")
                                .getJSONObject("items").has("item")) {
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

    private JSONArray getRecommendedFestivals(int page, int numOfRows) {
        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl("http://apis.data.go.kr/B551011/KorService1/searchFestival1")
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("numOfRows", numOfRows)
                    .queryParam("pageNo", page)
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

    // 인기여행지

    @GetMapping("/main/recommend/detail")
    public String detailController(@RequestParam("contentid") String contentid,
                                   @RequestParam("contenttypeid") String contenttypeid,
                                   @RequestParam("title") String title,
                                   HttpSession session, Model model) throws Exception {
        System.out.println("contentid: " + contentid);

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
                    if (respObj.has("body")) {
                        JSONObject bodyObj = respObj.getJSONObject("body");
                        // items가 JSONObject인지 확인
                        Object itemsObj = bodyObj.get("items");
                        if (itemsObj instanceof JSONObject) {
                            JSONObject itemsJson = (JSONObject) itemsObj;
                            if (itemsJson.has("item")) {
                                JSONArray items = itemsJson.getJSONArray("item");
                                return items.toString();
                            }
                        } else if (itemsObj instanceof String) {
                            // 만약 items가 빈 문자열이면 빈 배열로 처리
                            String itemsStr = (String) itemsObj;
                            if (itemsStr.trim().isEmpty()) {
                                return "[]";
                            } else {
                                return itemsStr;
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Detail_info 정보 없음";
    }


    @PostMapping("/recordClick")
    public ResponseEntity<String> recordUserClick(HttpSession session,
                                                  @RequestBody UserClickDTO userClickDTO) throws Exception {
        //디버그
//        System.out.println(debug: userClickDTO);
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");

        if (member != null) {
            String memberId = member.getMemberId();
            userClickDTO.setMemberid(memberId);
            System.out.println(userClickDTO.toString());
            ifPreferenceService.clickTravelOne(userClickDTO);
            return ResponseEntity.ok("Click recorded");
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
    }

//    // 무한스크롤?
//
//    @GetMapping("main/recommended/ai")
//    public String aiRecommendations(@RequestParam(defaultValue = "1") int pageNo,
//                                    @RequestParam(defaultValue = "6") int numOfRows,
//                                    Model model) throws Exception {
//
//
//            return "null";
//    }
}
