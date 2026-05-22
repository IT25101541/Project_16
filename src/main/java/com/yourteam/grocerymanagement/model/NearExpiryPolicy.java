package com.yourteam.grocerymanagement.model;

/**
 * NearExpiryPolicy – Inherits from StockClearance.
 * Demonstrates Inheritance and Polymorphism.
 */
public class NearExpiryPolicy extends StockClearance {

    public NearExpiryPolicy() { super(); }

    /**
     * Polymorphism: Graduated discount based on days remaining.
     */
    @Override
    public double calculateDiscount(int daysToExpiry) {
        if (daysToExpiry <= 1) return 50.0;
        if (daysToExpiry <= 3) return 35.0;
        if (daysToExpiry <= 7) return 20.0;
        if (daysToExpiry <= 14) return 10.0;
        return 5.0;
    }
}
