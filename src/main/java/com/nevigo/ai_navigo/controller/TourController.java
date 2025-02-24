package com.nevigo.ai_navigo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.*;

@Controller
public class TourController {

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${kakao.js.key}")
    private String kakaoJsKey;

    private static final Logger logger = LoggerFactory.getLogger(TourController.class);

    private static final Map<String, List<String>> DISTRICT_MAP = new LinkedHashMap<>();

    // 바다가 있는 지역 정의 (해안선이 있는 광역시/도)
    private static final Set<String> COASTAL_REGIONS = new HashSet<>(Arrays.asList(
            "인천", "부산", "울산", "경기", "강원", "충남", "경북", "경남", "전북", "전남", "제주"
    ));

    static {
        List<String> majorCities = Collections.singletonList("전역");
        DISTRICT_MAP.put("서울", majorCities);
        DISTRICT_MAP.put("인천", majorCities);
        DISTRICT_MAP.put("대전", majorCities);
        DISTRICT_MAP.put("대구", majorCities);
        DISTRICT_MAP.put("광주", majorCities);
        DISTRICT_MAP.put("부산", majorCities);
        DISTRICT_MAP.put("울산", majorCities);
        DISTRICT_MAP.put("세종", majorCities);

        DISTRICT_MAP.put("경기", Arrays.asList(
                "가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시",
                "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시",
                "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시",
                "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"
        ));
        DISTRICT_MAP.put("강원", Arrays.asList(
                "강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군",
                "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군",
                "화천군", "횡성군"
        ));
        DISTRICT_MAP.put("충북", Arrays.asList(
                "괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "진천군",
                "청주시", "충주시", "증평군"
        ));
        DISTRICT_MAP.put("충남", Arrays.asList(
                "공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군",
                "아산시", "예산군", "천안시", "청양군", "태안군", "홍성군"
        ));
        DISTRICT_MAP.put("경북", Arrays.asList(
                "경산시", "경주시", "고령군", "구미시", "김천시", "문경시", "봉화군", "상주시",
                "성주군", "안동시", "영덕군", "영양군", "영주시", "영천시", "예천군",
                "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시"
        ));
        DISTRICT_MAP.put("경남", Arrays.asList(
                "거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군",
                "양산시", "의령군", "진주시", "창녕군", "창원시", "통영시", "하동군", "함안군",
                "함양군", "합천군"
        ));
        DISTRICT_MAP.put("전북", Arrays.asList(
                "고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군",
                "익산시", "임실군", "장수군", "전주시", "정읍시", "진안군"
        ));
        DISTRICT_MAP.put("전남", Arrays.asList(
                "강진군", "고흥군", "곡성군", "광양시", "구례군", "나주시", "담양군", "목포시",
                "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "완도군",
                "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"
        ));
        DISTRICT_MAP.put("제주", majorCities);

        logger.debug("DEBUG: Initialized DISTRICT_MAP size: " + DISTRICT_MAP.size());
    }

    private static final List<String> REGIONS = new ArrayList<>(DISTRICT_MAP.keySet());
    private static final List<String> THEMES = Arrays.asList(
            "산", "바다", "실내 여행지", "액티비티", "문화 & 역사", "테마파크", "카페", "전통시장", "축제"
    );

    @GetMapping("/generate-plan")
    public String showTourPlanForm(Model model) {
        model.addAttribute("regions", REGIONS);
        model.addAttribute("themes", THEMES);
        model.addAttribute("kakaoJsKey", kakaoJsKey);

        try {
            model.addAttribute("districtMapJson", objectMapper.writeValueAsString(DISTRICT_MAP));
            // 바다가 있는 지역 여부를 JSON으로 전달
            Map<String, Boolean> coastalRegionsMap = new HashMap<>();
            for (String region : REGIONS) {
                coastalRegionsMap.put(region, COASTAL_REGIONS.contains(region));
            }
            model.addAttribute("coastalRegionsJson", objectMapper.writeValueAsString(coastalRegionsMap));
        } catch (Exception e) {
            logger.error("JSON generation failed: " + e.getMessage());
            model.addAttribute("districtMapJson", "{}");
            model.addAttribute("coastalRegionsJson", "{}");
        }

        return "tourKR/tourplan";
    }

    @PostMapping("/generate-plan")
    public String getTourPlan(
            @RequestParam("region") String region,
            @RequestParam(value="district", required=false, defaultValue="") String district,
            @RequestParam("start_date") String startDate,
            @RequestParam("end_date") String endDate,
            @RequestParam("companion_type") String companionType,
            @RequestParam(value="themes", required=false) List<String> themes,
            Model model
    ) {
        if (themes == null) {
            themes = new ArrayList<>();
        }

        String fastApiUrl = "http://localhost:4000/generate-plan";
        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json");

        Map<String, Object> requestData = Map.of(
                "region", region,
                "district", district.equals("전역") ? "" : district,
                "start_date", startDate,
                "end_date", endDate,
                "companion_type", companionType,
                "themes", themes
        );

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestData, headers);
        try {
            ResponseEntity<String> response = restTemplate.postForEntity(fastApiUrl, requestEntity, String.class);
            String responseBody = response.getBody();
            if (responseBody == null || responseBody.trim().isEmpty()) {
                logger.error("FastAPI 응답이 비어 있음");
                model.addAttribute("travelPlan", Collections.emptyList());
                return "tourKR/result";
            }

            Map<String, Object> responseMap = objectMapper.readValue(responseBody, new TypeReference<Map<String, Object>>() {});
            Map<String, Object> travelPlanWrapper = (Map<String, Object>) responseMap.get("travel_plan");
            if (travelPlanWrapper != null && "success".equals(travelPlanWrapper.get("status"))) {
                List<Map<String, Object>> travelPlan = (List<Map<String, Object>>) travelPlanWrapper.get("travel_plan");
                model.addAttribute("travelPlan", travelPlan); // 리스트를 직접 전달
                logger.info("travelPlan 설정 완료: " + objectMapper.writeValueAsString(travelPlan));
            } else {
                logger.error("travel_plan 데이터가 유효하지 않음: " + travelPlanWrapper);
                model.addAttribute("travelPlan", Collections.emptyList());
            }

        } catch (Exception e) {
            logger.error("FastAPI 호출 또는 데이터 처리 오류: " + e.getMessage(), e);
            model.addAttribute("travelPlan", Collections.emptyList());
        }

        model.addAttribute("kakaoJsKey", kakaoJsKey);
        return "tourKR/result";
    }
}