package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.IF_historyDao;
import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class HistoryService_Impl implements IF_historyService{
    private final IF_historyDao historyDao;

    @Autowired
    public HistoryService_Impl(IF_historyDao historyDao) {
        this.historyDao = historyDao;
    }

    @Transactional
    @Override
    public List<ForeignPlanDTO> findPlansByMemberId(String memberId) throws Exception {
        // SQL 쿼리 실행 전 로그
        System.out.println("=== HistoryService_Impl ===");
        System.out.println("Searching plans for memberId: " + memberId);

        // memberId로 여행 계획을 조회하는 부분
        List<ForeignPlanDTO> plans = historyDao.findPlansByMemberId(memberId);

        // 결과 데이터 상세 로그
        if (plans == null) {
            System.out.println("Result is null");
        } else {
            System.out.println("Found " + plans.size() + " plans");
            plans.forEach(plan -> System.out.println("Plan: " + plan));
        }

        return plans; // 정상적으로 조회된 여행 계획 리스트를 반환
    }

    @Transactional
    @Override
    public Map<String, Object> getPlanDetails(Long planId) throws Exception {
        return historyDao.getPlanDetails(planId);
    }
}
