package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_SignUpDao;
import com.nevigo.ai_navigo.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
public class SignUpService implements IF_SignUpService {
    private final IF_SignUpDao signUpDao;
    private final PasswordEncoder passwordEncoder;

    public SignUpService(IF_SignUpDao signUpDao, PasswordEncoder passwordEncoder) {
        this.signUpDao = signUpDao;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public int dupCheckId(String dupCheckId) {
        try {
            return signUpDao.dupCheckId(dupCheckId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public int insMember(MemberDTO member) {
        try {
            // 🔥 비밀번호 암호화
            String encodedPassword = passwordEncoder.encode(member.getMemberPw());
            member.setMemberPw(encodedPassword); // 암호화된 비밀번호 저장

            return signUpDao.insMember(member);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    @Transactional
    public int insPreference(Map<String, Object> map) {
        try {
            return signUpDao.insPreference(map);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
