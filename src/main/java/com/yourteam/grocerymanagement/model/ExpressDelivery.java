package com.yourteam.grocerymanagement.model;

/**
 * ExpressDelivery – Inherits from Delivery.
 * Demonstrates Polymorphism: higher delivery fee for express.
 */
public class ExpressDelivery extends Delivery {

    public ExpressDelivery() { super(); }

    public ExpressDelivery(String deliveryId, String orderId, String deliveryAddress,
                           String status, String assignedDate, String driverName,
                           String driverPhone, String vehicleNumber, String gpsLocation, String userId) {
        super(deliveryId, orderId, deliveryAddress, status, assignedDate,
              driverName, driverPhone, vehicleNumber, gpsLocation, userId);
    }

    @Override
    public double calculateDeliveryFee() {
        return 350.00; // LKR 350 express fee
    }
}
