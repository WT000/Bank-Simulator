<%-- 
    Document   : saleservice
    Created on : 27 Oct 2021, 20:46:37
    Author     : Will
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="org.solent.oodd.ae1.web.dao.properties.PropertiesDao"%>
<%@page import="org.solent.oodd.ae1.web.dao.properties.WebObjectFactory"%>
<%@page import="org.solent.oodd.ae1.bank.model.dto.CreditCard"%>
<%@page import="org.solent.oodd.ae1.card.checker.RegexCardValidator"%>
<%@page import="org.solent.oodd.ae1.card.checker.CardValidationResult"%>
<%@page import="org.solent.oodd.ae1.bank.client.impl.BankRestClientImpl"%>
<%@page import="org.solent.oodd.ae1.bank.model.dto.TransactionReplyMessage"%>
<%@page import="org.solent.oodd.ae1.bank.model.dto.BankTransactionStatus"%>
<%
    // Setup the ReST client, note that the URL updates would have already been done in the header jsp
    PropertiesDao adminSettings = WebObjectFactory.getPropertiesDao();
    BankRestClientImpl restClient = new BankRestClientImpl(adminSettings.getProperty("org.solent.oodd.ae1.web.url"));
    
    // Get the required bank information before ReST transfers bank card
    String bankCardNo = adminSettings.getProperty("org.solent.oodd.ae1.web.cardNumber");
    String bankCardName = adminSettings.getProperty("org.solent.oodd.ae1.web.cardName");
    String bankDate = adminSettings.getProperty("org.solent.oodd.ae1.web.cardDate");
    String bankCvv = adminSettings.getProperty("org.solent.oodd.ae1.web.cardCvv");
    
    // Edit CreditCard class to make this process easier
    CreditCard bankCard = new CreditCard(bankCardNo, bankCardName, bankDate, bankCvv);
        
    // Bank user details
    String bankUser = adminSettings.getProperty("org.solent.oodd.ae1.web.username");
    String bankPass = adminSettings.getProperty("org.solent.oodd.ae1.web.password");
    
    // Check if a card is currently stored in the session and create it if it doesn't exist
    CreditCard customerCard = (CreditCard) session.getAttribute("customerCard");
    if (customerCard == null) {
        customerCard = new CreditCard("", "", "", "");
        session.setAttribute("customerCard", customerCard);
    }
    
    // Get the current action and set result to the initial value
    String action = (String) request.getParameter("action");
    String result = "<p id=\"resultText\"> Welcome. Please click one of the buttons below.</p>";
    
    // addCard action (means the user is entering a card)
    if ("addCard".equals(action)) {
        String cardNo = (String) request.getParameter("cardNumber");
        String cardName = (String) request.getParameter("cardName");
        String cardDate = (String) request.getParameter("cardDate");
        String cardCvv = (String) request.getParameter("cardCvv");
        
        // JS has checked everything apart from the card itself, so we'll do it here
        CardValidationResult cardResult = RegexCardValidator.isValid(cardNo);
        
        if (cardResult.isValid()) {
            customerCard.setCardnumber(cardNo);
            customerCard.setName(cardName);
            customerCard.setEndDate(cardDate);
            customerCard.setCvv(cardCvv);
            result = "<p id=\"resultText\" style=\"color:green;\">SUCCESS - " + cardNo + " is now your current card.</p>";
        } else {
            result = "<p id=\"resultText\" style=\"color:red;\">ERROR - " + cardResult.getError() + ".</p>";
        }
        
    // doTransaction action (means the user is doing a transaction)
    // TRANSACTION REST CONNECTION
    } else if ("doTransaction".equals(action)) {
        String amount = (String) request.getParameter("amount");
        boolean error = false;
        
        try {
            double numAmount = Double.parseDouble(amount);
        } catch (Exception e) {
            error = true;
        }
        
        if (error) {
            result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - something went wrong when sending to the bank, did you enter a valid amount?</p>";
        } else {
            // Perform the transfer
            try {
                TransactionReplyMessage restResponse = restClient.transferMoney(customerCard, bankCard, Double.valueOf(amount), bankUser, bankPass);
            
                // Check whether the transaction is successful or not
                if (restResponse.getStatus() == BankTransactionStatus.SUCCESS) {
                    result = "<p id=\"resultText\" style=\"color:green;\">SUCCESS - £" + amount + " has been taken from your account.</p>";
                } else {
                    // null isn't a helpful message if the bank properties haven't been correctly configured.
                    if (restResponse.getMessage() != null) {
                        result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - " + restResponse.getMessage() + ".</p>";
                    } else {
                        result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - couldn't perform transactional operations on the currently configured bank.</p>";
                    }
                }
            } catch (Exception e) {
                result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - couldn't perform transactional operations on the currently configured bank.</p>";
            }
        }
    // doRefund action (means the user is sending a refund amount to a card)
    // REFUND REST CONNECTION
    } else if ("doRefund".equals(action)) {
        // try block / if check here to ensure amount isn't empty
        String amount = (String) request.getParameter("amount");
        boolean error = false;
        
        try {
            double numAmount = Double.parseDouble(amount);
        } catch (Exception e) {
            error = true;
        }
        
        if (error) {
            result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - something went wrong when refunding, did you enter a valid amount?</p>";
        } else {
            // Perform the refund
            try {
                TransactionReplyMessage restResponse = restClient.transferMoney(bankCard, customerCard, Double.valueOf(amount));

                // Check whether the transaction is successful or not
                if (restResponse.getStatus() == BankTransactionStatus.SUCCESS) {
                    result = "<p id=\"resultText\" style=\"color:green;\">SUCCESS - £" + amount + " has been refunded to " + restResponse.getToCardNo() + ".</p>";
                } else {
                    if (restResponse.getMessage() != null) {
                        result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - " + restResponse.getMessage() + ".</p>";
                    } else {
                        result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - couldn't perform transactional operations on the currently configured bank.</p>";
                    }
                }
            } catch (Exception e) {
                result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - couldn't perform transactional operations on the currently configured bank.</p>";
            }
        }
    }
%>
<jsp:include page="header.jsp"/>
<!-- Main app start -->
<div id="appContainer">
    <div id="resultContainer">
        <div id="result">
            <%= result %>
        </div>
    </div>
    
    <div id="formContainer">
        <form id="addCardForm" class="innerForm" method="post" autocomplete="off">
            <input type="hidden" name="action" value="addCard">
            
            <label>Card Number</label><input type="text" name="cardNumber" placeholder="1111222233334444" value="<%=customerCard.getCardnumber()%>" pattern="[0-9]{16}" required><br>
            <label>Name on Card</label><input type="text" name="cardName" placeholder="John Doe" value="<%=customerCard.getName()%>" required><br>
            <label>Expiration Date</label><input type="text" name="cardDate" placeholder="01/26" value="<%=customerCard.getEndDate()%>" pattern="([0-9]{2}[/]?){2}" required><br>
            <label>Cvv</label><input type="text" name="cardCvv" placeholder="123" value="<%=customerCard.getCvv()%>" pattern="[0-9]{3}" required><br>
            <button>Submit</button>
        </form>
        
        <form id="transactionForm" class="innerForm" method="post" autocomplete="off">
            <input type="hidden" name="action" value="doTransaction">
            
            <label>Amount to send [attach credit card UI here] £</label><input type="text" name="amount" placeholder="0.00" pattern="\d{1,5}" required><br>
            <button>Submit</button>
        </form>
        
        <form id="refundForm" class="innerForm" method="post" autocomplete="off">
            <input type="hidden" name="action" value="doRefund">
            
            <!-- If this is stored in the admin menu, a credit card field will also be needed -->
            <label>Amount to refund [attach credit card UI here] £</label><input type="text" name="amount" placeholder="0.00" pattern="\d{1,5}" required><br>
            <button>Submit</button>
        </form>
    </div>
    
    <div id="functionContainer">
        <div class="functionButton" id="buttonCard">
            <p>Enter Card</p>
        </div>
        
        <div class="functionButton" id="buttonTransaction">
            <p>Transaction</p>
        </div>
        
        <!-- probably should put this in the owner menu as that'll be secured, we don't want customers giving refunds to themselves -->
        <!-- if it's done this way, we should add a separate field for entering a customer card number -->
        <div class="functionButton" id="buttonRefund">
            <p>Refund</p>
        </div>
    </div>
</div>
<!-- Main app end -->
<jsp:include page="footer.jsp"/>