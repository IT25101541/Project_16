package com.yourteam.grocerymanagement.service;

import com.yourteam.grocerymanagement.model.Order;
import com.yourteam.grocerymanagement.model.OrderItem;
import com.yourteam.grocerymanagement.model.OrderQueue;
import com.yourteam.grocerymanagement.util.FileHandler;
import com.yourteam.grocerymanagement.util.IdGenerator;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * OrderService – manages order lifecycle.
 * Uses OrderQueue (Queue data structure) for pending order processing.
 */
public class OrderService {

    private final FileHandler fileHandler;
    private final OrderQueue orderQueue;
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public OrderService(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
        this.orderQueue = new OrderQueue();
        // Pre-load pending orders into queue
        for (Order o : getAllOrders()) {
            if ("PENDING".equals(o.getStatus())) orderQueue.enqueue(o);
        }
    }

    // ─── CREATE ────────────────────────────────────────────────────────────────

    public Order placeOrder(String userId, String username, List<OrderItem> items,
                            double totalAmount, String fulfillmentType,
                            String deliveryAddress, String postalCode,
                            String district, String province, String mobileNumber) {
        String orderId = IdGenerator.orderId();
        String orderDate = LocalDateTime.now().format(FMT);
        Order order = new Order(orderId, userId, username, items, "PENDING",
                orderDate, totalAmount, fulfillmentType, deliveryAddress,
                postalCode, district, province, mobileNumber);
        fileHandler.writeToFile(order.toFileString());
        orderQueue.enqueue(order);
        return order;
    }

    // ─── READ ──────────────────────────────────────────────────────────────────

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        for (String line : fileHandler.readFromFile()) {
            Order o = Order.fromFileString(line);
            if (o != null) list.add(o);
        }
        return list;
    }

    public Order getOrderById(String orderId) {
        for (Order o : getAllOrders()) {
            if (o.getOrderId().equals(orderId)) return o;
        }
        return null;
    }

    public List<Order> getOrdersByUser(String userId) {
        return getAllOrders().stream()
                .filter(o -> o.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    public List<Order> getPendingOrders() {
        return getAllOrders().stream()
                .filter(o -> "PENDING".equals(o.getStatus()))
                .collect(Collectors.toList());
    }

    public OrderQueue getOrderQueue() {
        return orderQueue;
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    public boolean updateStatus(String orderId, String newStatus) {
        Order order = getOrderById(orderId);
        if (order == null) return false;
        order.setStatus(newStatus);
        return fileHandler.updateRecord(orderId, order.toFileString());
    }

    // ─── DELETE / CANCEL ───────────────────────────────────────────────────────

    public boolean cancelOrder(String orderId) {
        return updateStatus(orderId, "CANCELLED");
    }

    public boolean deleteOrder(String orderId) {
        return fileHandler.deleteRecord(orderId);
    }

    // ─── ADMIN STATS ───────────────────────────────────────────────────────────

    public double getTotalRevenue() {
        return getAllOrders().stream()
                .filter(o -> !"CANCELLED".equals(o.getStatus()))
                .mapToDouble(Order::getTotalAmount)
                .sum();
    }

    public long getTotalOrderCount() {
        return getAllOrders().stream()
                .filter(o -> !"CANCELLED".equals(o.getStatus()))
                .count();
    }
}
