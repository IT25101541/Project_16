package model;

/**
 * CartItem - Encapsulates product reference and quantity in a cart.
 */
public class CartItem {
    private String productId;
    private String productName;
    private int quantity;
    private double unitPrice;
    private double discountPercent; // for clearance items

    public CartItem() {}

    public CartItem(String productId, String productName, int quantity, double unitPrice, double discountPercent) {
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.discountPercent = discountPercent;
    }

    public double getSubtotal() {
        double discounted = unitPrice * (1 - discountPercent / 100.0);
        return discounted * quantity;
    }

    public double getOriginalSubtotal() {
        return unitPrice * quantity;
    }

    public double getSavings() {
        return getOriginalSubtotal() - getSubtotal();
    }

    // Getters and Setters
    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

    public String toFileString() {
        return productId + "|" + productName + "|" + quantity + "|" + unitPrice + "|" + discountPercent;
    }

    public static CartItem fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 5) return null;
        return new CartItem(p[0], p[1], Integer.parseInt(p[2]), Double.parseDouble(p[3]), Double.parseDouble(p[4]));
    }
}
