package com.nevigo.ai_navigo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Controller
public class tourController {

    @GetMapping("/tourplan")
    public String showTourPlan() {
        return "main/tourplan"; // `WEB-INF/views/main/tourplan.jsp` 연결
    }

    @PostMapping("/api/generate-plan")
    @ResponseBody
    public Map generatePlan(
            @RequestParam String region,
            @RequestParam(required = false) String district,
            @RequestParam String start_date,
            @RequestParam String end_date,
            @RequestParam String companion_type,
            @RequestParam String themes) {

        RestTemplate restTemplate = new RestTemplate();

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("region", region);
        requestBody.put("district", district);
        requestBody.put("start_date", start_date);
        requestBody.put("end_date", end_date);
        requestBody.put("companion_type", companion_type);
        requestBody.put("themes", themes.split(",")); // 문자열을 리스트로 변환

        // FastAPI 호출

        String FASTAPI_URL = "http://localhost:8000/generate-plan";
        return restTemplate.postForObject(FASTAPI_URL, requestBody, Map.class);
    }
}

