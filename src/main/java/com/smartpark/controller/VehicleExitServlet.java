package com.smartpark.controller;

import com.smartpark.dao.VehicleDAO;
import com.smartpark.dao.VehicleRateDAO;
import com.smartpark.dto.BookingType;
import com.smartpark.dto.ExitStats;
import com.smartpark.dto.VehicleExitViewDTO;
import com.smartpark.dto.VehicleRate;
import com.smartpark.util.ExitStatsCalculator;
import com.smartpark.util.FeeCalculator;
import com.smartpark.util.GetConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("serial")
@WebServlet("/vehicleExit")
public class VehicleExitServlet extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final VehicleRateDAO vehicleRateDAO = new VehicleRateDAO();

    /* =========================
       GET - LOAD PAGE
       ========================= */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<VehicleExitViewDTO> all = vehicleDAO.getVehiclesInsideForExit();

            List<VehicleExitViewDTO> preBooked = new ArrayList<>();
            List<VehicleExitViewDTO> walkIn = new ArrayList<>();

            LocalDateTime now = LocalDateTime.now();

            for (VehicleExitViewDTO v : all) {
            	
            	

                VehicleRate rate = vehicleRateDAO.getRateByVehicleType(v.getVehicleType());
                if (rate == null) rate = new VehicleRate(v.getVehicleType(), 0.0, 1.0, 1.0);

                // Set estimated amount
                v.setEstimatedAmount(calculateEstimatedFee(v, now, rate));

                if (v.getBookingType() == BookingType.PREBOOK) {
                    preBooked.add(v);
                } else {
                    walkIn.add(v);
                }
            }

            ExitStats preStats = ExitStatsCalculator.calculate(preBooked);
            ExitStats walkInStats = ExitStatsCalculator.calculate(walkIn);

            req.setAttribute("preBookedVehicles", preBooked);
            req.setAttribute("walkInVehicles", walkIn);
            req.setAttribute("preStats", preStats);
            req.setAttribute("walkInStats", walkInStats);

            req.getRequestDispatcher("/admin/vehicleExit.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load vehicle exit data: " + e.getMessage());
            req.getRequestDispatcher("/admin/vehicleExit.jsp")
               .forward(req, resp);
        }
    }

    /* =========================
       POST - RECORD EXIT
       ========================= */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Connection con = null;
        try {
            con = GetConnection.getConnection();
            con.setAutoCommit(false);

            // Get bookingId from request
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));

            //  Load vehicle + booking
            VehicleExitViewDTO dto = vehicleDAO.getExitViewByBookingId(con, bookingId);

            if (dto == null || dto.getEntryTime() == null) {
                req.setAttribute("error", "Vehicle already exited or invalid");
                doGet(req, resp);
                return;
            }

            LocalDateTime exitTime = LocalDateTime.now();

            // Load rate
            VehicleRate rate = vehicleRateDAO.getRateByVehicleType(con, dto.getVehicleType());

            // Calculate final fee
            double finalAmount = (dto.getBookingType() == BookingType.PREBOOK)
                    ? FeeCalculator.calculatePreBookFinal(
                        dto.getEntryTimeLocal(),
                        dto.getBookingEndTimeLocal(),
                        exitTime,
                        rate
                    )
                    : FeeCalculator.calculateWalkInFinal(
                        dto.getEntryTimeLocal(),
                        exitTime,
                        rate
                    );

            //  Update vehicle
            vehicleDAO.updateVehicleExit(con, dto.getVehicleId(), exitTime, finalAmount);

            //  Update booking
            vehicleDAO.updateBookingCompleted(con, bookingId, finalAmount);

            //  Free slot
            vehicleDAO.updateSlotStatus(con, dto.getSlotId(), "FREE");

            con.commit();

            req.setAttribute("message", "Vehicle exited successfully. Fee ₹" + String.format("%.2f", finalAmount));
            resp.sendRedirect(req.getContextPath() + "/vehicleExit");

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            req.setAttribute("error", "Exit failed: " + e.getMessage());
            doGet(req, resp);
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }


  
    private double calculateEstimatedFee(VehicleExitViewDTO v, LocalDateTime now, VehicleRate rate) {
        if (v.getFinalAmount() != null) return v.getFinalAmount();

        if (v.getBookingType() == BookingType.PREBOOK) {
            LocalDateTime end = v.getBookingEndTimeLocal();
            return FeeCalculator.calculatePreBookEstimate(v.getEntryTimeLocal(), 
                                                          end != null ? end : now, 
                                                          rate);
        } else {
            return FeeCalculator.calculateWalkInFinal(v.getEntryTimeLocal(), now, rate);
        }
    }
}