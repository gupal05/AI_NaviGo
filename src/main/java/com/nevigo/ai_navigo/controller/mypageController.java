package com.nevigo.ai_navigo.controller;
import com.nevigo.ai_navigo.dao.IF_changePwDao;
import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import com.nevigo.ai_navigo.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.nevigo.ai_navigo.dto.MemberDTO;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mypage")
public class mypageController {

    private final IF_preferenceService preferenceService;
    private final IF_changePwService changePwService;
    private final PreUpdateService_Impl preUpdateService_Impl;
    private final HistoryService_Impl historyService_Impl;

    @Autowired
    public mypageController(HistoryService_Impl historyService_Impl,
                            IF_changePwService changePwService,
                            IF_preferenceService preferenceService,
                            PreUpdateService_Impl preUpdateService_Impl) {
        this.preferenceService = preferenceService;
        this.changePwService = changePwService;
        this.preUpdateService_Impl = preUpdateService_Impl;
        this.historyService_Impl = historyService_Impl;

    }

    @Autowired
    HttpSession session;

    @PostMapping("/test")
    public ModelAndView test(ModelAndView mav){
        mav.addObject("member", session.getAttribute("memberInfo"));
        mav.setViewName("mypage/history");
        return mav;
    }

    // 초기 마이페이지 진입점 - 기본으로 history를 보여줌
    @GetMapping
    public ModelAndView mypage(HttpSession session, RedirectAttributes redirectAttributes) {
        ModelAndView mav = new ModelAndView();
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");

        if (member == null) {
            redirectAttributes.addFlashAttribute("loginMessage", "로그인 후 이용 가능합니다.");
            mav.setViewName("redirect:/auth/login");
            return mav;
        }

        // 기본적으로 history 페이지로 이동
        return getUserPlans(mav);
    }

    @PostMapping("/history")
    public ModelAndView getUserPlans(ModelAndView mav) {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        mav.addObject("member", member);

        try {
            List<ForeignPlanDTO> userPlans = historyService_Impl.findPlansByMemberId(member.getMemberId());
            mav.addObject("savedPlans", userPlans);
            mav.setViewName("mypage/history"); // 직접 history.jsp로 이동
        } catch (Exception e) {
            e.printStackTrace();
            mav.setViewName("redirect:/error");
        }

        return mav;
    }

    @PostMapping("/preference")
    public ModelAndView getUserPreference(ModelAndView mav) {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        mav.addObject("member", member);

        try {
            String savedCategory = preferenceService.getPreferenceById(member.getMemberId());
            mav.addObject("savedCategory", savedCategory);
            mav.setViewName("mypage/preference"); // 직접 preference.jsp로 이동
        } catch (Exception e) {
            e.printStackTrace();
            mav.setViewName("redirect:/error");
        }

        return mav;
    }

    @PostMapping("/updatePreference")
    public ResponseEntity<String> updatePreference(@RequestBody Map<String, String> requestData) {
        // 세션에서 회원 정보 가져오기
        MemberDTO memberInfo = (MemberDTO) session.getAttribute("memberInfo");
        String memberId = memberInfo.getMemberId();
        String preference = requestData.get("selectedCategory");

        if (memberId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        if (preference == null || preference.isEmpty()) {
            return ResponseEntity.badRequest().body("선택한 카테고리가 없습니다.");
        }

        try {
            preUpdateService_Impl.saveOrUpdatePreference(memberId, preference);
            return ResponseEntity.ok("성공적으로 저장되었습니다!");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("저장 중 오류가 발생했습니다.");
        }
    }

    @PostMapping("/changePw")
    public ModelAndView getUserPw(ModelAndView mav) {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        mav.addObject("member", member);
        mav.setViewName("mypage/changePw"); // 직접 changePw.jsp로 이동
        return mav;
    }

    // 비밀번호 변경
    @PostMapping("/updatechangePw")
    @ResponseBody
    public String changePw(@RequestParam("currentPw") String currentPw,
                           @RequestParam("newPw") String newPw,
                           @RequestParam("confirmPw") String confirmPw) {


        // 세션에서 회원 정보 가져오기
        MemberDTO memberInfo = (MemberDTO) session.getAttribute("memberInfo");

        // null 체크
        if (memberInfo == null) {
            return "세션이 만료되었습니다. 다시 로그인 해주세요.";
        }

        String memberId = memberInfo.getMemberId();
        String encryptedPw = memberInfo.getMemberPw(); // DB에 저장된 암호화된 비밀번호

        // 현재 비밀번호 확인
        if (!BCrypt.checkpw(currentPw, encryptedPw)) {
            return "현재 비밀번호가 올바르지 않습니다.";
        }

        // 새 비밀번호와 확인 비밀번호가 일치하지 않을 경우
        if (!newPw.equals(confirmPw)) {
            return "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.";
        }

        try {
            // Service 호출하여 비밀번호 변경
            boolean isUpdated = changePwService.updatePassword(memberId, newPw, session);

            if (isUpdated) {
                // 세션 정보 업데이트
                memberInfo.setMemberPw(BCrypt.hashpw(newPw, BCrypt.gensalt()));
                session.setAttribute("memberInfo", memberInfo);

                return "비밀번호를 성공적으로 변경했습니다.";

            } else {
                return "비밀번호 변경 중 문제가 발생했습니다.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "비밀번호 변경 중 오류가 발생했습니다.";
        }


    }

}