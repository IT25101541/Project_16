package model;

import java.util.ArrayList;
import java.util.List;

/**
 * Base Cart class. RegularCart and DiscountCart extend this (Inheritance).
 * calculateTotal() is overridden to demonstrate Polymorphism.
 */
public class Cart {
    private String cartId;
    private String userId;
    private List<CartItem> items;

    public Cart() {
        this.items = new ArrayList<>();
    }

    public Cart(String cartId, String userId) {
        this.cartId = cartId;
        this.userId = userId;
        this.items = new ArrayList<>();
    }

    public void addItem(CartItem item) {
        // Check if same product exists – update quantity
        for (CartItem existing : items) {
            if (existing.getProductId().equals(item.getProductId())) {
                existing.setQuantity(existing.getQuantity() + item.getQuantity());
                return;
            }
        }
        items.add(item);
    }

    public void removeItem(String productId) {
        items.removeIf(i -> i.getProductId().equals(productId));
    }

    public void updateQuantity(String productId, int qty) {
        for (CartItem item : items) {
            if (item.getProductId().equals(productId)) {
                item.setQuantity(qty);
                return;
            }
        }
    }

    public void clearCart() {
        items.clear();
    }

    // Polymorphism – subclasses may override this
    public double calculateTotal() {
        return items.stream().mapToDouble(CartItem::getSubtotal).sum();
    }

    public List<CartItem> viewCart() {
        return new ArrayList<>(items);
    }

    // Getters and Setters
    public String getCartId() { return cartId; }
    public void setCartId(String cartId) { this.cartId = cartId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public List<CartItem> getItems() { return items; }
    public void setItems(List<CartItem> items) { this.items = items; }
}
