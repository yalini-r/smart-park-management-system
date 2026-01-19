package com.smartpark.util;

import java.time.LocalDateTime;
import java.util.List;

import com.smartpark.dto.BookingType;
import com.smartpark.dto.ExitStats;
import com.smartpark.dto.VehicleExitViewDTO;

public class ExitStatsCalculator {

    private ExitStatsCalculator() {}

    public static ExitStats calculate(List<VehicleExitViewDTO> list) {

        ExitStats stats = new ExitStats();

        int longStay = 0;
        int overstay = 0;
        int exited = 0;
        double revenue = 0;

        
        LocalDateTime now = LocalDateTime.now();

        for (VehicleExitViewDTO v : list) {

            boolean isExited = v.getExitTime() != null;

            // --------------------------------
            // CALCULATE FLAGS (HERE)
            // --------------------------------
            boolean longStayFlag = false;
            boolean overstayFlag = false;

            if (!isExited) {
                if (v.getBookingType() == BookingType.PREBOOK) {

                    overstayFlag = FeeCalculator.isOverstay(
                            v.getBookingEndTimeLocal(),
                            now
                    );

                    longStayFlag = FeeCalculator.isLongStay(
                            v.getEntryTimeLocal(),
                            v.getBookingEndTimeLocal(),
                            now
                    );

                } else { // WALK-IN

                    longStayFlag = FeeCalculator.isLongStay(
                            v.getEntryTimeLocal(),
                            now
                    );
                }
            }

            // --------------------------------
            //  SET FLAGS ON DTO
            // --------------------------------
            v.setLongStay(longStayFlag);
            v.setOverstay(overstayFlag);

            // --------------------------------
            // COUNT STATS (UNCHANGED)
            // --------------------------------
            if (!isExited) {
                if (longStayFlag) longStay++;
                if (v.getBookingType() == BookingType.PREBOOK && overstayFlag) overstay++;
            }

            if (isExited) {
                exited++;
                if (v.getFinalAmount() != null && v.getFinalAmount() > 0) {
                    revenue += v.getFinalAmount();
                }
            }
        }

        stats.setTotal(list.size());
        stats.setLongStay(longStay);
        stats.setOverstay(overstay);
        stats.setExited(exited);
        stats.setRevenue(revenue);

        return stats;
    }
}
