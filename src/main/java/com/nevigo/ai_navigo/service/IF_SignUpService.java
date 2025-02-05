package com.nevigo.ai_navigo.service;

import com.nevigo.ai_navigo.dto.MemberDTO;

public interface IF_SignUpService {
    public int dupCheckId(String dupCheckId);
    public int insMember(MemberDTO member);
}