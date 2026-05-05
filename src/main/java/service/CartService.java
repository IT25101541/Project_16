package service;

import com.yourteam.grocerymanagement.model.Cart;
import com.yourteam.grocerymanagement.model.CartItem;
import com.yourteam.grocerymanagement.util.FileHandler;
import com.yourteam.grocerymanagement.util.IdGenerator;

import java.util.ArrayList;
import java.util.List;

/**
 * CartService – manages cart CRUD operations.
 * Demonstrates Abstraction: calling code doesn't need to know how items are stored.
 */
public class CartService {

    private final FileHandler fileHandler;

    public CartService(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    // ─── CREATE / GET ──────────────────────────────────────────────────────────

    public Cart getOrCreateCart(String userId) {
        Cart cart = getCartByUserId(userId);
        if (cart == null) {
            cart = new Cart(IdGenerator.cartId(), userId);
            saveCart(cart);
        }
        return cart;
    }

    // ─── READ ──────────────────────────────────────────────────────────────────

    public Cart getCartByUserId(String userId) {
        for (String line : fileHandler.readFromFile()) {
            Cart c = deserializeCart(line);
            if (c != null && c.getUserId().equals(userId)) return c;
        }
        return null;
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    public void addItem(String userId, CartItem item) {
        Cart cart = getOrCreateCart(userId);
        cart.addItem(item);
        persistCart(cart);
    }

    public void updateQuantity(String userId, String productId, int qty) {
        Cart cart = getOrCreateCart(userId);
        if (qty <= 0) {
            cart.removeItem(productId);
        } else {
            cart.updateQuantity(productId, qty);
        }
        persistCart(cart);
    }

    public void removeItem(String userId, String productId) {
        Cart cart = getOrCreateCart(userId);
        cart.removeItem(productId);
        persistCart(cart);
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public void clearCart(String userId) {
        Cart cart = getOrCreateCart(userId);
        cart.clearCart();
        persistCart(cart);
    }

    // ─── SERIALIZATION ─────────────────────────────────────────────────────────

    private String serializeCart(Cart cart) {
        StringBuilder sb = new StringBuilder();
        sb.append(cart.getCartId()).append("|").append(cart.getUserId()).append("|");
        List<CartItem> items = cart.getItems();
        for (int i = 0; i < items.size(); i++) {
            sb.append(items.get(i).toFileString());
            if (i < items.size() - 1) sb.append(";");
        }
        return sb.toString();
    }

    private Cart deserializeCart(String line) {
        String[] parts = line.split("\\|", 3);
        if (parts.length < 2) return null;
        Cart cart = new Cart(parts[0], parts[1]);
        if (parts.length == 3 && !parts[2].isEmpty()) {
            for (String s : parts[2].split(";")) {
                CartItem item = CartItem.fromFileString(s);
                if (item != null) cart.getItems().add(item);
            }
        }
        return cart;
    }

    private void saveCart(Cart cart) {
        fileHandler.writeToFile(serializeCart(cart));
    }

    private void persistCart(Cart cart) {
        String serialized = serializeCart(cart);
        if (!fileHandler.updateRecord(cart.getCartId(), serialized)) {
            fileHandler.writeToFile(serialized);
        }
    }
}
