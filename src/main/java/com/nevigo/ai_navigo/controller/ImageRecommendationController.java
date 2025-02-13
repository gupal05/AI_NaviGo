package com.nevigo.ai_navigo.controller;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Map;

@Controller
public class ImageRecommendationController {

    @GetMapping("/imageRecommendation")
    public String imageRecommendation() {
        return "/imgRe/imageRecommendation";
    }

    @PostMapping("/upload")
    @ResponseBody
    public ResponseEntity<?> handleImageUpload(@RequestParam("image") MultipartFile file) {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("파일이 없습니다.");
        }

        try {
            // 최대 허용 크기 (10MB로 설정)
            final long MAX_FILE_SIZE = 10 * 1024 * 1024;

            byte[] imageBytes = file.getBytes();
            if (file.getSize() > MAX_FILE_SIZE) {
                // 이미지 리사이징
                imageBytes = resizeImage(file);
            }

            // FastAPI 서버로 이미지 전송
            String fastApiUrl = "http://localhost:8000/analyze";
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("image", new ByteArrayResource(imageBytes) {
                @Override
                public String getFilename() {
                    return file.getOriginalFilename();
                }
            });

            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<Map> response = restTemplate.postForEntity(fastApiUrl, requestEntity, Map.class);

            return ResponseEntity.ok(response.getBody());
        } catch (MaxUploadSizeExceededException e) {
            return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).body("업로드한 파일이 너무 큽니다. (최대 10MB)");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이미지 처리 중 오류 발생: " + e.getMessage()));
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이미지 처리 중 오류 발생: " + e.getMessage());
        }
    }

    // 이미지 리사이징 메서드 (너비 800px, 비율 유지)
    private byte[] resizeImage(MultipartFile file) throws IOException {
        BufferedImage originalImage = ImageIO.read(file.getInputStream());
        int targetWidth = 800;
        int targetHeight = (int) (originalImage.getHeight() * (800.0 / originalImage.getWidth()));

        BufferedImage resizedImage = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = resizedImage.createGraphics();
        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2d.drawImage(originalImage, 0, 0, targetWidth, targetHeight, null);
        g2d.dispose();

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(resizedImage, "jpg", baos);
        return baos.toByteArray();
    }

}
