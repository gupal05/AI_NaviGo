package com.nevigo.ai_navigo.handler;

import com.nevigo.ai_navigo.dto.MemberDTO;
import com.nevigo.ai_navigo.service.IF_LoginService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final IF_LoginService loginService;
    private final HttpSession session;
    private final SqlSession sqlSession;

    public CustomAuthenticationSuccessHandler(IF_LoginService loginService, SqlSession sqlSession, HttpSession session) {
        this.loginService = loginService;
        this.sqlSession = sqlSession;
        this.session = session;
    }

    @Override
    @Transactional
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        String userId = (String) oAuth2User.getAttributes().get("sub"); // 구글에서 제공하는 고유 ID
        String userName = (String) oAuth2User.getAttributes().get("name");
        String email = (String) oAuth2User.getAttributes().get("email");

        MemberDTO member = new MemberDTO();
        member.setMemberId(userId);
        member.setMemberName(userName);
        member.setMemberEmail(email);
        member.setMemberGender("O");

        // 회원이 DB에 있는지 확인
        if (loginService.isMemberId(member) == 1) {
            // 회원이 있으면 /main으로 리디렉션
            MemberDTO memberDTO = sqlSession.selectOne("getMemberInfoGoogle", member);
            session.setAttribute("memberInfo", memberDTO);
            response.sendRedirect("/main");
        } else {
            // 회원이 없으면 /auth/googleSignUpResult로 리디렉션
            if(sqlSession.insert("insMemberGoogle", member) > 0) {
                session.setAttribute("temp", member);
                response.sendRedirect("/auth/googleSignUpResult");
            }
        }
    }
}

