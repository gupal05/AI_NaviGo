package com.nevigo.ai_navigo.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface IF_changePwDao {
    // 비밀번호 업데이트
    void updatePassword(@Param("memberId") String memberId, @Param("newPw") String newPw);
}