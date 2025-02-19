package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.UserClickDTO;

import java.util.List;
import java.util.Map;

public interface IF_preferenceUpdateService {
    public void saveOrUpdatePreference(String memberId, String preference) throws Exception;
}
