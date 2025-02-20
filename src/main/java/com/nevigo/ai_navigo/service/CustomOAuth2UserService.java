package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.MemberDTO;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.Map;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    private final IF_LoginService loginService;
    private final SqlSession sqlSession;
    private final HttpSession session;

    public CustomOAuth2UserService(SqlSession sqlSession, IF_LoginService loginService, HttpSession session) {
        this.sqlSession = sqlSession;
        this.loginService = loginService;
        this.session = session;
    }

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        Map<String, Object> attributes = oAuth2User.getAttributes();
        String userName = (String) attributes.get("name");
        String email = (String) attributes.get("email");
        String id = (String) attributes.get("sub");

        // 구글 로그인 시 사용자 정보 저장
        MemberDTO member = new MemberDTO();
        member.setMemberId(id);
        member.setMemberEmail(email);
        member.setMemberName(userName);
        member.setMemberGender("O");

        // 사용자 정보를 세션에 저장
        session.setAttribute("oauthUser", oAuth2User);

        // DB에 사용자 정보가 있는지 확인
        if (loginService.isMemberId(member) == 1) {
            // 회원이 있으면 세션에 회원 정보 저장
            try {
                MemberDTO memberDTO = sqlSession.selectOne("getMemberInfoGoogle", member);
                session.setAttribute("memberInfo", memberDTO);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // 회원이 없으면 임시 세션에 회원 정보 저장
            session.setAttribute("temp", member);
        }

        return oAuth2User; // 리디렉션은 SecurityFilterChain에서 처리
    }
}

