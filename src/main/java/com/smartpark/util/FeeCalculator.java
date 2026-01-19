package com.smartpark.util;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import com.smartpark.dto.VehicleRate;


public class FeeCalculator {

    private static final int PREBOOK_GRACE_MINUTES = 15;
    private static final int WALKIN_GRACE_MINUTES = 10;

    private FeeCalculator() {}

    //-- Minimum 1 hour rounding 
    private static long hoursBetween(LocalDateTime start, LocalDateTime end) {
        if (start == null || end == null) return 0;
        long minutes = ChronoUnit.MINUTES.between(start, end);
        return Math.max(1, (long) Math.ceil(minutes / 60.0));
    }

    //-- Estimate fee for pre-booked vehicle (display purposes)
    
    public static double calculatePreBookEstimate(LocalDateTime start, LocalDateTime end, VehicleRate rate) {
        if (start == null || end == null || rate == null) return 0;
        return hoursBetween(start, end) * rate.getHourlyRate() * 1.0; 
    }

    //--Final fee for pre-booked vehicle on exit
    
    public static double calculatePreBookFinal(
            LocalDateTime start,
            LocalDateTime bookingEnd,
            LocalDateTime exit,
            VehicleRate rate
    ) {
        if (start == null || exit == null || rate == null) return 0;

        LocalDateTime end = (bookingEnd != null) ? bookingEnd : start.plusHours(1);
        LocalDateTime graceEnd = end.plusMinutes(PREBOOK_GRACE_MINUTES);

        // If exits within grace period - only booked fee
        if (!exit.isAfter(graceEnd)) {
            return calculatePreBookEstimate(start, end, rate);
        }

        // Extra hours after grace
        long extraHours = hoursBetween(graceEnd, exit);

        double baseFee = calculatePreBookEstimate(start, end, rate);
        double extraFee = extraHours * rate.getHourlyRate() * timeMultiplier(exit, rate);

        return baseFee + extraFee;
    }

    //--Final fee for walk-in vehicle on exit
     
    public static double calculateWalkInFinal(LocalDateTime entry, LocalDateTime exit, VehicleRate rate) {
        if (entry == null || exit == null || rate == null) return 0;

        long totalMinutes = ChronoUnit.MINUTES.between(entry, exit);
        if (totalMinutes <= WALKIN_GRACE_MINUTES) return 0;

        long billableMinutes = totalMinutes - WALKIN_GRACE_MINUTES;
        long hours = Math.max(1, (long) Math.ceil(billableMinutes / 60.0));

        return hours * rate.getHourlyRate() * timeMultiplier(exit, rate);
    }

    //--Multiplier for night/weekend
     
    private static double timeMultiplier(LocalDateTime time, VehicleRate rate) {
        if (time == null || rate == null) return 1.0;

        int hour = time.getHour();
        boolean night = hour >= 22 || hour < 6;
        boolean weekend = time.getDayOfWeek().getValue() >= 6;

        if (night) return rate.getNightMultiplier();
        if (weekend) return rate.getWeekendMultiplier();
        return 1.0;
    }
    
    
    public static boolean isLongStay(LocalDateTime entry, LocalDateTime now) {
        if (entry == null || now == null) return false;
        return ChronoUnit.HOURS.between(entry, now) >= 4; 
    }

    public static boolean isLongStay(
            LocalDateTime entry,
            LocalDateTime bookingEnd,
            LocalDateTime now
    ) {
        if (entry == null || now == null) return false;

        LocalDateTime end = (bookingEnd != null) ? bookingEnd : entry.plusHours(1);
        return ChronoUnit.HOURS.between(entry, now) >
               ChronoUnit.HOURS.between(entry, end);
    }

    public static boolean isOverstay(
            LocalDateTime bookingEnd,
            LocalDateTime now
    ) {
        if (bookingEnd == null || now == null) return false;
        return now.isAfter(bookingEnd.plusMinutes(PREBOOK_GRACE_MINUTES));
    }

}
