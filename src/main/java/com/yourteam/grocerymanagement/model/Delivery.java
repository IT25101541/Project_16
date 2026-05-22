package com.yourteam.grocerymanagement.model;

/**
 * Delivery model – encapsulates all delivery-related data.
 * StandardDelivery and ExpressDelivery inherit from this.
 */
public class Delivery {
    private String deliveryId;
    private String orderId;
    private String deliveryAddress;
    private String status; // ASSIGNED, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
    private String assignedDate;
    private String driverName;
    private String driverPhone;
    private String vehicleNumber;
    private String gpsLocation; // "lat,lng" string
    private String userId;

    public Delivery() {}

    public Delivery(String deliveryId, String orderId, String deliveryAddress, String status,
                    String assignedDate, String driverName, String driverPhone,
                    String vehicleNumber, String gpsLocation, String userId) {
        this.deliveryId = deliveryId;
        this.orderId = orderId;
        this.deliveryAddress = deliveryAddress;
        this.status = status;
        this.assignedDate = assignedDate;
        this.driverName = driverName;
        this.driverPhone = driverPhone;
        this.vehicleNumber = vehicleNumber;
        this.gpsLocation = gpsLocation;
        this.userId = userId;
    }

    // Polymorphism – subclasses override this
    public double calculateDeliveryFee() {
        return 150.00; // Default standard delivery fee (LKR)
    }

    // Getters and Setters
    public String getDeliveryId() { return deliveryId; }
    public void setDeliveryId(String deliveryId) { this.deliveryId = deliveryId; }
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAssignedDate() { return assignedDate; }
    public void setAssignedDate(String assignedDate) { this.assignedDate = assignedDate; }
    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }
    public String getDriverPhone() { return driverPhone; }
    public void setDriverPhone(String driverPhone) { this.driverPhone = driverPhone; }
    public String getVehicleNumber() { return vehicleNumber; }
    public void setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }
    public String getGpsLocation() { return gpsLocation; }
    public void setGpsLocation(String gpsLocation) { this.gpsLocation = gpsLocation; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String toFileString() {
        return deliveryId + "|" + orderId + "|" + deliveryAddress + "|" + status + "|" +
               assignedDate + "|" + driverName + "|" + driverPhone + "|" +
               vehicleNumber + "|" + (gpsLocation != null ? gpsLocation : "") + "|" + userId;
    }

    public static Delivery fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 10) return null;
        return new Delivery(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
    }
}
