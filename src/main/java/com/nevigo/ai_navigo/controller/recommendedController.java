package com.nevigo.ai_navigo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class recommendedController {

    @GetMapping("main/recommended")
    public String recommendedController() {

        return "/recommended/recommended";
    }
}
