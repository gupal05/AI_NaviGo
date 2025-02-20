package com.nevigo.ai_navigo.controller;

import com.nevigo.ai_navigo.dao.IF_ForeignPlanDao;
import com.nevigo.ai_navigo.dto.ForeignPlacePhotoDTO;
import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import com.nevigo.ai_navigo.dto.ForeignScheduleDTO;
import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.service.IF_ForeignPlanService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/foreign")
@RequiredArgsConstructor
public class ForeignPlanController {

    private final IF_ForeignPlanService foreignPlanService;
    private final IF_ForeignPlanDao foreignPlanDao;

    @Value("${google.foreign.key}")
    private String foreignKey;

    @GetMapping("/create")
    public String showCreateForm(HttpSession session, Model model) {
        // 로그인 체크
        MemberDTO memberInfo = (MemberDTO) session.getAttribute("memberInfo");
        if (memberInfo == null) {
            return "redirect:/";
        }

        // Google Maps API 키 전달
        model.addAttribute("apikey", foreignKey);
        return "foreign/createPlan";
    }

    @PostMapping("/create")
    @ResponseBody
    public Map<String, Object> createPlan(
            @RequestBody ForeignPlanDTO planDTO,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Session validation
            MemberDTO memberInfo = (MemberDTO) session.getAttribute("memberInfo");
            if (memberInfo == null) {
                throw new Exception("로그인이 필요합니다.");
            }

            // Set member ID
            planDTO.setMemberId(memberInfo.getMemberId());

            // Create plan
            Long planId = foreignPlanService.createPlan(planDTO);

            response.put("success", true);
            response.put("planId", planId);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            // Log error
        }

        return response;
    }

    @GetMapping("/plan/{planId}")
    public String showPlanDetail(
            @PathVariable Long planId,
            Model model,
            HttpSession session) {
        try {
            Map<String, Object> planDetails = foreignPlanService.getPlanWithFullDetails(planId);

            // Log detailed information
            List<ForeignScheduleDTO> schedules = (List<ForeignScheduleDTO>) planDetails.get("schedules");
            schedules.forEach(schedule -> {
                schedule.getActivities().forEach(activity -> {
                    System.out.println("Activity: " + activity.getPlaceName() +
                            ", Lat: " + activity.getLatitude() +
                            ", Lng: " + activity.getLongitude());
                });
            });

            log.debug("Plan details: {}", planDetails);

            model.addAttribute("plan", planDetails.get("plan"));
            model.addAttribute("schedules", schedules);
            model.addAttribute("apikey", foreignKey);

            return "foreign/planDetail";

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/error";
        }
    }

    @GetMapping("/list")
    public String showPlanList(Model model, HttpSession session) {
        try {
            MemberDTO memberInfo = (MemberDTO) session.getAttribute("memberInfo");
            if (memberInfo == null) {
                return "redirect:/";
            }

            List<ForeignPlanDTO> planList =
                    foreignPlanService.getPlanList(memberInfo.getMemberId());

            model.addAttribute("planList", planList);
            return "foreign/planList";

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/error";
        }
    }
    @PostMapping("/plan/{planId}/photos")
    public ResponseEntity<String> savePlanPhotos(
            @PathVariable Long planId,
            @RequestBody Map<String, String> photos
    ) {
        try {
            foreignPlanService.savePlacePhotos(planId, photos);
            return ResponseEntity.ok("Photos saved successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error saving photos: " + e.getMessage());
        }
    }

    @GetMapping("/plan/{planId}/photos")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getPlanPhotos(@PathVariable Long planId) {
        try {
            List<ForeignPlacePhotoDTO> photos = foreignPlanDao.getPlacePhotosByPlanId(planId);

            // 로그 추가
            log.info("Fetched photos: {}", photos);
            log.info("Number of photos: {}", photos.size());

            Map<String, String> photoMap = photos.stream()
                    .collect(Collectors.toMap(
                            ForeignPlacePhotoDTO::getPlaceName,
                            ForeignPlacePhotoDTO::getPhotoUrl,
                            (v1, v2) -> v1
                    ));

            log.info("Photo map: {}", photoMap);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("photos", photoMap);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("여행 계획 사진 조회 중 오류 발생", e);

            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "사진을 조회할 수 없습니다.");

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
}