package com.smartpark.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.smartpark.dao.UserDAO;
import com.smartpark.dto.User;

@SuppressWarnings("serial")
@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- validate session ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?error=Please login first");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        // --- get form fields ---
        String oldPwd = request.getParameter("oldPwd");
        String newPwd = request.getParameter("newPwd");
        String confirmPwd = request.getParameter("confirmPwd");

        // --- debug logs ---
        System.out.println("===== ChangePasswordServlet Debug =====");
        System.out.println("User ID: " + userId);
        System.out.println("Old Password from form: " + oldPwd);
        System.out.println("New Password from form: " + newPwd);
        System.out.println("Confirm Password from form: " + confirmPwd);

        // --- check confirm password ---
        if (newPwd == null || confirmPwd == null || !newPwd.equals(confirmPwd)) {
            response.sendRedirect(request.getContextPath() + "/profile/profile.jsp?error=New passwords do not match");
            return;
        }

        UserDAO dao = new UserDAO();

        try {
            // --- verify old password using DAO with BCrypt ---
            boolean validOldPassword = dao.verifyPassword(userId, oldPwd);

            if (!validOldPassword) {
                System.out.println("Old password verification failed for user ID: " + userId);
                response.sendRedirect(request.getContextPath() + "/profile/profile.jsp?error=Incorrect current password");
                return;
            }

            // --- update password ---
            boolean updated = dao.updatePassword(userId, newPwd);

            if (updated) {
                System.out.println("Password updated successfully for user ID: " + userId);
                response.sendRedirect(request.getContextPath() + "/profile/profile.jsp?msg=Password updated successfully");
            } else {
                System.out.println("Password update failed for user ID: " + userId);
                response.sendRedirect(request.getContextPath() + "/profile/profile.jsp?error=Failed to update password");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile/profile.jsp?error=Something went wrong");
        }
    }
}
