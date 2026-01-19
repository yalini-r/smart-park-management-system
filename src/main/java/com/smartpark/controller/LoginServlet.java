package com.smartpark.controller;

import java.io.IOException;

import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.smartpark.dao.UserDAO;
import com.smartpark.dto.User;

@SuppressWarnings("serial")
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String pwd = req.getParameter("password");

        UserDAO dao = new UserDAO();

        try {
            User user = dao.validateUser(email, pwd);

            if (user != null) {

                // Create session
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole());

             // auto logout after 30 minutes of inactivity
                session.setMaxInactiveInterval(30 * 60);

                // Redirect based on role
                if ("admin".equalsIgnoreCase(user.getRole())) {
                    res.sendRedirect(req.getContextPath() + "/admin/adminDashboard.jsp");
                } else {
                    res.sendRedirect(req.getContextPath() + "/user/userDashboard.jsp");
                }

            } else {

                // Login failed → show error in login.jsp
                req.setAttribute("error", "Invalid email or password!");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
            }

        } catch (SQLException e) {

            e.printStackTrace();
            req.setAttribute("error", "Server error while logging in. Please contact admin.");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
        }
        
    }
    
   

      
    

}
