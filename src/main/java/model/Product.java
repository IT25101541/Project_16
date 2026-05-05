package model;

/**
 * Base Product class - demonstrates Encapsulation.
 * GroceryProduct and BeverageProduct extend this (Inheritance).
 */
public class Product {
    private String productId;
    private String name;
    private String category;
    private double price;
    private int stockQuantity;
    private String expiryDate;   // yyyy-MM-dd
    private String manufactureDate; // yyyy-MM-dd
    private String imageUrl;

    public Product() {}

    public Product(String productId, String name, String category, double price,
                   int stockQuantity, String expiryDate, String manufactureDate, String imageUrl) {
        this.productId = productId;
        this.name = name;
        this.category = category;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.expiryDate = expiryDate;
        this.manufactureDate = manufactureDate;
        this.imageUrl = imageUrl;
    }

    // Polymorphism – subclasses may override this
    public double calculateFinalPrice() {
        return this.price;
    }

    // Getters and Setters
    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String expiryDate) { this.expiryDate = expiryDate; }

    public String getManufactureDate() { return manufactureDate; }
    public void setManufactureDate(String manufactureDate) { this.manufactureDate = manufactureDate; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String toFileString() {
        return productId + "|" + name + "|" + category + "|" + price + "|" +
               stockQuantity + "|" + expiryDate + "|" + manufactureDate + "|" + imageUrl;
    }

    public static Product fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 8) return null;
        return new Product(p[0], p[1], p[2], Double.parseDouble(p[3]),
                Integer.parseInt(p[4]), p[5], p[6], p[7]);
    }
}
