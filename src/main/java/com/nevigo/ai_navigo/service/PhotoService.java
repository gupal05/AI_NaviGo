package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.PlaceRequestDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class PhotoService {
    private final RestTemplate restTemplate;
    private final IF_ForeignPlanService foreignPlanService;

    // 파이썬 서버의 URL (application.properties에서 설정)
    @Value("${foreign.server.url}")
    private String pythonServerUrl;

    public Map<String, String> fetchPlacePhotos(List<String> places) {
        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    pythonServerUrl + "/places-photos",
                    new PlaceRequestDTO(places),
                    Map.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return (Map<String, String>) response.getBody().get("photos");
            }
            return null;
        } catch (Exception e) {
            log.error("사진 가져오기 중 오류 발생", e);
            return null;
        }
    }

    public void savePhotosForPlan(Long planId, List<String> places) {
        Map<String, String> photos = fetchPlacePhotos(places);
        if (photos != null && !photos.isEmpty()) {
            try {
                foreignPlanService.savePlacePhotos(planId, photos);
            } catch (Exception e) {
                log.error("사진 저장 중 오류 발생", e);
            }
        }
    }
}