package com.convergence.ecommerce.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class ExternalProductClient {

    private final RestTemplate restTemplate;
    private final String externalProductUrl;

    public ExternalProductClient(
            RestTemplate restTemplate,
            @Value("${external.product-url}") String externalProductUrl) {
        this.restTemplate = restTemplate;
        this.externalProductUrl = externalProductUrl;
    }

    public ExternalProductResponse getProduct() {
        return restTemplate.getForObject(externalProductUrl, ExternalProductResponse.class);
    }

    public record ExternalProductResponse(
            Long id,
            String title,
            String description,
            Double price,
            String category,
            Integer stock) {
    }
}
