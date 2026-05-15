package com.yourteam.grocerymanagement.servlet;

import com.yourteam.grocerymanagement.model.*;
import com.yourteam.grocerymanagement.service.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * ShopServlet – handles the customer-facing shopping flow:
 *   categories → product list → cart → checkout → bill → delivery/pickup
 */
@WebServlet("/shop/*")
public class ShopServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        String action = getAction(req);

        switch (action) {
            case "categories":
                req.getRequestDispatcher("/WEB-INF/views/categories.jsp").forward(req, resp);
                break;

            case "products": {
                String category = req.getParameter("category");
                ProductService ps = ServiceFactory.productService(getServletContext());
                List<Product> products = (category != null && !category.isEmpty())
                        ? ps.getProductsByCategory(category)
                        : ps.getAllProducts();
                req.setAttribute("products", products);
                req.setAttribute("category", category);
                req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req, resp);
                break;
            }

            case "clearance": {
                StockClearanceService cs = ServiceFactory.clearanceService(getServletContext());
                List<StockClearance> items = cs.getActiveClearanceItems();
                req.setAttribute("clearanceItems", items);
                req.getRequestDispatcher("/WEB-INF/views/clearance.jsp").forward(req, resp);
                break;
            }

            case "cart": {
                String userId = getUserId(req);
                CartService cartService = ServiceFactory.cartService(getServletContext());
                Cart cart = cartService.getOrCreateCart(userId);
                req.setAttribute("cart", cart);
                req.setAttribute("total", cart.calculateTotal());
                req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
                break;
            }

            case "checkout": {
                String userId = getUserId(req);
                CartService cartService = ServiceFactory.cartService(getServletContext());
                Cart cart = cartService.getOrCreateCart(userId);
                if (cart.getItems().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/shop/cart");
                    return;
                }
                req.setAttribute("cart", cart);
                req.setAttribute("total", cart.calculateTotal());
                req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
                break;
            }

            case "order-history": {
                String userId = getUserId(req);
                OrderService os = ServiceFactory.orderService(getServletContext());
                req.setAttribute("orders", os.getOrdersByUser(userId));
                req.getRequestDispatcher("/WEB-INF/views/order-history.jsp").forward(req, resp);
                break;
            }

            case "delivery-status": {
                String orderId = req.getParameter("orderId");
                DeliveryService ds = ServiceFactory.deliveryService(getServletContext());
                OrderService os   = ServiceFactory.orderService(getServletContext());
                Delivery delivery  = ds.getDeliveryByOrderId(orderId);
                Order order        = os.getOrderById(orderId);
                req.setAttribute("delivery", delivery);
                req.setAttribute("order", order);
                req.getRequestDispatcher("/WEB-INF/views/delivery-status.jsp").forward(req, resp);
                break;
            }

            default:
                resp.sendRedirect(req.getContextPath() + "/shop/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/user/login");
            return;
        }

        String action = getAction(req);

        switch (action) {
            case "add-to-cart":
                handleAddToCart(req, resp);
                break;
            case "update-cart":
                handleUpdateCart(req, resp);
                break;
            case "remove-from-cart":
                handleRemoveFromCart(req, resp);
                break;
            case "place-order":
                handlePlaceOrder(req, resp);
                break;
            case "fulfillment":
                handleFulfillment(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/shop/categories");
        }
    }

    // ─── POST HANDLERS ─────────────────────────────────────────────────────────

    private void handleAddToCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId      = getUserId(req);
        String productId   = req.getParameter("productId");
        String productName = req.getParameter("productName");
        int qty            = Integer.parseInt(req.getParameter("qty"));
        double price       = Double.parseDouble(req.getParameter("price"));
        double discount    = 0;
        String discParam   = req.getParameter("discount");
        if (discParam != null && !discParam.isEmpty()) discount = Double.parseDouble(discParam);

        CartItem item = new CartItem(productId, productName, qty, price, discount);
        ServiceFactory.cartService(getServletContext()).addItem(userId, item);
        resp.sendRedirect(req.getContextPath() + "/shop/cart");
    }

    private void handleUpdateCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId    = getUserId(req);
        String productId = req.getParameter("productId");
        int qty          = Integer.parseInt(req.getParameter("qty"));
        ServiceFactory.cartService(getServletContext()).updateQuantity(userId, productId, qty);
        resp.sendRedirect(req.getContextPath() + "/shop/cart");
    }

    private void handleRemoveFromCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId    = getUserId(req);
        String productId = req.getParameter("productId");
        ServiceFactory.cartService(getServletContext()).removeItem(userId, productId);
        resp.sendRedirect(req.getContextPath() + "/shop/cart");
    }

    private void handlePlaceOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String userId   = getUserId(req);
        User   user     = (User) req.getSession().getAttribute("loggedUser");
        CartService cs  = ServiceFactory.cartService(getServletContext());
        Cart cart       = cs.getOrCreateCart(userId);

        if (cart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/shop/cart");
            return;
        }

        // Build order items from cart
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cart.getItems()) {
            orderItems.add(new OrderItem(ci.getProductId(), ci.getProductName(),
                    ci.getQuantity(), ci.getUnitPrice(), ci.getDiscountPercent()));
        }
        double total = cart.calculateTotal();

        // Temporarily store order info in session for bill display
        req.getSession().setAttribute("pendingOrderItems", orderItems);
        req.getSession().setAttribute("pendingOrderTotal", total);
        req.getSession().setAttribute("pendingCartRef", cart);

        // Clear cart
        cs.clearCart(userId);

        // Place order with PICKUP by default (fulfillment chosen next)
        OrderService os = ServiceFactory.orderService(getServletContext());
        Order order = os.placeOrder(userId, user.getUsername(), orderItems,
                total, "PENDING_FULFILLMENT", "", "", "", "", "");
        req.getSession().setAttribute("lastOrderId", order.getOrderId());

        // Forward to bill page
        req.setAttribute("order", order);
        req.setAttribute("orderItems", orderItems);
        req.setAttribute("total", total);
        req.getRequestDispatcher("/WEB-INF/views/bill.jsp").forward(req, resp);
    }

    private void handleFulfillment(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String orderId = req.getParameter("orderId");
        String type    = req.getParameter("type"); // PICKUP or DELIVERY
        OrderService   os = ServiceFactory.orderService(getServletContext());
        DeliveryService ds = ServiceFactory.deliveryService(getServletContext());
        Order order = os.getOrderById(orderId);

        if ("PICKUP".equals(type)) {
            os.updateStatus(orderId, "READY_FOR_PICKUP");
            order.setFulfillmentType("PICKUP");
            req.setAttribute("order", order);
            req.getRequestDispatcher("/WEB-INF/views/pickup-confirm.jsp").forward(req, resp);

        } else {
            // Delivery form submission
            String address  = req.getParameter("address");
            String postal   = req.getParameter("postalCode");
            String district = req.getParameter("district");
            String province = req.getParameter("province");
            String mobile   = req.getParameter("mobile");

            // Update order
            if (order != null) {
                order.setFulfillmentType("DELIVERY");
                order.setDeliveryAddress(address);
                order.setPostalCode(postal);
                order.setDistrict(district);
                order.setProvince(province);
                order.setMobileNumber(mobile);
                order.setStatus("PROCESSING");
                os.updateStatus(orderId, "PROCESSING");
            }

            // Assign delivery
            String userId = getUserId(req);
            Delivery delivery = ds.assignDelivery(orderId, address + ", " + district + ", " + province, userId);

            req.setAttribute("order", order);
            req.setAttribute("delivery", delivery);
            req.getRequestDispatcher("/WEB-INF/views/delivery-status.jsp").forward(req, resp);
        }
    }

    // ─── HELPERS ───────────────────────────────────────────────────────────────

    private String getAction(HttpServletRequest req) {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) return "categories";
        return path.substring(1);
    }

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("loggedUser") != null;
    }

    private String getUserId(HttpServletRequest req) {
        return (String) req.getSession().getAttribute("userId");
    }
}
