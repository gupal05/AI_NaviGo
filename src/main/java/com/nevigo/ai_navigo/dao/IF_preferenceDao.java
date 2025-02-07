package com.nevigo.ai_navigo.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface IF_preferenceDao {

    public String getPreferenceById(String memberId);

}
