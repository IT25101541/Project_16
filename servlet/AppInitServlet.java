package com.yourteam.grocerymanagement.servlet;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * AppInitServlet – initializes all services on application startup.
 */
@WebListener
public class AppInitServlet implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServiceFactory.init(sce.getServletContext());
        System.out.println("FreshCart: Services initialized.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("FreshCart: Application shutting down.");
    }
}
