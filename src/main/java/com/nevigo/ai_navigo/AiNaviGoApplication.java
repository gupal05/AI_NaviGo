package com.nevigo.ai_navigo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = SecurityAutoConfiguration.class)
public class AiNaviGoApplication {

    public static void main(String[] args) {
        SpringApplication.run(AiNaviGoApplication.class, args);
    }

}
