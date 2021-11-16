package org.solent.oodd.ae1.web.spring.web;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Used to setup the application and scan base packages
 * @author Will
 */
@SpringBootApplication(scanBasePackages = "org.solent.oodd.ae1.web.spring.web")
public class SpringBootJspApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(SpringBootJspApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(SpringBootJspApplication.class);
    }
}