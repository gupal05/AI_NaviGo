package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.MemberDTO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

@Service
public class FindMemberService {
    private final SqlSession sqlSession;
    private final PasswordEncoder passwordEncoder;

    public FindMemberService(SqlSession sqlSession, PasswordEncoder passwordEncoder) {
        this.sqlSession = sqlSession;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public ModelAndView findMemberId(ModelAndView mav) {
        MemberDTO member = (MemberDTO) mav.getModel().get("member");
        try{
            if((int)sqlSession.selectOne("isFindMemberId", member) != 0){
                mav.addObject("memberId", sqlSession.selectOne("getFindMemberId", member));
            } else {
                mav.addObject("memberId", null);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        mav.setViewName("auth/findIdResult");
        return mav;
    }

    @Transactional
    public ModelAndView findMemberPw(ModelAndView mav) {
        MemberDTO member = (MemberDTO) mav.getModel().get("member");
        try{
            if((int)sqlSession.selectOne("isFindMemberPw", member) != 0){
                mav.addObject("memberId", sqlSession.selectOne("getFindMemberPw", member));
            } else {
                mav.addObject("memberId", null);
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        mav.setViewName("auth/findPwResult");
        return mav;
    }

    @Transactional
    public String changeMemberPw(MemberDTO member){
        String message = null;
        try{
            String encodedPassword = passwordEncoder.encode(member.getMemberPw());
            member.setMemberPw(encodedPassword);
            if(sqlSession.update("changeFindMemberPw", member) != 0){
                message = "비밀번호가 변경 되었습니다.";
            }else{
                message = "잠시 후에 다시 시도 해주십시오.";
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return message;
    }
}
