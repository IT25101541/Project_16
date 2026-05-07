package com.yourteam.grocerymanagement.model;

/**
 * StandardDelivery – Inherits from Delivery.
 * Demonstrates Inheritance and Polymorphism (calculateDeliveryFee override).
 */
public class StandardDelivery extends Delivery {

    public StandardDelivery() { super(); }

    public StandardDelivery(String deliveryId, String orderId, String deliveryAddress,
                            String status, String assignedDate, String driverName,
                            String driverPhone, String vehicleNumber, String gpsLocation, String userId) {
        super(deliveryId, orderId, deliveryAddress, status, assignedDate,
              driverName, driverPhone, vehicleNumber, gpsLocation, userId);
    }

    @Override
    public double calculateDeliveryFee() {
        return 150.00; // LKR 150 standard fee
    }
}
