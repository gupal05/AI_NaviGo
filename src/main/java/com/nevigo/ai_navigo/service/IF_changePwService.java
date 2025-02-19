package com.nevigo.ai_navigo.service;
import jakarta.servlet.http.HttpSession;

public interface IF_changePwService {
    boolean updatePassword(String userId, String newPw, HttpSession session) throws Exception;
}
