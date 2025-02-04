package com.nevigo.ai_navigo.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

import com.nevigo.ai_navigo.service.MemberUpdateService;

@Controller
@RequestMapping("/mypage")
public class memberUpdateController {

    @Autowired
    private MemberUpdateService memberUpdateService;

    // 회원 정보 수정 페이지 이동
    @GetMapping("/update")
    public String showUpdateForm(Principal principal, Model model) {
        Member currentMember = memberUpdateService.findByUsername(principal.getName());
        model.addAttribute("member", currentMember);
        return "mypage/updateForm";
    }

    // 회원 정보 수정 처리
    @PostMapping("/update")
    public String updateMember(@ModelAttribute Member updatedMember,
                               @RequestParam String currentPassword,
                               Principal principal,
                               RedirectAttributes redirectAttributes) {
        try {
            memberService.updateMember(principal.getName(), updatedMember, currentPassword);
            redirectAttributes.addFlashAttribute("message", "회원 정보가 성공적으로 수정되었습니다.");
            return "redirect:/mypage";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "정보 수정 중 오류가 발생했습니다.");
            return "redirect:/mypage/update";
        }
    }
}
