package com.nevigo.ai_navigo.dto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@ToString
public class MemberDTO {
    private String member_id;
    private String member_name;
    private String member_pw;
    private String member_gender;
    private String member_grade;
}