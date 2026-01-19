package com.smartpark.controller;




import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@SuppressWarnings("serial")
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Destroy session
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // New session for flash message (optional)
        HttpSession newSession = req.getSession(true);
        newSession.setAttribute("logoutMsg", "Logged out successfully!");

        // Redirect to login
        res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
    }
}
