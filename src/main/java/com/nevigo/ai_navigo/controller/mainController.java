package com.nevigo.ai_navigo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class mainController {
    @GetMapping("/")
    public String localPage() {
        return "/main/home"; // home.html 파일과 매핑
    }

    @GetMapping("/main")
    public String mainPage() {
        return "/main/home"; // home.html 파일과 매핑
    }
}
