package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.UserClickDTO;

import java.util.List;
import java.util.Map;

public interface IF_preferenceService {

    public String getPreferenceById(String memberId) throws Exception;
    public void clickTravelOne(UserClickDTO userclickdto) throws Exception;
    public String getPopularCat3() throws Exception;
    // 인기 여행지 Top 10 조회
    public List<Map<String, Object>> getPopularTitle10() throws Exception;
}
