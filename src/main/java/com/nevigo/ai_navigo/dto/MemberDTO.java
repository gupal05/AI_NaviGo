package com.nevigo.ai_navigo.dto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@ToString
public class MemberDTO {
    private String memberId;
    private String memberName;
    private String memberPw;
    private String memberEmail;
    private String memberGender;
    private String memberGrade;
}
