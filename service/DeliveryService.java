package com.yourteam.grocerymanagement.service;

import com.yourteam.grocerymanagement.model.Delivery;
import com.yourteam.grocerymanagement.util.FileHandler;
import com.yourteam.grocerymanagement.util.IdGenerator;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * DeliveryService – manages delivery CRUD operations.
 * Demonstrates Abstraction: assignment and tracking logic is encapsulated here.
 */
public class DeliveryService {

    private final FileHandler fileHandler;

    // Pool of available drivers (in a real system, this would be its own entity/file)
    private static final String[][] DRIVERS = {
        {"Nuwan Perera",  "0771234567", "WP-1234", "6.9271,79.8612"},
        {"Kasun Silva",   "0762345678", "CP-5678", "6.9200,79.8700"},
        {"Dinesh Fernando","0753456789","SP-9012", "6.9350,79.8550"},
        {"Pradeep Raj",   "0744567890", "NP-3456", "6.9100,79.8800"},
        {"Tharaka Wijesinghe","0735678901","WP-7890","6.9400,79.8400"}
    };

    public DeliveryService(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    // ─── CREATE ────────────────────────────────────────────────────────────────

    public Delivery assignDelivery(String orderId, String deliveryAddress, String userId) {
        // Pick a driver deterministically based on orderId hash
        int idx = Math.abs(orderId.hashCode()) % DRIVERS.length;
        String[] driver = DRIVERS[idx];

        Delivery delivery = new Delivery(
            IdGenerator.deliveryId(), orderId, deliveryAddress,
            "ASSIGNED", LocalDate.now().toString(),
            driver[0], driver[1], driver[2], driver[3], userId
        );
        fileHandler.writeToFile(delivery.toFileString());
        return delivery;
    }

    // ─── READ ──────────────────────────────────────────────────────────────────

    public List<Delivery> getAllDeliveries() {
        List<Delivery> list = new ArrayList<>();
        for (String line : fileHandler.readFromFile()) {
            Delivery d = Delivery.fromFileString(line);
            if (d != null) list.add(d);
        }
        return list;
    }

    public Delivery getDeliveryById(String deliveryId) {
        for (Delivery d : getAllDeliveries()) {
            if (d.getDeliveryId().equals(deliveryId)) return d;
        }
        return null;
    }

    public Delivery getDeliveryByOrderId(String orderId) {
        for (Delivery d : getAllDeliveries()) {
            if (d.getOrderId().equals(orderId)) return d;
        }
        return null;
    }

    public List<Delivery> getDeliveriesByUser(String userId) {
        return getAllDeliveries().stream()
                .filter(d -> d.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    // ─── UPDATE ────────────────────────────────────────────────────────────────

    public boolean updateStatus(String deliveryId, String newStatus) {
        Delivery d = getDeliveryById(deliveryId);
        if (d == null) return false;
        d.setStatus(newStatus);
        return fileHandler.updateRecord(deliveryId, d.toFileString());
    }

    public boolean updateGpsLocation(String deliveryId, String gpsLocation) {
        Delivery d = getDeliveryById(deliveryId);
        if (d == null) return false;
        d.setGpsLocation(gpsLocation);
        return fileHandler.updateRecord(deliveryId, d.toFileString());
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public boolean cancelDelivery(String deliveryId) {
        return updateStatus(deliveryId, "CANCELLED");
    }

    public boolean deleteDelivery(String deliveryId) {
        return fileHandler.deleteRecord(deliveryId);
    }
}
