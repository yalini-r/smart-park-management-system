package com.smartpark.controller;

import com.smartpark.dao.VehicleDAO;
import com.smartpark.dto.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("serial")
@WebServlet("/admin/revenue")
public class RevenueReportServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;

    @Override
    public void init() throws ServletException {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            
            List<VehicleExitViewDTO> allExits = vehicleDAO.getRevenueByDate(null, null, null);

            // Separate Pre-Booked and Walk-In
            List<VehicleExitViewDTO> preBookedList = new ArrayList<VehicleExitViewDTO>();
            List<VehicleExitViewDTO> walkInList = new ArrayList<VehicleExitViewDTO>();

            for (int i = 0; i < allExits.size(); i++) {
                VehicleExitViewDTO v = allExits.get(i);
                if (v.getBookingType() == BookingType.PREBOOK) {
                    preBookedList.add(v);
                } else {
                    walkInList.add(v);
                }
            }

     
            RevenueStatsDTO stats = new RevenueStatsDTO();
            LocalDate today = LocalDate.now();

            // Pre-Booked Stats
            double preToday = 0, preWeek = 0, preMonth = 0, preTotal = 0;
            for (int i = 0; i < preBookedList.size(); i++) {
                VehicleExitViewDTO v = preBookedList.get(i);
                if (v.getExitTime() == null) continue;

               
                LocalDate exitDate = new java.sql.Timestamp(v.getExitTime().getTime())
                                        .toLocalDateTime()
                                        .toLocalDate();

                double amt = v.getFinalAmount();
                preTotal += amt;

                if (exitDate.isEqual(today)) preToday += amt;
                if (!exitDate.isBefore(today.minusDays(6))) preWeek += amt;
                if (exitDate.getMonth() == today.getMonth() && exitDate.getYear() == today.getYear()) preMonth += amt;
            }


            stats.setPreBookToday(preToday);
            stats.setPreBookWeek(preWeek);
            stats.setPreBookMonth(preMonth);
            stats.setPreBookTotal(preTotal);

            // Walk-In Stats
            double walkToday = 0, walkWeek = 0, walkMonth = 0, walkTotal = 0;
            for (int i = 0; i < walkInList.size(); i++) {
                VehicleExitViewDTO v = walkInList.get(i);
                if (v.getExitTime() == null) continue;

             
                LocalDate exitDate = new java.sql.Timestamp(v.getExitTime().getTime())
                                        .toLocalDateTime()
                                        .toLocalDate();
                double amt = v.getFinalAmount();
                walkTotal += amt;

                if (exitDate.isEqual(today)) walkToday += amt;
                if (!exitDate.isBefore(today.minusDays(6))) walkWeek += amt;
                if (exitDate.getMonth() == today.getMonth() && exitDate.getYear() == today.getYear()) walkMonth += amt;
            }

            stats.setWalkinToday(walkToday);
            stats.setWalkinWeek(walkWeek);
            stats.setWalkinMonth(walkMonth);
            stats.setWalkinTotal(walkTotal);

            List<String> chartLabels = new ArrayList<String>();
            chartLabels.add("Today");
            chartLabels.add("Last 7 Days");
            chartLabels.add("This Month");
            chartLabels.add("Total");

            List<Double> preBookedChartData = new ArrayList<Double>();
            preBookedChartData.add(preToday);
            preBookedChartData.add(preWeek);
            preBookedChartData.add(preMonth);
            preBookedChartData.add(preTotal);

            List<Double> walkInChartData = new ArrayList<Double>();
            walkInChartData.add(walkToday);
            walkInChartData.add(walkWeek);
            walkInChartData.add(walkMonth);
            walkInChartData.add(walkTotal);

          
            req.setAttribute("preBookedRevenueList", preBookedList);
            req.setAttribute("walkInRevenueList", walkInList);
            req.setAttribute("stats", stats);

            req.setAttribute("chartLabels", chartLabels);
            req.setAttribute("preBookedChartData", preBookedChartData);
            req.setAttribute("walkInChartData", walkInChartData);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred");
        }

        req.getRequestDispatcher("/admin/revenueReport.jsp").forward(req, res);
    }
}
