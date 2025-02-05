package com.nevigo.ai_navigo.controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/mypage")
public class mypageController {

    @GetMapping
    public String myPage() {
        return "mypage/mypage";
    }

    @GetMapping("/update")
    public String update() {
        return "mypage/updateForm";
    }
}
