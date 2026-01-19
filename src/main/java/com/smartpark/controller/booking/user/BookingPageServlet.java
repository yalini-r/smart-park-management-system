package com.smartpark.controller.booking.user;

import com.smartpark.dao.BookingDAO;
import com.smartpark.dao.ParkingSlotDAO;
import com.smartpark.dto.Booking;
import com.smartpark.dto.ParkingSlot;
import com.smartpark.dto.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
@WebServlet("/user/booking-page")
public class BookingPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            ParkingSlotDAO slotDao = new ParkingSlotDAO();
            BookingDAO bookingDao = new BookingDAO();

            List<ParkingSlot> slots = slotDao.getSlotsForUserView();

            //Sort by floor, then slot number
            slots.sort(
                Comparator.comparingInt(ParkingSlot::getFloor)
                          .thenComparing(ParkingSlot::getSlotNumber)
            );

         
            Map<Integer, Booking> activeMap =
                    bookingDao.getAllActiveBookingsBySlot();

            Map<Integer, Booking> bookedMap =
                    bookingDao.getAllUpcomingBookingsBySlot();

        
            long occupiedCount = 0;
            long availableCount = 0;

            for (ParkingSlot slot : slots) {
                if ("OCCUPIED".equals(slot.getStatus().name())) {
                    occupiedCount++;
                } else if ("FREE".equals(slot.getStatus().name())) {
                    availableCount++;
                }
            }

         
            req.setAttribute("slots", slots);
            req.setAttribute("activeMap", activeMap);
            req.setAttribute("bookedMap", bookedMap);
            req.setAttribute("occupiedCount", occupiedCount);
            req.setAttribute("availableCount", availableCount);

            req.getRequestDispatcher("/user/booking.jsp")
               .forward(req, res);

        } catch (SQLException e) {
            e.printStackTrace();

      
            req.setAttribute("slots", List.of());
            req.setAttribute("activeMap", Map.of());
            req.setAttribute("bookedMap", Map.of());
            req.setAttribute("occupiedCount", 0L);
            req.setAttribute("availableCount", 0L);
            req.setAttribute("error", "Unable to load slots");

            req.getRequestDispatcher("/user/booking.jsp")
               .forward(req, res);
        }
    }
}
