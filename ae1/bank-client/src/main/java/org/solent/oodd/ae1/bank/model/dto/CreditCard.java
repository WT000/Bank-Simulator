package org.solent.oodd.ae1.bank.model.dto;

import javax.persistence.Embeddable;

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
    
    public CreditCard(String cardnumber, String name, String endDate, String cvv) {
        this.cardnumber = cardnumber;
        this.name = name;
        this.endDate = endDate;
        this.cvv = cvv;
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
        return "CreditCard{" + "name=" + name + ", endDate=" + endDate + ", cardnumber=" + cardnumber + ", cvv=NOT PRINTED" +  ", issueNumber=" + issueNumber + '}';
    }
    
    
    
    
}
