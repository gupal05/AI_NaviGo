package com.nevigo.ai_navigo.controller;


import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.service.IF_LoginService;
import com.nevigo.ai_navigo.service.LoginService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/auth")
public class loginController {
    @Autowired
    private IF_LoginService loginService;
    @Autowired
    private HttpSession session;
    @Autowired
    private LoginService auth;

    @GetMapping("/login")
    public String loginPage() {
        return "/auth/login";
    }

    @PostMapping("/isLogin")
    @ResponseBody
    public String login(@ModelAttribute MemberDTO member) {
        if(loginService.isMemberId(member) == 1){
            if(auth.isPasswordMatch(member, loginService.getMemberPw(member))){
                member.setMemberPw(loginService.getMemberPw(member));
                MemberDTO memberDTO = loginService.getMemberInfo(member);
                session.setAttribute("memberInfo", memberDTO);
            }else{
                return "비밀번호가 틀립니다.";
            }
        }else{
            return "존재하지 않는 계정입니다.";
        }
        return "ok";
    }

    @PostMapping("/sign_in")
    public String signIn(@ModelAttribute MemberDTO member) {
        System.out.println(session.getAttribute("memberInfo"));
        return "/main/home";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        System.out.println(session.getAttribute("memberInfo"));
        session.removeAttribute("memberInfo");
        return "/main/home";
    }
}
