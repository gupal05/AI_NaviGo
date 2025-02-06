package com.nevigo.ai_navigo.dto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.util.ArrayList;

@Getter
@Setter
@ToString
public class MemberDTO {
    private String memberId;
    private String memberName;
    private String memberPw;
    private String memberGender;
    private String memberGrade;

    private ArrayList<PreferenceDTO> preferences;
}