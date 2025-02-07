package com.nevigo.ai_navigo.controller;


import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.dto.UserClickDTO;
import com.nevigo.ai_navigo.service.IF_preferenceService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
@RequiredArgsConstructor
public class recommendedController {

    private final IF_preferenceService ifPreferenceService;

    @GetMapping("main/recommended")
    public String recommendedController(HttpSession session, Model model) throws Exception {
        // 세션 종료: 모든 세션 속성을 제거하고 세션을 무효화합니다.
//        session.invalidate();

        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        if(member != null) {
            String memberId = member.getMemberId();
            System.out.println("memberId: " + memberId);
            System.out.println("세션 로그인됨.");

            String preference = ifPreferenceService.getPreferenceById(memberId);
            //
            System.out.println(memberId+ " 의 preference: " + preference);

            model.addAttribute("preference", preference);

        }else if(member == null) {

            System.out.println("로그인 안됨.");
            return "redirect:/main";
        }
        return "/recommended/recommended";
    }

    @GetMapping("main/recommend/detail")
    public String detailController(HttpSession session, Model model) throws Exception {


        return "/recommended/detail";
    }

    @PostMapping("/recordClick")
    public ResponseEntity<String> recordUserClick(HttpSession session,
                                                  @RequestBody UserClickDTO userClickDTO) throws Exception {
        MemberDTO member = (MemberDTO) session.getAttribute("memberInfo");
        if(member != null) {
            String memberId = member.getMemberId();
            String contentid = userClickDTO.getContentid();
            String cat1 = userClickDTO.getCat1();
            String cat2 = userClickDTO.getCat2();
            String cat3 = userClickDTO.getCat3();

            System.out.println("memberId: " + memberId + " /// contentid: " + contentid +
                    " /// cat1: " + cat1 + " /// cat2: " + cat2 + " /// cat3: " + cat3);

//            ifPreferenceService.saveUserClick(memberId, contentid);
            //
            return ResponseEntity.ok("Click recorded");
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
    }




}
