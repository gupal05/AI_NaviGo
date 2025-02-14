package com.nevigo.ai_navigo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.nevigo.ai_navigo.dao.IF_preferenceDao; // 실제 DAO 경로에 맞게 수정하세요.
import com.nevigo.ai_navigo.dto.UserClickDTO;

@Service
public class PreferenceService_Impl implements IF_preferenceService {
    //

    private final IF_preferenceDao preferenceDao;  // 실제 DAO 클래스를 주입

    @Autowired
    public PreferenceService_Impl(IF_preferenceDao preferenceDao) {
        this.preferenceDao = preferenceDao;
    }

    // 사용자 ID로 선호도 정보 가져오기
    @Override
    public String getPreferenceById(String memberId) throws Exception {
        // DAO에서 회원의 선호도 정보 가져오기 (여기서 DB 쿼리 실행)
        String preference = preferenceDao.getPreferenceById(memberId);
        return preference != null ? preference : "선택된 카테고리가 없습니다.";  // 값이 없을 경우 기본 메시지 반환
    }

    // 여행 클릭 정보 처리
    @Override
    public void clickTravelOne(UserClickDTO userClickDto) throws Exception {
        // 클릭 정보를 처리하는 로직 (예: 클릭 카운트 증가 등)
        preferenceDao.setUserClickInfo(userClickDto);
    }

    // 인기 카테고리 가져오기
    @Override
    public String getPopularCat3() throws Exception {
        // DAO에서 인기 카테고리 정보 가져오기
        //return preferenceDao.getPopularCategory();
        return preferenceDao.getPopularCat3();
    }
}