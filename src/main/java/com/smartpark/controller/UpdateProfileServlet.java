package com.smartpark.controller;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.smartpark.dao.UserDAO;
import com.smartpark.dto.User;

@SuppressWarnings("serial")
@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        User u = (User) session.getAttribute("user");

        String name = req.getParameter("name");
        String phone = req.getParameter("phone");

        if (name == null || name.trim().isEmpty()) {
        	name = u.getName();
        }

        // Prevent NULL phone error
        if (phone == null || phone.trim().isEmpty()) {
            phone = u.getPhone(); 
        }

        UserDAO dao = new UserDAO();

        try {
            boolean nameUpdated = dao.updateName(u.getId(), name);
            boolean phoneUpdated = dao.updatePhoneNumber(u.getId(), phone);

            if (nameUpdated || phoneUpdated) {
                u.setName(name);
                u.setPhone(phone);
                session.setAttribute("user", u);
                session.setAttribute("msg", "Profile updated successfully!");
            } else {
                session.setAttribute("msg", "No changes detected!");
            }

            redirect(res, req);

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("msg", "Server error while updating profile!");
            redirect(res, req);
        }
    }

    private void redirect(HttpServletResponse res, HttpServletRequest req)
            throws IOException {

        res.sendRedirect(req.getContextPath() + "/profile/profile.jsp");
    }
}
