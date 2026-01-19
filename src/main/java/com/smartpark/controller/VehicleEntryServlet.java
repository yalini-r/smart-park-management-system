package com.smartpark.controller;

import com.smartpark.dao.BookingDAO;
import com.smartpark.dao.ParkingSlotDAO;
import com.smartpark.dao.VehicleDAO;
import com.smartpark.dto.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@SuppressWarnings("serial")
@WebServlet("/vehicleEntry")
public class VehicleEntryServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private VehicleDAO vehicleDAO = new VehicleDAO();
    private ParkingSlotDAO slotDAO = new ParkingSlotDAO();
  

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
        	bookingDAO.processExpiredBookings();


            if (req.getAttribute("slots") == null) {
                List<ParkingSlot> freeSlots = slotDAO.getFreeSlots();
                req.setAttribute("slots", freeSlots);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Unable to load parking slots");
        }

        req.getRequestDispatcher("/admin/vehicleEntry.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String plateCheck = req.getParameter("numberPlate") != null
                    ? req.getParameter("numberPlate")
                    : req.getParameter("numberPlateWalkIn");

            if (plateCheck != null && vehicleDAO.hasActiveVehicle(plateCheck)) {
                req.setAttribute("error", "Vehicle is already inside the parking");
                doGet(req, resp);
                return;
            }

            // =========================
            // 1️⃣ SEARCH PRE-BOOKING
            // =========================
            if (req.getParameter("checkBooking") != null) {

                String numberPlate = req.getParameter("numberPlate");
                Booking booking =
                        bookingDAO.getActivePreBookingByVehicle(numberPlate);

                req.setAttribute("activeTab", "PREBOOK");

                if (booking != null) {
                    req.setAttribute("singleBooking", booking);
                } else {
                    req.setAttribute("error", "No active pre-booking found");
                }

                doGet(req, resp);
                return;
            }

            // =========================
            // 2️⃣ CONFIRM PRE-BOOKED ENTRY
            // =========================
            if (req.getParameter("confirmPreBooked") != null) {

                String numberPlate = req.getParameter("numberPlate");
                VehicleType type =
                        VehicleType.valueOf(req.getParameter("type").toUpperCase());

                Booking booking =
                        bookingDAO.getActivePreBookingByVehicle(numberPlate);

                if (booking == null) {
                    req.setAttribute("error", "Booking already used or expired");
                    doGet(req, resp);
                    return;
                }

                boolean ok = vehicleDAO.enterPreBookedVehicle(
                        booking.getBookingId(),
                        numberPlate,
                        type
                );

                if (ok) {
                    resp.sendRedirect(req.getContextPath() + "/viewBookings");
                    return;
                

                   
                } else {
                    req.setAttribute("error", "Booking already used or expired");
                    doGet(req, resp);
                    return;
                }
            }

            // =========================
            // 3️⃣ WALK-IN ENTRY (FIXED)
            // =========================
            if (req.getParameter("confirmWalkIn") != null) {

                String numberPlate =
                        req.getParameter("numberPlateWalkIn");
                
                if (numberPlate != null) {
                    numberPlate = numberPlate.trim().toUpperCase();
                }

                VehicleType type =
                        VehicleType.valueOf(
                                req.getParameter("typeWalkIn").toUpperCase()
                        );

                int slotId =
                        Integer.parseInt(
                                req.getParameter("slotIdWalkIn")
                        );

                //Guest info (NOT users)
                String guestName =
                        req.getParameter("userName");
                String guestPhone =
                        req.getParameter("userContact");

                if (!slotDAO.isSlotFree(slotId)) {
                    req.setAttribute("error", "Selected slot is already occupied");
                    doGet(req, resp);
                    return;
                }
                
                
                if (!numberPlate.matches("^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$")) {
                    HttpSession session = req.getSession();
                    session.setAttribute("error", "Invalid vehicle number format (e.g., TN01AB1234)");
                    resp.sendRedirect(req.getContextPath() + "/vehicleEntry");
                    return;
                }


                boolean ok = vehicleDAO.enterWalkInVehicle(
                        numberPlate,
                        type,
                        slotId,
                        guestName,
                        guestPhone
                );

                HttpSession session = req.getSession();

                if (ok) {
                    session.setAttribute("success", "Walk-in vehicle entry recorded");
                } else {
                    session.setAttribute("error", "Failed to record walk-in entry");
                }

                resp.sendRedirect(req.getContextPath() + "/viewBookings");
                return;


            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error occurred");
            doGet(req, resp);
        }
    }
}
