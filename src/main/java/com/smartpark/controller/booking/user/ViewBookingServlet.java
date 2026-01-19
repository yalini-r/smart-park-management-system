package com.smartpark.controller.booking.user;

import com.smartpark.dao.BookingDAO;

import com.smartpark.dto.BookingViewDTO;
import com.smartpark.dto.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@SuppressWarnings("serial")
@WebServlet("/user/view-bookings")
public class ViewBookingServlet extends HttpServlet {

    

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");
            int userId = user.getId();
            

            BookingDAO bookingDAO = new BookingDAO();
            List<BookingViewDTO> bookings =
            	    bookingDAO.getBookingsForUserView(userId);

            req.setAttribute("bookings", bookings);

            req.getRequestDispatcher("/user/viewBooking.jsp").forward(req, res);

        } catch (SQLException e) {
            throw new ServletException("Unable to load bookings", e);
        }
    }
}
