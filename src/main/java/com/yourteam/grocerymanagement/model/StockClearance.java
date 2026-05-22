package com.yourteam.grocerymanagement.model;

/**
 * StockClearance – manages near-expiry discounted products.
 * NearExpiryPolicy and FlashSalePolicy extend this.
 */
public class StockClearance {
    private String clearanceId;
    private String productId;
    private String productName;
    private String expiryDate;
    private String manufactureDate;
    private double originalPrice;
    private double discountPercentage;
    private double clearancePrice;
    private String stockCondition; // LOW, MEDIUM, HIGH
    private boolean isDiscountApplied;
    private int stockQuantity;

    public StockClearance() {}

    public StockClearance(String clearanceId, String productId, String productName,
                          String expiryDate, String manufactureDate, double originalPrice,
                          double discountPercentage, double clearancePrice,
                          String stockCondition, boolean isDiscountApplied, int stockQuantity) {
        this.clearanceId = clearanceId;
        this.productId = productId;
        this.productName = productName;
        this.expiryDate = expiryDate;
        this.manufactureDate = manufactureDate;
        this.originalPrice = originalPrice;
        this.discountPercentage = discountPercentage;
        this.clearancePrice = clearancePrice;
        this.stockCondition = stockCondition;
        this.isDiscountApplied = isDiscountApplied;
        this.stockQuantity = stockQuantity;
    }

    // Polymorphism – subclasses override this
    public double calculateDiscount(int daysToExpiry) {
        if (daysToExpiry <= 3) return 30.0;
        if (daysToExpiry <= 7) return 20.0;
        if (daysToExpiry <= 14) return 10.0;
        return 5.0;
    }

    // Getters and Setters
    public String getClearanceId() { return clearanceId; }
    public void setClearanceId(String clearanceId) { this.clearanceId = clearanceId; }
    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String expiryDate) { this.expiryDate = expiryDate; }
    public String getManufactureDate() { return manufactureDate; }
    public void setManufactureDate(String manufactureDate) { this.manufactureDate = manufactureDate; }
    public double getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(double originalPrice) { this.originalPrice = originalPrice; }
    public double getDiscountPercentage() { return discountPercentage; }
    public void setDiscountPercentage(double discountPercentage) { this.discountPercentage = discountPercentage; }
    public double getClearancePrice() { return clearancePrice; }
    public void setClearancePrice(double clearancePrice) { this.clearancePrice = clearancePrice; }
    public String getStockCondition() { return stockCondition; }
    public void setStockCondition(String stockCondition) { this.stockCondition = stockCondition; }
    public boolean isDiscountApplied() { return isDiscountApplied; }
    public void setDiscountApplied(boolean discountApplied) { isDiscountApplied = discountApplied; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String toFileString() {
        return clearanceId + "|" + productId + "|" + productName + "|" + expiryDate + "|" +
               manufactureDate + "|" + originalPrice + "|" + discountPercentage + "|" +
               clearancePrice + "|" + stockCondition + "|" + isDiscountApplied + "|" + stockQuantity;
    }

    public static StockClearance fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 11) return null;
        return new StockClearance(p[0], p[1], p[2], p[3], p[4],
                Double.parseDouble(p[5]), Double.parseDouble(p[6]),
                Double.parseDouble(p[7]), p[8], Boolean.parseBoolean(p[9]),
                Integer.parseInt(p[10]));
    }
}
