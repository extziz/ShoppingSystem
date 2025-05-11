package com.softserve.academy.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Configuration class for Spring MVC.
 * This class configures the static resources mapping.
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    /**
     * Configure static resource handlers for serving CSS, JavaScript, images, etc.
     * 
     * @param registry the ResourceHandlerRegistry to configure
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Map URL path /resources/** to the physical location /webapp/resources/
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/", "/webapp/resources/", "classpath:/META-INF/resources/");
    }
}
