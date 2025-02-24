package com.nevigo.ai_navigo.controller;

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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class tourController {

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    // GET 요청: 사용자 입력 폼을 보여줍니다.
    @GetMapping("/generate-plan")
    public String showTourPlanForm() {
        return "main/tourplan"; // WEB-INF/views/main/tourplan.jsp
    }

    // POST 요청: 폼 데이터를 처리하여 FastAPI 서버에 요청하고 결과 페이지를 반환합니다.
    @PostMapping("/generate-plan")
    public String getTourPlan(
            @RequestParam("region") String region,
            @RequestParam(value = "district", required = false, defaultValue = "") String district,
            @RequestParam("start_date") String startDate,
            @RequestParam("end_date") String endDate,
            @RequestParam("companion_type") String companionType,
            @RequestParam(value = "themes", required = false) List<String> themes,
            Model model) {

        // themes가 null이면 빈 리스트로 초기화
        if (themes == null) {
            themes = new ArrayList<>();
        }

        // FastAPI 서버의 절대 URL
        String fastApiUrl = "http://localhost:4000/generate-plan";
        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json");

        // FastAPI에 전달할 요청 데이터 구성 (null 값 없이)
        Map<String, Object> requestData = Map.of(
                "region", region,
                "district", district,
                "start_date", startDate,
                "end_date", endDate,
                "companion_type", companionType,
                "themes", themes
        );

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestData, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(fastApiUrl, requestEntity, String.class);

        try {
            Map<String, Object> responseBody = objectMapper.readValue(
                    response.getBody(), new TypeReference<Map<String, Object>>() {});
            if ("success".equals(responseBody.get("status"))) {
                Map<String, Object> travelPlanData = (Map<String, Object>) responseBody.get("travel_plan");
                List<Map<String, Object>> travelPlanList = (List<Map<String, Object>>) travelPlanData.get("travel_plan");
                model.addAttribute("travelPlan", travelPlanList);
            } else {
                model.addAttribute("travelPlan", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("travelPlan", null);
        }

        return "main/result"; // WEB-INF/views/main/result.jsp
    }
}
