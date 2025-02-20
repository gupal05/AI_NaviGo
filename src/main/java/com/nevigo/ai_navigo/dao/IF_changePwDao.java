package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface IF_changePwDao {
    // 비밀번호 업데이트
    void updatePassword(@Param("userId") String userId, @Param("newPw") String newPw);
}