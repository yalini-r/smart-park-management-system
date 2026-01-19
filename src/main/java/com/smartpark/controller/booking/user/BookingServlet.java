package com.smartpark.controller.booking.user;

import com.smartpark.dao.BookingDAO;
import com.smartpark.dao.VehicleRateDAO;
import com.smartpark.dto.Booking;
import com.smartpark.dto.BookingStatus;
import com.smartpark.dto.User;
import com.smartpark.dto.VehicleRate;
import com.smartpark.dto.VehicleType;
import com.smartpark.util.FeeCalculator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;


@SuppressWarnings("serial")
@WebServlet("/user/booking-action")

public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            createBooking(req, res);
        } else if ("cancel".equalsIgnoreCase(action)) {
            cancelBooking(req, res);
        }
    }

    private void createBooking(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        try {
            HttpSession session = req.getSession(false);
            User user = (User) session.getAttribute("user");

            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            int userId = user.getId();
            int slotId = Integer.parseInt(req.getParameter("slotId"));

            LocalDateTime start = LocalDateTime.parse(req.getParameter("startTime"));
            LocalDateTime end   = LocalDateTime.parse(req.getParameter("endTime"));

           
            if (start.isBefore(LocalDateTime.now().plusMinutes(30))) {
                res.sendRedirect(req.getContextPath()
                    + "/user/booking-page?error=buffer");
                return;
            }

            String vehicleNumber = req.getParameter("vehicle_number");
            VehicleType vehicleType =
                    VehicleType.valueOf(req.getParameter("vehicleType"));

          
            VehicleRateDAO rateDAO = new VehicleRateDAO();
            VehicleRate rate = rateDAO.getRateByVehicleType(vehicleType);
            double estimatedFee = FeeCalculator.calculatePreBookEstimate(start, end, rate);


          
            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setSlotId(slotId);
            booking.setStartTime(start);
            booking.setEndTime(end);
            booking.setVehicleNumber(vehicleNumber);
            booking.setVehicleType(vehicleType);
            booking.setEstimatedAmount(estimatedFee);
            booking.setStatus(BookingStatus.BOOKED);
            booking.setAlertSent(false);

            // 4️ DAO DECISION (FINAL AUTHORITY)
            boolean success = bookingDAO.createBooking(booking);

            if (!success) {
                res.sendRedirect(req.getContextPath()
                    + "/user/booking-page?error=unavailable");
                return;
            }

            res.sendRedirect(req.getContextPath()
                + "/user/booking-page?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath()
                + "/user/booking-page?error=system");
        }
    }


    private void cancelBooking(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            HttpSession session = req.getSession(false);
            User user = (User) session.getAttribute("user");

            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            int userId = user.getId();

         
            int result = bookingDAO.cancelBookingWithPolicy(bookingId, userId);

            String redirectUrl = req.getContextPath() + "/user/view-bookings";

            switch(result) {
                case 1:
                    // Cancelled successfully, no penalty
                    redirectUrl += "?cancel=success";
                    break;
                case 2:
                    // Cancelled, penalty applied
                    redirectUrl += "?cancel=penalty";
                    break;
                case -1:
                    // Too late to cancel
                    redirectUrl += "?cancel=tooLate";
                    break;
                case -2:
                    // Not allowed / invalid
                    redirectUrl += "?cancel=failed";
                    break;
                default:
                    redirectUrl += "?cancel=failed";
            }

            res.sendRedirect(redirectUrl);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/user/view-bookings?cancel=failed");
        }
    }

 
    



}
