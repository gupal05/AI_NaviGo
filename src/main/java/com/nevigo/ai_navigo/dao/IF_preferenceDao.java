package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.UserClickDTO;
import lombok.ToString;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Mapper
@Repository
public interface IF_preferenceDao {

    public String getPreferenceById(String memberId);
    public void setUserClickInfo(UserClickDTO userclickdto);
    public String getPopularCat3();
    public List<Map<String, Object>> getPopularTitle10();

}
