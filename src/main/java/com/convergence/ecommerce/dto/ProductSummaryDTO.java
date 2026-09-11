package com.convergence.ecommerce.dto;

public class ProductSummaryDTO {

    private ProductResponseDTO product;
    private Double referencePrice;
    private Double priceDifference;
    private String externalSource;

    public ProductResponseDTO getProduct() {
        return product;
    }

    public void setProduct(ProductResponseDTO product) {
        this.product = product;
    }

    public Double getReferencePrice() {
        return referencePrice;
    }

    public void setReferencePrice(Double referencePrice) {
        this.referencePrice = referencePrice;
    }

    public Double getPriceDifference() {
        return priceDifference;
    }

    public void setPriceDifference(Double priceDifference) {
        this.priceDifference = priceDifference;
    }

    public String getExternalSource() {
        return externalSource;
    }

    public void setExternalSource(String externalSource) {
        this.externalSource = externalSource;
    }
}
