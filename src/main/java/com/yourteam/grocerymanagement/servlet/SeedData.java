package com.yourteam.grocerymanagement.servlet;

import com.yourteam.grocerymanagement.service.ProductService;
import com.yourteam.grocerymanagement.service.StockClearanceService;

import java.time.LocalDate;

/**
 * SeedData – populates sample products for all 8 categories on first run.
 */
public class SeedData {

    public static void seed(ProductService ps, StockClearanceService cs) {
        String today = LocalDate.now().toString();
        String exp7  = LocalDate.now().plusDays(7).toString();
        String exp3  = LocalDate.now().plusDays(3).toString();
        String exp30 = LocalDate.now().plusDays(30).toString();
        String exp60 = LocalDate.now().plusDays(60).toString();
        String mfg   = LocalDate.now().minusDays(5).toString();

        // FRUITS
        ps.addProduct("Banana (Ambul)", "Fruits", 180.00, 50, exp7, mfg, "/static/img/banana.png");
        ps.addProduct("Apple (Red)",    "Fruits", 350.00, 30, exp30, mfg, "/static/img/apple.png");
        ps.addProduct("Mango",          "Fruits", 220.00, 25, exp7, mfg, "/static/img/mango.png");
        ps.addProduct("Papaya",         "Fruits", 150.00, 20, exp3, mfg, "/static/img/papaya.png");

        // VEGETABLES
        ps.addProduct("Tomato",         "Vegetables", 120.00, 60, exp7, mfg, "/static/img/tomato.png");
        ps.addProduct("Carrot",         "Vegetables",  90.00, 45, exp30, mfg, "/static/img/carrot.png");
        ps.addProduct("Leeks",          "Vegetables",  80.00, 40, exp7, mfg, "/static/img/leeks.png");
        ps.addProduct("Potato",         "Vegetables", 110.00, 80, exp30, mfg, "/static/img/potato.png");

        // MEAT
        ps.addProduct("Chicken Breast", "Meat", 950.00, 20, exp3, mfg, "/static/img/chicken.png");
        ps.addProduct("Beef (500g)",    "Meat", 1200.00,15, exp3, mfg, "/static/img/beef.png");
        ps.addProduct("Fish (Salmon)",  "Meat", 1500.00,10, exp3, mfg, "/static/img/fish.png");

        // DAIRY
        ps.addProduct("Milk (1L)",      "Dairy",  220.00, 40, exp7, mfg, "/static/img/milk.png");
        ps.addProduct("Curd (500g)",    "Dairy",  180.00, 30, exp7, mfg, "/static/img/curd.png");
        ps.addProduct("Cheese (200g)",  "Dairy",  450.00, 20, exp30, mfg, "/static/img/cheese.png");
        ps.addProduct("Butter (250g)",  "Dairy",  390.00, 25, exp30, mfg, "/static/img/butter.png");

        // BAKERY
        ps.addProduct("White Bread",    "Bakery",  95.00, 30, exp3, mfg, "/static/img/bread.png");
        ps.addProduct("Croissant",      "Bakery", 120.00, 20, exp3, mfg, "/static/img/croissant.png");
        ps.addProduct("Chocolate Cake", "Bakery", 850.00, 10, exp7, mfg, "/static/img/cake.png");

        // STAPLE GROCERY
        ps.addProduct("Basmati Rice (1kg)", "Staple Grocery", 280.00, 100, exp60, mfg, "/static/img/rice.png");
        ps.addProduct("Dhal (500g)",        "Staple Grocery", 160.00,  80, exp60, mfg, "/static/img/dhal.png");
        ps.addProduct("Sugar (1kg)",        "Staple Grocery", 200.00, 100, exp60, mfg, "/static/img/sugar.png");
        ps.addProduct("Coconut Oil (1L)",   "Staple Grocery", 480.00,  50, exp60, mfg, "/static/img/oil.png");

        // BEVERAGE
        ps.addProduct("Coca-Cola (1.5L)",   "Beverage", 290.00, 60, exp60, mfg, "/static/img/cola.png");
        ps.addProduct("Orange Juice (1L)",  "Beverage", 320.00, 40, exp30, mfg, "/static/img/oj.png");
        ps.addProduct("Green Tea (25 bags)","Beverage", 240.00, 35, exp60, mfg, "/static/img/tea.png");

        // FROZEN
        ps.addProduct("Frozen Pizza",       "Frozen",  650.00, 15, exp30, mfg, "/static/img/pizza.png");
        ps.addProduct("Ice Cream (1L)",     "Frozen",  480.00, 20, exp60, mfg, "/static/img/icecream.png");
        ps.addProduct("Frozen Peas (500g)", "Frozen",  195.00, 25, exp60, mfg, "/static/img/peas.png");

        // Add clearance records for products near expiry
        // Papaya (exp3), Chicken (exp3), Beef (exp3), Fish (exp3), White Bread (exp3), Croissant (exp3)
        cs.addClearanceRecord("SEED_PAP", "Papaya",        exp3, mfg, 150.00, "LOW",    20);
        cs.addClearanceRecord("SEED_CHK", "Chicken Breast",exp3, mfg, 950.00, "MEDIUM", 20);
        cs.addClearanceRecord("SEED_BEF", "Beef (500g)",   exp3, mfg,1200.00, "LOW",    15);
        cs.addClearanceRecord("SEED_BRD", "White Bread",   exp3, mfg,  95.00, "HIGH",   30);
        cs.addClearanceRecord("SEED_MNG", "Mango",         exp7, mfg, 220.00, "MEDIUM", 25);
        cs.addClearanceRecord("SEED_TOM", "Tomato",        exp7, mfg, 120.00, "HIGH",   60);
    }
}
