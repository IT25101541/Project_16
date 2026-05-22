package com.yourteam.grocerymanagement.model;

import java.util.LinkedList;
import java.util.Queue;

/**
 * OrderQueue – uses Queue data structure to manage pending orders.
 * Demonstrates Abstraction: hides enqueue/dequeue internals.
 */
public class OrderQueue {
    private final Queue<Order> pendingOrders;

    public OrderQueue() {
        this.pendingOrders = new LinkedList<>();
    }

    public void enqueue(Order order) {
        pendingOrders.offer(order);
    }

    public Order dequeue() {
        return pendingOrders.poll();
    }

    public Order peek() {
        return pendingOrders.peek();
    }

    public boolean isEmpty() {
        return pendingOrders.isEmpty();
    }

    public int size() {
        return pendingOrders.size();
    }

    public Queue<Order> getPendingOrders() {
        return pendingOrders;
    }
}
