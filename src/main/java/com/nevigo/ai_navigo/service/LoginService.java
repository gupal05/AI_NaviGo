package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_LoginDao;
import com.nevigo.ai_navigo.dao.IF_SignUpDao;
import com.nevigo.ai_navigo.dto.MemberDTO;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LoginService implements IF_LoginService{
    private final IF_LoginDao loginDao;
    private final BCryptPasswordEncoder passwordEncoder;

    public LoginService(IF_LoginDao loginDao, BCryptPasswordEncoder passwordEncoder) {
        this.loginDao = loginDao;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public int isMemberId(MemberDTO member) {
        try {
            return loginDao.isMemberId(member);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public String getMemberPw(MemberDTO member) {
        try {
            return loginDao.getMemberPw(member);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public MemberDTO getMemberInfo(MemberDTO member) {
        try {
            MemberDTO result = loginDao.getMemberInfo(member);
            return result;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public boolean isPasswordMatch(MemberDTO member, String pw) {
        // DB에서 암호화된 비밀번호 가져오기
        String encodedPassword = pw;

        // 비밀번호 비교 (입력값 vs 암호화된 값)
        return passwordEncoder.matches(member.getMemberPw(), encodedPassword);
    }
}
