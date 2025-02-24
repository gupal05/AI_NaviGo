package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface IF_historyService {
    List<ForeignPlanDTO> findPlansByMemberId(String memberId) throws Exception;
    Map<String, Object> getPlanDetails(Long planId) throws Exception;
}
