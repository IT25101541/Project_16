package com.yourteam.grocerymanagement.service;

import com.yourteam.grocerymanagement.model.StockClearance;
import com.yourteam.grocerymanagement.util.FileHandler;
import com.yourteam.grocerymanagement.util.IdGenerator;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * StockClearanceService – manages near-expiry product discounts.
 * ClearanceService calculates discounts internally (Abstraction).
 */
public class StockClearanceService {

    private final FileHandler fileHandler;

    public StockClearanceService(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    // ─── CREATE ────────────────────────────────────────────────────────────────

    public StockClearance addClearanceRecord(String productId, String productName,
                                             String expiryDate, String manufactureDate,
                                             double originalPrice, String stockCondition,
                                             int stockQuantity) {
        long daysToExpiry = calculateDaysToExpiry(expiryDate);
        double discountPct = calculateDiscount(daysToExpiry);
        double clearancePrice = originalPrice * (1 - discountPct / 100.0);

        StockClearance sc = new StockClearance(
            IdGenerator.clearanceId(), productId, productName,
            expiryDate, manufactureDate, originalPrice,
            discountPct, clearancePrice, stockCondition, true, stockQuantity
        );
        fileHandler.writeToFile(sc.toFileString());
        return sc;
    }

    // ─── READ ──────────────────────────────────────────────────────────────────

    public List<StockClearance> getAllClearanceItems() {
        List<StockClearance> list = new ArrayList<>();
        for (String line : fileHandler.readFromFile()) {
            StockClearance sc = StockClearance.fromFileString(line);
            if (sc != null) list.add(sc);
        }
        return list;
    }

    public StockClearance getClearanceById(String clearanceId) {
        for (StockClearance sc : getAllClearanceItems()) {
            if (sc.getClearanceId().equals(clearanceId)) return sc;
        }
        return null;
    }

    public StockClearance getClearanceByProductId(String productId) {
        for (StockClearance sc : getAllClearanceItems()) {
            if (sc.getProductId().equals(productId)) return sc;
        }
        return null;
    }

    public List<StockClearance> getActiveClearanceItems() {
        return getAllClearanceItems().stream()
                .filter(StockClearance::isDiscountApplied)
                .collect(Collectors.toList());
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    public boolean updateExpiryStatus(String clearanceId) {
        StockClearance sc = getClearanceById(clearanceId);
        if (sc == null) return false;
        long days = calculateDaysToExpiry(sc.getExpiryDate());
        double newDiscount = calculateDiscount(days);
        sc.setDiscountPercentage(newDiscount);
        sc.setClearancePrice(sc.getOriginalPrice() * (1 - newDiscount / 100.0));
        return fileHandler.updateRecord(clearanceId, sc.toFileString());
    }

    public boolean updatePricing(String clearanceId, double discountPercentage) {
        StockClearance sc = getClearanceById(clearanceId);
        if (sc == null) return false;
        sc.setDiscountPercentage(discountPercentage);
        sc.setClearancePrice(sc.getOriginalPrice() * (1 - discountPercentage / 100.0));
        return fileHandler.updateRecord(clearanceId, sc.toFileString());
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public boolean removeClearance(String clearanceId) {
        return fileHandler.deleteRecord(clearanceId);
    }

    public boolean deactivateClearance(String clearanceId) {
        StockClearance sc = getClearanceById(clearanceId);
        if (sc == null) return false;
        sc.setDiscountApplied(false);
        return fileHandler.updateRecord(clearanceId, sc.toFileString());
    }

    // ─── HELPERS ───────────────────────────────────────────────────────────────

    public long calculateDaysToExpiry(String expiryDate) {
        try {
            LocalDate expiry = LocalDate.parse(expiryDate);
            return ChronoUnit.DAYS.between(LocalDate.now(), expiry);
        } catch (Exception e) {
            return 999;
        }
    }

    /**
     * Polymorphism: discount scales with urgency.
     * 7 days → 10%, 3 days → 30%, etc.
     */
    public double calculateDiscount(long daysToExpiry) {
        if (daysToExpiry <= 1)  return 50.0;
        if (daysToExpiry <= 3)  return 35.0;
        if (daysToExpiry <= 7)  return 20.0;
        if (daysToExpiry <= 14) return 10.0;
        return 5.0;
    }

    public String getExpiryLabel(long days) {
        if (days <= 1)  return "Expires TODAY";
        if (days <= 3)  return "Expires in " + days + " days";
        if (days <= 7)  return "Expires this week";
        if (days <= 14) return "Expires in 2 weeks";
        return "In stock";
    }
}
