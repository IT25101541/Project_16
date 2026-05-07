package com.yourteam.grocerymanagement.util;

import javax.servlet.ServletContext;

/**
 * DataPaths – centralizes all data file path resolution.
 * Paths are relative to the webapp's data directory.
 */
public class DataPaths {

    private final String base;

    public DataPaths(ServletContext ctx) {
        // Store data files in WEB-INF/data/ so they are not publicly accessible
        String real = ctx.getRealPath("/WEB-INF/data");
        if (real == null) real = System.getProperty("user.home") + "/freshcart_data";
        new java.io.File(real).mkdirs();
        this.base = real + java.io.File.separator;
    }

    public DataPaths(String basePath) {
        new java.io.File(basePath).mkdirs();
        this.base = basePath.endsWith(java.io.File.separator) ? basePath : basePath + java.io.File.separator;
    }

    public String users()         { return base + "users.txt"; }
    public String products()      { return base + "products.txt"; }
    public String orders()        { return base + "orders.txt"; }
    public String deliveries()    { return base + "deliveries.txt"; }
    public String clearance()     { return base + "clearance.txt"; }
    public String carts()         { return base + "carts.txt"; }
}
