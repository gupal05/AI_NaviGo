package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_changePwDao;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;

@Service
public class ChangePwService implements IF_changePwService {

    @Autowired
    private IF_changePwDao changePwDao;

    @Override
    public boolean updatePassword(String memberId, String newPw, HttpSession session) throws Exception {
        // 비밀번호 암호화
        String encryptedPw = BCrypt.hashpw(newPw, BCrypt.gensalt());

        // DB에 비밀번호 업데이트
        changePwDao.updatePassword(memberId, encryptedPw);

        // 세션 정보 업데이트
        session.setAttribute("password", encryptedPw);

        return true; // 성공적으로 업데이트
    }
}


