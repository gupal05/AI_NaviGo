package com.nevigo.ai_navigo.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@ToString
public class ForeignPlanDTO {
    // DB 테이블과 매핑되는 필드들
    private Long planId;
    private String memberId;
    private String destination;        // DB의 destination 컬럼과 매핑
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalDateTime createdAt;
    private LocalDateTime uptDate;

    // Python 서버 통신용 필드들
    private DestinationDTO destinationDetail;  // 위도/경도 정보
    private int budget;
    private List<String> themes;
    private TravelersDTO travelers;
    private TravelSummaryDTO summary;
    private List<ForeignScheduleDTO> dailySchedule;

    // destination과 destinationDetail 간의 변환을 위한 메서드
    public void setDestinationFromDetail() {
        if (this.destinationDetail != null) {
            this.destination = this.destinationDetail.getName();
        }
    }
}
