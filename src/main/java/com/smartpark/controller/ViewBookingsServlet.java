package com.smartpark.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.smartpark.dao.BookingDAO;
import com.smartpark.dto.BookingStatus;
import com.smartpark.dto.BookingViewDTO;

@SuppressWarnings("serial")
@WebServlet("/viewBookings")
public class ViewBookingsServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {
        	
        	int justExpiredCount = bookingDAO.processExpiredBookings();
        	req.setAttribute("justExpiredCount", justExpiredCount);


             
          

            List<BookingViewDTO> allBookings =
                    bookingDAO.getAllBookingsForAdmin();

            String bookingIdParam = req.getParameter("bookingId");
            if (bookingIdParam != null && !bookingIdParam.isEmpty()) {
                req.setAttribute("highlightId", Integer.parseInt(bookingIdParam));
            }
            else {
                allBookings = bookingDAO.getAllBookingsForAdmin();
            }

            // Split bookings into Pre-Booked and Walk-In
            List<BookingViewDTO> preBooked = new ArrayList<>();
            List<BookingViewDTO> walkIn = new ArrayList<>();

            
          
            for (BookingViewDTO b : allBookings) {
                if ("PREBOOK".equalsIgnoreCase(b.getBookingType())) {
                    preBooked.add(b);
                } else if ("WALKIN".equalsIgnoreCase(b.getBookingType())) {
                    walkIn.add(b);
                }
            }

            req.setAttribute("preBookedBookings", preBooked);
            req.setAttribute("walkInBookings", walkIn);

            // -------------------------------
            // PRE-BOOKED STATS
            // -------------------------------
            int preBookedBooked = 0;
            int preBookedActive = 0;
            int preBookedCompleted = 0;
            int preBookedCancelled = 0;
            int preBookedExpired = 0;

            for (BookingViewDTO b : preBooked) {
                BookingStatus status = b.getStatus();
                if (status == BookingStatus.BOOKED) preBookedBooked++;
                else if (status == BookingStatus.ACTIVE) preBookedActive++;
                else if (status == BookingStatus.COMPLETED) preBookedCompleted++;
                else if (status == BookingStatus.CANCELLED) preBookedCancelled++;
                else if (status == BookingStatus.EXPIRED) preBookedExpired++;
            }


            req.setAttribute("preBookedBookedCount", preBookedBooked);
            req.setAttribute("preBookedActiveCount", preBookedActive);
            req.setAttribute("preBookedCompletedCount", preBookedCompleted);
            req.setAttribute("preBookedCancelledCount", preBookedCancelled);
            req.setAttribute("preBookedExpiredCount", preBookedExpired);

            // -------------------------------
            // WALK-IN STATS
            // -------------------------------
            int walkInActive = 0;
            int walkInCompleted = 0;
            int walkInCancelled = 0;
            int walkInTotal = walkIn.size();

            for (BookingViewDTO b : walkIn) {
                BookingStatus status = b.getStatus();
                if (status == BookingStatus.ACTIVE) walkInActive++;
                else if (status == BookingStatus.COMPLETED) walkInCompleted++;
                else if (status == BookingStatus.CANCELLED) walkInCancelled++;
            }


            req.setAttribute("walkInActiveCount", walkInActive);
            req.setAttribute("walkInCompletedCount", walkInCompleted);
            req.setAttribute("walkInCancelledCount", walkInCancelled);
            req.setAttribute("walkInTotalCount", walkInTotal);

            // -------------------------------
            // TOTAL STATS (all bookings)
            // -------------------------------
            int bookedCount = bookingDAO.getCountByStatus(BookingStatus.BOOKED);
            int activeCount = bookingDAO.getCountByStatus(BookingStatus.ACTIVE);
            int completedCount = bookingDAO.getCountByStatus(BookingStatus.COMPLETED);
            int cancelledCount = bookingDAO.getCountByStatus(BookingStatus.CANCELLED);
            int expiredCount = bookingDAO.getCountByStatus(BookingStatus.EXPIRED);

          

            req.setAttribute("bookedCount", bookedCount);
            req.setAttribute("activeCount", activeCount);
            req.setAttribute("completedCount", completedCount);
            req.setAttribute("cancelledCount", cancelledCount);
            req.setAttribute("expiredCount", expiredCount);
            req.setAttribute("preBookedTotalCount", preBooked.size());
           


        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred");
        }

        req.getRequestDispatcher("/admin/viewBookings.jsp")
           .forward(req, res);
    }
}
