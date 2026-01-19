package com.smartpark.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.smartpark.dao.UserDAO;
import com.smartpark.dto.User;

@SuppressWarnings("serial")
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Read form data
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String pwd = req.getParameter("password");
        String phone = req.getParameter("phone");

        // Basic validation
        if (name == null || email == null || pwd == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || pwd.trim().isEmpty()) {

            req.setAttribute("error", "Name, Email and Password are required!");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
            return;
        }

       
        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPassword(pwd.trim());  
        user.setPhone(phone == null ? "" : phone.trim());
        user.setRole("user"); 

        UserDAO userDao = new UserDAO();

        try {
            // Check if email already exists
            if (userDao.isEmailExists(email.trim())) {
                req.setAttribute("error", "Email already registered! Please login.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
                return;
            }

            boolean inserted = userDao.registerUser(user);

            if (inserted) {
                // Use session because redirect happens
                HttpSession session = req.getSession();
                session.setAttribute("regMsg", "Registration successful! Please login.");

                res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            } 
            else {
                req.setAttribute("error", "Registration failed. Try again.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error, contact admin.");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
        }
    }
}
