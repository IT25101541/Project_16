package com.yourteam.grocerymanagement.servlet;

import com.yourteam.grocerymanagement.service.*;
import com.yourteam.grocerymanagement.util.DataPaths;
import com.yourteam.grocerymanagement.util.FileHandler;

import javax.servlet.ServletContext;

/**
 * ServiceFactory – initializes all services as application-scoped singletons.
 * Called from AppInitServlet on startup.
 */
public class ServiceFactory {

    public static void init(ServletContext ctx) {
        DataPaths dp = new DataPaths(ctx);

        UserService userService         = new UserService(new FileHandler(dp.users()));
        ProductService productService   = new ProductService(new FileHandler(dp.products()));
        CartService cartService         = new CartService(new FileHandler(dp.carts()));
        OrderService orderService       = new OrderService(new FileHandler(dp.orders()));
        DeliveryService deliveryService = new DeliveryService(new FileHandler(dp.deliveries()));
        StockClearanceService clearance = new StockClearanceService(new FileHandler(dp.clearance()));

        ctx.setAttribute("userService",     userService);
        ctx.setAttribute("productService",  productService);
        ctx.setAttribute("cartService",     cartService);
        ctx.setAttribute("orderService",    orderService);
        ctx.setAttribute("deliveryService", deliveryService);
        ctx.setAttribute("clearanceService",clearance);

        // Seed sample products if empty
        if (productService.getAllProducts().isEmpty()) {
            SeedData.seed(productService, clearance);
        }
    }

    public static UserService userService(ServletContext ctx) {
        return (UserService) ctx.getAttribute("userService");
    }

    public static ProductService productService(ServletContext ctx) {
        return (ProductService) ctx.getAttribute("productService");
    }

    public static CartService cartService(ServletContext ctx) {
        return (CartService) ctx.getAttribute("cartService");
    }

    public static OrderService orderService(ServletContext ctx) {
        return (OrderService) ctx.getAttribute("orderService");
    }

    public static DeliveryService deliveryService(ServletContext ctx) {
        return (DeliveryService) ctx.getAttribute("deliveryService");
    }

    public static StockClearanceService clearanceService(ServletContext ctx) {
        return (StockClearanceService) ctx.getAttribute("clearanceService");
    }
}
