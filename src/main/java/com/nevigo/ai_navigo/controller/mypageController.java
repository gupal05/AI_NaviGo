package com.nevigo.ai_navigo.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

import com.nevigo.ai_navigo.service.MemberUpdateService;

@Controller
@RequestMapping("/mypage")
public class memberUpdateController {

    @GetMapping("/mypage")
    public String myPage() {
        return "/mypage/mypage";
    }

    @GetMapping("/update")
    public String update() {
        return "/mypage/updateForm";
    }
}
