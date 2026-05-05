package model;

/**
 * GroceryProduct - Inherits from Product.
 * Demonstrates Inheritance and Polymorphism (calculateFinalPrice override).
 */
public class GroceryProduct extends Product {
    private boolean organic;

    public GroceryProduct() { super(); }

    public GroceryProduct(String productId, String name, String category, double price,
                          int stockQuantity, String expiryDate, String manufactureDate,
                          String imageUrl, boolean organic) {
        super(productId, name, category, price, stockQuantity, expiryDate, manufactureDate, imageUrl);
        this.organic = organic;
    }

    public boolean isOrganic() { return organic; }
    public void setOrganic(boolean organic) { this.organic = organic; }

    /**
     * Polymorphism: Organic products have a 5% premium.
     */
    @Override
    public double calculateFinalPrice() {
        return organic ? getPrice() * 1.05 : getPrice();
    }
}
