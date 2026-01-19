package com.smartpark.controller;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.smartpark.dao.BookingDAO;
import com.smartpark.dto.BookingStatus;

@WebServlet(urlPatterns = { "/checkIn", "/cancelBooking" })

public class BookingActionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getServletPath();

        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            boolean success = false;
            String message = "";
            String error = "";

            switch (action) {
            case "/checkIn":
                success = bookingDAO.updateStatus(bookingId, BookingStatus.ACTIVE);
                message = "Booking checked-in successfully!";
                error = "Failed to check-in booking!";
                break;



            case "/cancelBooking":
                success = bookingDAO.updateStatus(bookingId, BookingStatus.CANCELLED);
                message = "Booking cancelled successfully!";
                error = "Failed to cancel booking!";
                break;

            default:
                req.getSession().setAttribute("error", "Invalid action!");
                res.sendRedirect(req.getContextPath() + "/viewBookings");
                return;
        }


            req.getSession().setAttribute(success ? "message" : "error",
                    success ? message : error);

           res.sendRedirect(req.getContextPath() + "/viewBookings");


        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Invalid booking ID!");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Database error!");
        }

      

    }
}
