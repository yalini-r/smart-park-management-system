package com.smartpark.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.smartpark.dao.ParkingSlotDAO;
import com.smartpark.dto.ParkingSlot;
import com.smartpark.dto.SlotStatus;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = { "/addSlot", "/updateSlot", "/deleteSlot" })
public class ManageSlotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getServletPath();
        ParkingSlotDAO pdao = new ParkingSlotDAO();

        try {

            /* ============================
               ADD SLOT
            ============================= */
            if (action.equals("/addSlot")) {

                String slotNumber = req.getParameter("slotNumber").trim();
                int floor = Integer.parseInt(req.getParameter("floor"));   // <-- NEW

                ParkingSlot slot = new ParkingSlot();
                slot.setSlotNumber(slotNumber);
                slot.setStatus(SlotStatus.FREE);
                slot.setFloor(floor);

                if (pdao.addSlot(slot)) {
                    req.getSession().setAttribute("message", "Slot added successfully!");
                } else {
                    req.getSession().setAttribute("error", "Slot already exists!");
                }

                res.sendRedirect(req.getContextPath() + "/admin/manageSlots.jsp");

                return;
            }

            /* ============================
               UPDATE SLOT
            ============================= */
            else if (action.equals("/updateSlot")) {

                int slotId = Integer.parseInt(req.getParameter("slotId"));
                String slotNumber = req.getParameter("slotNumber").trim();
                SlotStatus status = SlotStatus.valueOf(req.getParameter("status"));
                int floor = Integer.parseInt(req.getParameter("floor"));  // <-- NEW

                ParkingSlot slot = new ParkingSlot(slotId, slotNumber, status, floor);

                if (pdao.updateSlot(slot)) {
                    req.getSession().setAttribute("message", "Slot updated successfully!");
                } else {
                    req.getSession().setAttribute("error", "Slot update failed!");
                }

                res.sendRedirect(req.getContextPath() + "/admin/manageSlots.jsp");

                return;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Database error occurred!");
            res.sendRedirect(req.getContextPath() + "/admin/manageSlots.jsp");

        }
    }

    /* ===================================================
       DELETE SLOT USING GET
    ==================================================== */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getServletPath();
        ParkingSlotDAO pdao = new ParkingSlotDAO();

        try {

            if (action.equals("/deleteSlot")) {
                int slotId = Integer.parseInt(req.getParameter("slotId"));

                if (pdao.deleteSlot(slotId)) {
                    req.getSession().setAttribute("message", "Slot deleted successfully!");
                } else {
                    req.getSession().setAttribute("error", "Slot deletion failed!");
                }

                res.sendRedirect(req.getContextPath() + "/admin/manageSlots.jsp");

                return;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Database error occurred!");
        }

        res.sendRedirect(req.getContextPath() + "/admin/manageSlots.jsp");

    }
}
