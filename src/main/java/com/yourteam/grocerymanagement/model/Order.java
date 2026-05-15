package com.yourteam.grocerymanagement.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Order model – Encapsulates order data.
 * OnlineOrder and InStoreOrder extend this.
 */
public class Order {
    private String orderId;
    private String userId;
    private String username;
    private List<OrderItem> items;
    private String status; // PENDING, PROCESSING, READY, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
    private String orderDate;
    private double totalAmount;
    private String fulfillmentType; // DELIVERY or PICKUP
    private String deliveryAddress;
    private String postalCode;
    private String district;
    private String province;
    private String mobileNumber;

    public Order() { this.items = new ArrayList<>(); }

    public Order(String orderId, String userId, String username, List<OrderItem> items,
                 String status, String orderDate, double totalAmount,
                 String fulfillmentType, String deliveryAddress,
                 String postalCode, String district, String province, String mobileNumber) {
        this.orderId = orderId;
        this.userId = userId;
        this.username = username;
        this.items = items != null ? items : new ArrayList<>();
        this.status = status;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.fulfillmentType = fulfillmentType;
        this.deliveryAddress = deliveryAddress;
        this.postalCode = postalCode;
        this.district = district;
        this.province = province;
        this.mobileNumber = mobileNumber;
    }

    // Polymorphism – subclasses override processOrder()
    public void processOrder() {
        this.status = "PROCESSING";
    }

    // Getters and Setters
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getFulfillmentType() { return fulfillmentType; }
    public void setFulfillmentType(String fulfillmentType) { this.fulfillmentType = fulfillmentType; }
    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }
    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }

    /**
     * Serialize items list to string for file storage
     */
    public String itemsToString() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < items.size(); i++) {
            sb.append(items.get(i).toFileString());
            if (i < items.size() - 1) sb.append(";");
        }
        return sb.toString();
    }

    public String toFileString() {
        return orderId + "|" + userId + "|" + username + "|" + itemsToString() + "|" +
               status + "|" + orderDate + "|" + totalAmount + "|" + fulfillmentType + "|" +
               (deliveryAddress != null ? deliveryAddress : "") + "|" +
               (postalCode != null ? postalCode : "") + "|" +
               (district != null ? district : "") + "|" +
               (province != null ? province : "") + "|" +
               (mobileNumber != null ? mobileNumber : "");
    }

    public static Order fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 13) return null;
        List<OrderItem> items = new ArrayList<>();
        if (!p[3].isEmpty()) {
            for (String s : p[3].split(";")) {
                OrderItem oi = OrderItem.fromFileString(s);
                if (oi != null) items.add(oi);
            }
        }
        return new Order(p[0], p[1], p[2], items, p[4], p[5],
                Double.parseDouble(p[6]), p[7], p[8], p[9], p[10], p[11], p[12]);
    }
}
