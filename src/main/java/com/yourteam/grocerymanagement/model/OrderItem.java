package com.yourteam.grocerymanagement.model;

/**
 * OrderItem - snapshot of a purchased item.
 */
public class OrderItem {
    private String productId;
    private String productName;
    private int quantity;
    private double price;
    private double discountPercent;

    public OrderItem() {}

    public OrderItem(String productId, String productName, int quantity, double price, double discountPercent) {
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.price = price;
        this.discountPercent = discountPercent;
    }

    public double getSubtotal() {
        return price * (1 - discountPercent / 100.0) * quantity;
    }

    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

    public String toFileString() {
        return productId + "~" + productName + "~" + quantity + "~" + price + "~" + discountPercent;
    }

    public static OrderItem fromFileString(String s) {
        String[] p = s.split("~", -1);
        if (p.length < 5) return null;
        return new OrderItem(p[0], p[1], Integer.parseInt(p[2]), Double.parseDouble(p[3]), Double.parseDouble(p[4]));
    }
}
