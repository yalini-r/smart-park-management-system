package com.smartpark.controller;

import java.io.IOException;


import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.smartpark.dao.BookingDAO;

import com.smartpark.dto.Booking;


@SuppressWarnings("serial")
@WebServlet("/expire")
public class BookingExpiryServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();


    @Override
   
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html");
        try {
            List<Booking> expired = bookingDAO.getExpiredBookings();
            StringBuilder sb = new StringBuilder();
            sb.append("<h2>Expired Bookings Processed:</h2>");
            sb.append("<ul>");
            for (Booking b : expired) {
                bookingDAO.expireBookingWithPenalty(b);
                sb.append("<li>Booking ID: ").append(b.getBookingId())
                  .append(", Slot: ").append(b.getSlotId()).append("</li>");
                System.out.println("Booking expired & slot freed: " + b.getBookingId());
            }
            sb.append("</ul>");
            resp.getWriter().write(sb.toString());
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("<p>Error occurred: " + e.getMessage() + "</p>");
        }
    }

    }