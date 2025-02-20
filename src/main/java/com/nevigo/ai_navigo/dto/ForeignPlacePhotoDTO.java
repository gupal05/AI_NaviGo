package com.nevigo.ai_navigo.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class ForeignPlacePhotoDTO {
    private Long photoId;
    private String placeName;
    private String photoUrl;
    private Long planId;
    private LocalDateTime createdAt;
}
