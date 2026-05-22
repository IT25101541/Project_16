package com.yourteam.grocerymanagement.model;

/**
 * FlashSalePolicy – Inherits from StockClearance.
 * Demonstrates Polymorphism: flat high discount for flash sales.
 */
public class FlashSalePolicy extends StockClearance {

    private double flashDiscountRate;

    public FlashSalePolicy() { super(); this.flashDiscountRate = 40.0; }

    public FlashSalePolicy(double flashDiscountRate) {
        super();
        this.flashDiscountRate = flashDiscountRate;
    }

    @Override
    public double calculateDiscount(int daysToExpiry) {
        return flashDiscountRate; // Always flat flash discount regardless of expiry
    }
}
