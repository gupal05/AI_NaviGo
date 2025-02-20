package com.nevigo.ai_navigo.dao;

import com.nevigo.ai_navigo.dto.ForeignActivityDTO;
import com.nevigo.ai_navigo.dto.ForeignPlacePhotoDTO;
import com.nevigo.ai_navigo.dto.ForeignPlanDTO;
import com.nevigo.ai_navigo.dto.ForeignScheduleDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface IF_ForeignPlanDao {
    // Existing core CRUD methods
    int insertPlan(ForeignPlanDTO planDTO);
    int insertSchedule(ForeignScheduleDTO scheduleDTO);
    int insertActivity(ForeignActivityDTO activityDTO);

    // Existing retrieval methods
    ForeignPlanDTO getPlan(Long planId);
    List<ForeignPlanDTO> getPlanList(String memberId);
    List<ForeignScheduleDTO> getSchedulesByPlanId(Long planId);
    List<ForeignActivityDTO> getActivitiesByScheduleId(Long scheduleId);

    // Additional methods to support new service implementation
    Long getLastInsertedPlanId(); // Retrieve the most recently inserted plan's ID

    // Optional: Method to check if a plan exists (could be useful for validation)
    boolean planExists(Long planId);

    void insertPlacePhotos(List<ForeignPlacePhotoDTO> photos);

    List<ForeignPlacePhotoDTO> getPlacePhotosByPlanId(Long planId);
}