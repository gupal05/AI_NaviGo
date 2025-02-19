package com.nevigo.ai_navigo.service;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

@Service
public class ChangePwService implements IF_changePwService {

    @Override
    public boolean updatePassword(String userId, String newPw, HttpSession session) throws Exception {
        // 여기서 비밀번호 암호화 등을 처리
        String encryptedPw = newPw; // 필요 시 암호화 (예: BCrypt 사용)

        // 세션에 새 비밀번호 저장
        session.setAttribute("password", encryptedPw);

        return true; // 성공적으로 업데이트되었음을 반환
    }
}


