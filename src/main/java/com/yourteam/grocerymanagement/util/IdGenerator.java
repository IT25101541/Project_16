package com.yourteam.grocerymanagement.util;

import java.util.UUID;

/**
 * IdGenerator – generates unique IDs for all entities.
 */
public class IdGenerator {

    public static String userId()      { return "USR" + shortUUID(); }
    public static String productId()   { return "PRD" + shortUUID(); }
    public static String orderId()     { return "ORD" + shortUUID(); }
    public static String deliveryId()  { return "DEL" + shortUUID(); }
    public static String clearanceId() { return "CLR" + shortUUID(); }
    public static String cartId()      { return "CRT" + shortUUID(); }

    private static String shortUUID() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
    }
}
