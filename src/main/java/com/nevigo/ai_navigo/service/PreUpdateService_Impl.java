package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dao.PreferenceDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class PreUpdateService_Impl implements IF_preferenceUpdateService {
    //

    private final PreferenceDao preferenceDao;  // 실제 DAO 클래스를 주입

    @Autowired
    public PreUpdateService_Impl(PreferenceDao preferenceDao) {
        this.preferenceDao = preferenceDao;
    }


    public void saveOrUpdatePreference(String memberId, String preference) throws Exception {
        String existingPreference = preferenceDao.getPreferenceById(memberId);
        if (existingPreference != null) {
            preferenceDao.updatePreference(memberId, preference);
        } else {
            preferenceDao.insertPreference(memberId, preference);
        }
        System.out.println("Saving preference for memberId: " + memberId + ", preference: " + preference);

    }

}

