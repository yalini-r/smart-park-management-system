package com.smartpark.controller;

import com.smartpark.dao.UserDAO;
import com.smartpark.dto.User;
import com.smartpark.dto.UsersStatus;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@SuppressWarnings("serial")
@WebServlet("/admin/manageUsers")
public class ManageUsersServlets extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("user") : null;
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        try {
            if (action != null && userIdStr != null) {
                int userId = Integer.parseInt(userIdStr);
                switch (action) {
                    case "block":
                        userDAO.updateStatus(userId, UsersStatus.BLOCKED);
                        break;
                    case "unblock":
                        userDAO.updateStatus(userId, UsersStatus.ACTIVE);
                        break;
                    default:
                        break; 
                }
            }

            // Load all users and forward to JSP
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/admin/manageUsers.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("user") : null;
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("update".equalsIgnoreCase(action)) {
            String userIdStr = request.getParameter("userId");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String statusStr = request.getParameter("status");

            try {
                int userId = Integer.parseInt(userIdStr);
                UsersStatus status = UsersStatus.valueOf(statusStr);

                User user = userDAO.getUserById(userId);
                if (user != null) {
                    // Update fields
                    user.setName(name);
                    user.setEmail(email);
                    user.setPhone(phone);
                    user.setStatus(status);

                    // Save changes
                    userDAO.updateName(userId, name);
                    userDAO.updatePhoneNumber(userId, phone);
                    userDAO.updateStatus(userId, status);
                    
                }

                
                response.sendRedirect(request.getContextPath() + "/admin/manageUsers");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating user: " + e.getMessage());
            }
        } else {
          
            response.sendRedirect(request.getContextPath() + "/admin/manageUsers");
        }
    }
}
