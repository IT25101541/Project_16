package com.yourteam.grocerymanagement.servlet;

import com.yourteam.grocerymanagement.model.User;
import com.yourteam.grocerymanagement.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * UserServlet – handles all user-related HTTP requests.
 * Maps to /user/* for routing different actions.
 */
@WebServlet("/user/*")
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = getAction(req);

        switch (action) {
            case "login":
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                break;
            case "register":
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
                break;
            case "forgot-password":
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
                break;
            case "profile":
                requireLogin(req, resp);
                User user = (User) req.getSession().getAttribute("loggedUser");
                req.setAttribute("user", user);
                req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
                break;
            case "logout":
                req.getSession().invalidate();
                resp.sendRedirect(req.getContextPath() + "/user/login");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/user/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = getAction(req);
        UserService userService = ServiceFactory.userService(getServletContext());

        switch (action) {
            case "login":
                handleLogin(req, resp, userService);
                break;
            case "register":
                handleRegister(req, resp, userService);
                break;
            case "forgot-password":
                handleForgotPassword(req, resp, userService);
                break;
            case "update-profile":
                handleUpdateProfile(req, resp, userService);
                break;
            case "delete-account":
                handleDeleteAccount(req, resp, userService);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/user/login");
        }
    }

    // ─── HANDLERS ──────────────────────────────────────────────────────────────

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp, UserService us)
            throws IOException, ServletException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        User user = us.login(email, password);
        if (user == null) {
            req.setAttribute("error", "Invalid email or password, or account is blocked.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("loggedUser", user);
        session.setAttribute("userId",     user.getUserId());
        session.setAttribute("role",       user.getRole());

        if ("ADMIN".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/shop/categories");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp, UserService us)
            throws IOException, ServletException {
        String username  = req.getParameter("username");
        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        String confirm   = req.getParameter("confirmPassword");
        String phone     = req.getParameter("phone");

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        User newUser = us.register(username, password, email, phone);
        if (newUser == null) {
            req.setAttribute("error", "Email already registered. Please login.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("success", "Registration successful! Please login.");
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp, UserService us)
            throws IOException, ServletException {
        String step = req.getParameter("step");

        if ("verify".equals(step)) {
            String email = req.getParameter("email");
            if (!us.emailExists(email)) {
                req.setAttribute("error", "No account found with that email.");
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
                return;
            }
            req.setAttribute("emailVerified", true);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);

        } else if ("reset".equals(step)) {
            String email       = req.getParameter("email");
            String newPassword = req.getParameter("newPassword");
            String confirm     = req.getParameter("confirmPassword");

            if (!newPassword.equals(confirm)) {
                req.setAttribute("error", "Passwords do not match.");
                req.setAttribute("emailVerified", true);
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
                return;
            }

            boolean ok = us.changePassword(email, newPassword);
            if (!ok) {
                req.setAttribute("error", "Password reset failed. Try again.");
                req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(req, resp);
                return;
            }
            req.setAttribute("success", "Password changed successfully! Please login with your new password.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, UserService us)
            throws IOException, ServletException {
        requireLogin(req, resp);
        HttpSession session = req.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        String username = req.getParameter("username");
        String email    = req.getParameter("email");
        String phone    = req.getParameter("phone");

        boolean ok = us.updateDetails(loggedUser.getUserId(), username, email, phone);
        if (ok) {
            // Refresh session user
            User updated = us.getUserById(loggedUser.getUserId());
            session.setAttribute("loggedUser", updated);
            req.setAttribute("success", "Profile updated successfully.");
        } else {
            req.setAttribute("error", "Update failed.");
        }
        req.setAttribute("user", us.getUserById(loggedUser.getUserId()));
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }

    private void handleDeleteAccount(HttpServletRequest req, HttpServletResponse resp, UserService us)
            throws IOException {
        requireLogin(req, resp);
        HttpSession session = req.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");
        us.deleteAccount(loggedUser.getUserId());
        session.invalidate();
        resp.sendRedirect(req.getContextPath() + "/user/login?deleted=true");
    }

    // ─── HELPERS ───────────────────────────────────────────────────────────────

    private String getAction(HttpServletRequest req) {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) return "login";
        return path.substring(1); // strip leading "/"
    }

    private void requireLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            try { resp.sendRedirect(req.getContextPath() + "/user/login"); } catch (Exception ignored) {}
        }
    }
}
