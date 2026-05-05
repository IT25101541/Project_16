package com.yourteam.grocerymanagement.service;

import com.yourteam.grocerymanagement.model.User;
import com.yourteam.grocerymanagement.util.FileHandler;
import com.yourteam.grocerymanagement.util.IdGenerator;

import java.util.ArrayList;
import java.util.List;

/**
 * UserService – handles all user-related business logic.
 * Demonstrates Abstraction: hides password validation, file I/O details.
 */
public class UserService {

    // Fixed admin credentials
    public static final String ADMIN_EMAIL    = "admin@freshcart.lk";
    public static final String ADMIN_PASSWORD = "Admin@2025";
    public static final String ADMIN_ID       = "ADMIN001";
    public static final String ADMIN_USERNAME = "FreshCart Admin";

    private final FileHandler fileHandler;

    public UserService(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    // ─── CREATE ────────────────────────────────────────────────────────────────

    /**
     * Register a new customer user.
     * @return the newly created User, or null if email already exists.
     */
    public User register(String username, String password, String email, String phone) {
        if (getUserByEmail(email) != null) return null; // duplicate
        User user = new User(IdGenerator.userId(), username, password, email, "CUSTOMER", phone, false);
        fileHandler.writeToFile(user.toFileString());
        return user;
    }

    // ─── READ ──────────────────────────────────────────────────────────────────

    /**
     * Authenticate a user by email + password.
     * Returns the User object, null if not found/wrong password.
     * Handles admin login separately.
     */
    public User login(String email, String password) {
        // Check admin first
        if (ADMIN_EMAIL.equalsIgnoreCase(email) && ADMIN_PASSWORD.equals(password)) {
            return new User(ADMIN_ID, ADMIN_USERNAME, ADMIN_PASSWORD, ADMIN_EMAIL, "ADMIN", "", false);
        }
        User user = getUserByEmail(email);
        if (user == null) return null;
        if (user.isBlocked()) return null;
        if (!user.getPassword().equals(password)) return null;
        return user;
    }

    public User getUserByEmail(String email) {
        for (String line : fileHandler.readFromFile()) {
            User u = User.fromFileString(line);
            if (u != null && u.getEmail().equalsIgnoreCase(email)) return u;
        }
        return null;
    }

    public User getUserById(String userId) {
        for (String line : fileHandler.readFromFile()) {
            User u = User.fromFileString(line);
            if (u != null && u.getUserId().equals(userId)) return u;
        }
        return null;
    }

    public User searchByUsername(String username) {
        for (String line : fileHandler.readFromFile()) {
            User u = User.fromFileString(line);
            if (u != null && u.getUsername().equalsIgnoreCase(username)) return u;
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        for (String line : fileHandler.readFromFile()) {
            User u = User.fromFileString(line);
            if (u != null) users.add(u);
        }
        return users;
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    /**
     * Update user details (name, email, phone).
     */
    public boolean updateDetails(String userId, String username, String email, String phone) {
        User user = getUserById(userId);
        if (user == null) return false;
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        return fileHandler.updateRecord(userId, user.toFileString());
    }

    /**
     * Change password – replaces old password in storage with new password.
     * Used for both "change password" and "forgot password" flows.
     */
    public boolean changePassword(String email, String newPassword) {
        User user = getUserByEmail(email);
        if (user == null) return false;
        user.setPassword(newPassword);
        return fileHandler.updateRecord(user.getUserId(), user.toFileString());
    }

    /**
     * Block a user account (Admin operation).
     */
    public boolean blockUser(String userId) {
        User user = getUserById(userId);
        if (user == null) return false;
        user.setBlocked(true);
        return fileHandler.updateRecord(userId, user.toFileString());
    }

    /**
     * Unblock a user account (Admin operation).
     */
    public boolean unblockUser(String userId) {
        User user = getUserById(userId);
        if (user == null) return false;
        user.setBlocked(false);
        return fileHandler.updateRecord(userId, user.toFileString());
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    /**
     * Delete a user account.
     */
    public boolean deleteAccount(String userId) {
        return fileHandler.deleteRecord(userId);
    }

    // ─── FORGOT PASSWORD ───────────────────────────────────────────────────────

    /**
     * Verify that an email exists in the system (prerequisite for password reset).
     */
    public boolean emailExists(String email) {
        return getUserByEmail(email) != null;
    }
}
