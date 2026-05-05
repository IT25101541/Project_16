package com.yourteam.grocerymanagement.servlet;

import com.yourteam.grocerymanagement.model.*;
import com.yourteam.grocerymanagement.service.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AdminServlet – handles all admin panel operations.
 * Requires ADMIN role session attribute.
 */
@WebServlet("/admin/*")
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
            case "users":
                req.setAttribute("users", ServiceFactory.userService(getServletContext()).getAllUsers());
                req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
                break;

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

            // ── PRODUCT MANAGEMENT ──
            case "save-product": {
                ProductService ps = ServiceFactory.productService(getServletContext());
                String pid = req.getParameter("productId");
                String name = req.getParameter("name");
                String cat  = req.getParameter("category");
                double price = Double.parseDouble(req.getParameter("price"));
                int stock    = Integer.parseInt(req.getParameter("stock"));
                String expiry = req.getParameter("expiryDate");
                String mfg    = req.getParameter("manufactureDate");
                String img    = req.getParameter("imageUrl");
                if (pid == null || pid.isEmpty()) {
                    ps.addProduct(name, cat, price, stock, expiry, mfg, img);
                } else {
                    ps.updateProduct(pid, name, cat, price, stock, expiry, mfg, img);
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
                    // Create
                    String productId   = req.getParameter("productId");
                    String productName = req.getParameter("productName");
                    String expiry      = req.getParameter("expiryDate");
                    String mfg         = req.getParameter("manufactureDate");
                    double origPrice   = Double.parseDouble(req.getParameter("originalPrice"));
                    String stockCond   = req.getParameter("stockCondition");
                    int stockQty       = Integer.parseInt(req.getParameter("stockQuantity"));
                    cs.addClearanceRecord(productId, productName, expiry, mfg, origPrice, stockCond, stockQty);
                } else {
                    // Update discount
                    double discount = Double.parseDouble(req.getParameter("discountPercentage"));
                    cs.updatePricing(clearanceId, discount);
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

    // ─── DASHBOARD ─────────────────────────────────────────────────────────────

    private void loadDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        OrderService os = ServiceFactory.orderService(getServletContext());
        ProductService ps = ServiceFactory.productService(getServletContext());
        UserService us = ServiceFactory.userService(getServletContext());

        req.setAttribute("totalRevenue",   os.getTotalRevenue());
        req.setAttribute("totalOrders",    os.getTotalOrderCount());
        req.setAttribute("totalUsers",     us.getAllUsers().size());
        req.setAttribute("totalProducts",  ps.getAllProducts().size());
        req.setAttribute("pendingOrders",  os.getPendingOrders().size());
        req.setAttribute("allOrders",      os.getAllOrders());
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    // ─── HELPERS ───────────────────────────────────────────────────────────────

    private String getAction(HttpServletRequest req) {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) return "dashboard";
        return path.substring(1);
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "ADMIN".equals(s.getAttribute("role"));
    }
}
