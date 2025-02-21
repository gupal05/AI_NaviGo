package com.nevigo.ai_navigo.controller;

import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.service.IF_SignUpService;
import com.nevigo.ai_navigo.service.MailAuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/auth")
public class SignUpController {
    @Autowired
    private IF_SignUpService signUpService;
    @Autowired
    private MailAuthService mailAuthService;
    @Autowired
    private HttpSession session;

    //회원가입 페이지로 이동을 위한
    @GetMapping("/signUp")
    public String signUp() {
        return "/auth/signUp";
    }

    //아이디 중복 확인을 위한
    @PostMapping("/dupCheckId")
    @ResponseBody
    public String dupCheckId(@RequestParam("id") String id) {
        if(signUpService.dupCheckId(id) != 0){
            return "존재하는 ID 입니다.";
        }else {
            return "사용 가능한 ID 입니다.";
        }
    }

    // 회원가입 후 사용자 취향 받는 페이지로 이동
    @PostMapping("/signResult")
    public String signupResult(@ModelAttribute MemberDTO member) {
        if(signUpService.insMember(member) != 0){
            session.setAttribute("temp", member);
            return "/auth/signup_result";
        } else{
          return "redirect:/signUp";
        }
    }

    // 사용자 취향 저장 후 회원가입 완료 (메인 페이지로 이동)
    @PostMapping("/sign_card_result")
    public String cardResult(@RequestParam("selectedCategory") String selCard) {
        MemberDTO member = (MemberDTO) session.getAttribute("temp");
        Map<String, Object> map = new HashMap<>();
        map.put("selectedCategory", selCard);
        map.put("memberId", member.getMemberId());
        if(signUpService.insPreference(map) != 0){
            session.removeAttribute("temp");
            return "redirect:/main";
        }else{
            return "redirect:/signUp";
        }
    }

    @PostMapping("/mailAuth")
    @ResponseBody
    public String mailAuth(@ModelAttribute MemberDTO member) {
        return mailAuthService.mainAuth(member);
    }

    @PostMapping("/mailAuth/result")
    @ResponseBody
    public String mailAuthResult(@RequestParam("mailCode") int mailCode) {
        return mailAuthService.mailAuthResult(mailCode);
    }

    @GetMapping("/googleSignUpResult")
    public String googleSignUpResult() {
        return "/auth/signup_result";
    }
}
