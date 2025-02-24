package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Mapper
@Repository
@Component
public interface IF_historyDao {
    // 회원 ID별 여행 일정 조회
    public List<ForeignPlanDTO> findPlansByMemberId(String memberId);
    // 여행 일정 상세 정보 조회
    public Map<String, Object> getPlanDetails(Long planId);
}
