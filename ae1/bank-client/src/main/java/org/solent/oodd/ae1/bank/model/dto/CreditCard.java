package org.solent.oodd.ae1.bank.model.dto;

import javax.persistence.Embeddable;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;

/**
 *
 * @author WT000
 */
@Embeddable
public class CreditCard {

    private String name;

    private String endDate;

    private String cardnumber;

    private String cvv;

    private String issueNumber = "01";

    public CreditCard() {
        this.cardnumber = "";
        this.name = "";
        this.endDate = "";
        this.cvv = "111";
    }

    public CreditCard(String cardnumber) {
        this.cardnumber = cardnumber;
        this.name = "";
        this.endDate = "";
        this.cvv = "111";
    }

    public CreditCard(String cardnumber, String name, String endDate, String cvv) {
        this.cardnumber = cardnumber;
        this.name = name;
        this.endDate = endDate;
        this.cvv = cvv;
    }

    public boolean cardDateExpiredOrError() {
        try {
            if (this.endDate.equals("")) {
                return true;
            }

            // Get the current year and month
            LocalDate currentDate = LocalDate.now();

            // Get the endDate year and month
            String[] parts = this.endDate.split("/");
            int endMonth = Integer.parseInt(parts[0]);
            Integer endYear = null;
            
            if (parts[1].length() == 2) {
                endYear = (currentDate.getYear() - (currentDate.getYear() % 100)) + Integer.valueOf(parts[1]);
            } else if (parts[1].length() == 4) {
                endYear = Integer.valueOf(parts[1]);
            } else {
                return true;
            }

            // Get the first day of the month for the endDate, then find the first day of the next month
            LocalDate endDate = LocalDate.of(endYear, endMonth, 1);
            LocalDate lastDay = endDate.with(TemporalAdjusters.lastDayOfMonth());
            LocalDate expiredDate = lastDay.plusDays(1);

            if (currentDate.isBefore(expiredDate)) {
                // Card is valid as the current date is before the expire date
                return false;
            }
            // Card is invalid as it's equal to or after the expire date
            return true;
        } catch (Exception e) {
            // Card is invalid if there's an error
            return true;
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getCardnumber() {
        return cardnumber;
    }

    public void setCardnumber(String cardnumber) {
        this.cardnumber = cardnumber;
    }

    public String getCvv() {
        return cvv;
    }

    public void setCvv(String cvv) {
        this.cvv = cvv;
    }

    public String getIssueNumber() {
        return issueNumber;
    }

    public void setIssueNumber(String issueNumber) {
        this.issueNumber = issueNumber;
    }

    @Override
    public String toString() {
        return "CreditCard{" + "name=" + name + ", endDate=" + endDate + ", cardnumber=" + cardnumber + ", cvv=NOT PRINTED" + ", issueNumber=" + issueNumber + '}';
    }

}
