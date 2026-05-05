package model;

/**
 * BeverageProduct - Inherits from Product.
 * Demonstrates Inheritance and Polymorphism.
 */
public class BeverageProduct extends Product {
    private double volumeMl;

    public BeverageProduct() { super(); }

    public BeverageProduct(String productId, String name, String category, double price,
                           int stockQuantity, String expiryDate, String manufactureDate,
                           String imageUrl, double volumeMl) {
        super(productId, name, category, price, stockQuantity, expiryDate, manufactureDate, imageUrl);
        this.volumeMl = volumeMl;
    }

    public double getVolumeMl() { return volumeMl; }
    public void setVolumeMl(double volumeMl) { this.volumeMl = volumeMl; }

    /**
     * Polymorphism: Price per ml calculation for beverages.
     */
    @Override
    public double calculateFinalPrice() {
        return getPrice(); // Could add volume-based pricing logic here
    }
}
