package com.yourteam.grocerymanagement.model;

/**
 * User Model - Encapsulates user data with private fields and public accessors.
 * Admin and Customer roles are managed via the role field.
 */
public class User {
    private String userId;
    private String username;
    private String password;
    private String email;
    private String role; // "ADMIN" or "CUSTOMER"
    private String phone;
    private boolean blocked;

    public User() {}

    public User(String userId, String username, String password, String email, String role, String phone, boolean blocked) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.phone = phone;
        this.blocked = blocked;
    }

    // Getters and Setters (Encapsulation)
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public boolean isBlocked() { return blocked; }
    public void setBlocked(boolean blocked) { this.blocked = blocked; }

    /**
     * Serialize to pipe-delimited string for file storage
     */
    public String toFileString() {
        return userId + "|" + username + "|" + password + "|" + email + "|" + role + "|" + phone + "|" + blocked;
    }

    /**
     * Deserialize from pipe-delimited string
     */
    public static User fromFileString(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 7) return null;
        return new User(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], Boolean.parseBoolean(parts[6]));
    }

    @Override
    public String toString() {
        return "User{userId='" + userId + "', username='" + username + "', email='" + email + "', role='" + role + "'}";
    }
}
