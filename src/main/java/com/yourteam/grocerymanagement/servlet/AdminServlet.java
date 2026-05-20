package com.yourteam.grocerymanagement.servlet;

import com.yourteam.grocerymanagement.model.*;
import com.yourteam.grocerymanagement.service.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.List;

/**
 * AdminServlet – handles all admin panel operations.
 * MultipartConfig enables file upload for product images.
 */
@WebServlet("/admin/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize       = 5 * 1024 * 1024,  // 5 MB
    maxRequestSize    = 10 * 1024 * 1024  // 10 MB
)
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        String action = getAction(req);

        switch (action) {
            case "dashboard":
                loadDashboard(req, resp);
                break;

            // ── USER MANAGEMENT ──────────────────────────────────────────────
            case "users": {
                String query = req.getParameter("search");
                List<User> users;
                if (query != null && !query.trim().isEmpty()) {
                    // Search by name or email
                    users = ServiceFactory.userService(getServletContext()).getAllUsers();
                    String q = query.toLowerCase().trim();
                    users.removeIf(u ->
                        !u.getUsername().toLowerCase().contains(q) &&
                        !u.getEmail().toLowerCase().contains(q) &&
                        !u.getPhone().contains(q)
                    );
                    req.setAttribute("searchQuery", query);
                } else {
                    users = ServiceFactory.userService(getServletContext()).getAllUsers();
                }
                req.setAttribute("users", users);
                req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
                break;
            }

            // ── PRODUCT MANAGEMENT ───────────────────────────────────────────
            case "products":
                req.setAttribute("products", ServiceFactory.productService(getServletContext()).getAllProducts());
                req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
                break;

            case "product-edit": {
                String pid = req.getParameter("id");
                req.setAttribute("product", ServiceFactory.productService(getServletContext()).getProductById(pid));
                req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
                break;
            }
            case "product-add":
                req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
                break;

            // ── ORDER MANAGEMENT ─────────────────────────────────────────────
            case "orders":
                req.setAttribute("orders", ServiceFactory.orderService(getServletContext()).getAllOrders());
                req.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(req, resp);
                break;

            // ── DELIVERY MANAGEMENT ──────────────────────────────────────────
            case "deliveries":
                req.setAttribute("deliveries", ServiceFactory.deliveryService(getServletContext()).getAllDeliveries());
                req.getRequestDispatcher("/WEB-INF/views/admin/deliveries.jsp").forward(req, resp);
                break;

            // ── STOCK CLEARANCE ──────────────────────────────────────────────
            case "clearance":
                req.setAttribute("clearanceItems", ServiceFactory.clearanceService(getServletContext()).getAllClearanceItems());
                req.getRequestDispatcher("/WEB-INF/views/admin/clearance.jsp").forward(req, resp);
                break;

            case "clearance-add":
                req.setAttribute("products", ServiceFactory.productService(getServletContext()).getAllProducts());
                req.getRequestDispatcher("/WEB-INF/views/admin/clearance-form.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        String action = getAction(req);

        switch (action) {

            // ── USER MANAGEMENT ──
            case "search-users": {
                String q = req.getParameter("search");
                resp.sendRedirect(req.getContextPath() + "/admin/users?search=" +
                        java.net.URLEncoder.encode(q != null ? q : "", "UTF-8"));
                break;
            }
            case "block-user":
                ServiceFactory.userService(getServletContext()).blockUser(req.getParameter("userId"));
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                break;
            case "unblock-user":
                ServiceFactory.userService(getServletContext()).unblockUser(req.getParameter("userId"));
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                break;
            case "delete-user":
                ServiceFactory.userService(getServletContext()).deleteAccount(req.getParameter("userId"));
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                break;

            // ── PRODUCT MANAGEMENT — with image upload ──
            case "save-product": {
                ProductService ps = ServiceFactory.productService(getServletContext());
                String pid           = req.getParameter("productId");
                String name          = req.getParameter("name");
                String cat           = req.getParameter("category");
                double price         = Double.parseDouble(req.getParameter("price"));
                int stock            = Integer.parseInt(req.getParameter("stock"));
                String expiry        = req.getParameter("expiryDate");
                String mfg           = req.getParameter("manufactureDate");
                String imageUrl      = req.getParameter("imageUrl");

                // Handle file upload
                Part filePart = req.getPart("imageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = getFileName(filePart);
                    if (fileName != null && !fileName.isEmpty()) {
                        // Save to webapp/static/img/products/
                        String uploadDir = getServletContext().getRealPath("/static/img/products");
                        new File(uploadDir).mkdirs();
                        String safeName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                        String filePath = uploadDir + File.separator + safeName;
                        try (InputStream in = filePart.getInputStream();
                             OutputStream out = new FileOutputStream(filePath)) {
                            byte[] buf = new byte[8192];
                            int len;
                            while ((len = in.read(buf)) > 0) out.write(buf, 0, len);
                        }
                        imageUrl = "/static/img/products/" + safeName;
                    }
                }

                if (pid == null || pid.isEmpty()) {
                    ps.addProduct(name, cat, price, stock, expiry, mfg, imageUrl != null ? imageUrl : "");
                } else {
                    ps.updateProduct(pid, name, cat, price, stock, expiry, mfg, imageUrl != null ? imageUrl : "");
                }
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                break;
            }
            case "delete-product":
                ServiceFactory.productService(getServletContext()).deleteProduct(req.getParameter("productId"));
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                break;

            // ── ORDER MANAGEMENT ──
            case "update-order-status":
                ServiceFactory.orderService(getServletContext())
                        .updateStatus(req.getParameter("orderId"), req.getParameter("status"));
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                break;
            case "delete-order":
                ServiceFactory.orderService(getServletContext()).deleteOrder(req.getParameter("orderId"));
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                break;
            case "cancel-order":
                ServiceFactory.orderService(getServletContext()).cancelOrder(req.getParameter("orderId"));
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                break;

            // ── DELIVERY MANAGEMENT ──
            case "update-delivery-status":
                ServiceFactory.deliveryService(getServletContext())
                        .updateStatus(req.getParameter("deliveryId"), req.getParameter("status"));
                resp.sendRedirect(req.getContextPath() + "/admin/deliveries");
                break;
            case "cancel-delivery":
                ServiceFactory.deliveryService(getServletContext()).cancelDelivery(req.getParameter("deliveryId"));
                resp.sendRedirect(req.getContextPath() + "/admin/deliveries");
                break;
            case "delete-delivery":
                ServiceFactory.deliveryService(getServletContext()).deleteDelivery(req.getParameter("deliveryId"));
                resp.sendRedirect(req.getContextPath() + "/admin/deliveries");
                break;

            // ── STOCK CLEARANCE ──
            case "save-clearance": {
                StockClearanceService cs = ServiceFactory.clearanceService(getServletContext());
                String clearanceId = req.getParameter("clearanceId");
                if (clearanceId == null || clearanceId.isEmpty()) {
                    cs.addClearanceRecord(
                        req.getParameter("productId"),
                        req.getParameter("productName"),
                        req.getParameter("expiryDate"),
                        req.getParameter("manufactureDate"),
                        Double.parseDouble(req.getParameter("originalPrice")),
                        req.getParameter("stockCondition"),
                        Integer.parseInt(req.getParameter("stockQuantity"))
                    );
                } else {
                    cs.updatePricing(clearanceId, Double.parseDouble(req.getParameter("discountPercentage")));
                }
                resp.sendRedirect(req.getContextPath() + "/admin/clearance");
                break;
            }
            case "remove-clearance":
                ServiceFactory.clearanceService(getServletContext()).removeClearance(req.getParameter("clearanceId"));
                resp.sendRedirect(req.getContextPath() + "/admin/clearance");
                break;
            case "deactivate-clearance":
                ServiceFactory.clearanceService(getServletContext()).deactivateClearance(req.getParameter("clearanceId"));
                resp.sendRedirect(req.getContextPath() + "/admin/clearance");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    // ── DASHBOARD ─────────────────────────────────────────────────────────────
    private void loadDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        OrderService   os = ServiceFactory.orderService(getServletContext());
        ProductService ps = ServiceFactory.productService(getServletContext());
        UserService    us = ServiceFactory.userService(getServletContext());

        req.setAttribute("totalRevenue",  os.getTotalRevenue());
        req.setAttribute("totalOrders",   os.getTotalOrderCount());
        req.setAttribute("totalUsers",    us.getAllUsers().size());
        req.setAttribute("totalProducts", ps.getAllProducts().size());
        req.setAttribute("pendingOrders", os.getPendingOrders().size());
        req.setAttribute("allOrders",     os.getAllOrders());
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    // ── HELPERS ───────────────────────────────────────────────────────────────
    private String getAction(HttpServletRequest req) {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) return "dashboard";
        return path.substring(1);
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "ADMIN".equals(s.getAttribute("role"));
    }

    private String getFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return Paths.get(name).getFileName().toString();
            }
        }
        return null;
    }
}
