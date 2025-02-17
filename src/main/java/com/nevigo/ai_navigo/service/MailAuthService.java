package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.MemberDTO;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.Random;

@Service
public class MailAuthService {
    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private HttpSession session;

    public String mainAuth(MemberDTO member) {
        String message = null;

        // 이메일 인증 코드 생성 (랜덤 6자리)
        Random random = new Random();
        int randomInt = random.nextInt(888889)+111111; // 111111~999999까지의 난수 생성

        // 이메일 양식
        String title = "Navigo 회원가입 인증 이메일 입니다.";
        String content = "인증 코드는 " + randomInt + " 입니다."
                        + "<br>"
                        + "해당 인증 코드를 인증 코드 입력란에 기입하여 주세요.";

        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
            String setFrom = "ai_navigo@naver.com";
            helper.setFrom(setFrom);
            helper.setTo(member.getMemberEmail());
            helper.setSubject(title);
            helper.setText(content, true);

            mailSender.send(mimeMessage);
            message = "인증번호가 전송 되었습니다.";
            session.setAttribute("mailCode", randomInt);
        } catch (MessagingException e) {
            e.printStackTrace();
            message = "잠시 후에 다시 시도해주세요.";
        }
        return message;
    }

    public String mailAuthResult(int code){
        String message = null;
        if(code == (int)session.getAttribute("mailCode")){
            message = "인증 되었습니다.";
            session.removeAttribute("mailCode");
        } else{
            message = "인증번호를 다시 확인해주세요.";
        }
        return message;
    }
}
