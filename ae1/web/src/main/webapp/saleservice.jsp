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
    // Always set logged in back to false when this page is gone onto
    session.setAttribute("loggedIn", false);
    
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
    
    // Get the current action and set result to the initial value
    String action = (String) request.getParameter("action");
    String result = "<p id=\"resultText\"> Welcome. Please click one of the buttons below.</p>";
        
    // doTransaction action (means the user is doing a transaction)
    // TRANSACTION REST CONNECTION
    if ("doTransaction".equals(action)) {
        String cardNo = (String) request.getParameter("cardNumber");
        String cardName = (String) request.getParameter("cardName");
        String cardDate = (String) request.getParameter("cardDate");
        String cardCvv = (String) request.getParameter("cardCvv");
        String amount = (String) request.getParameter("amount");
        boolean error = false;
        
        // Check if the amount is a valid double, card validation result will overwrite this
        // First check to see if it's a valid double
        try {
           double numAmount = Double.parseDouble(amount);
        } catch (Exception e) {
            error = true;
        }
        
        // Check if the card is valid
        CardValidationResult cardResult = RegexCardValidator.isValid(cardNo);
        CreditCard customerCard = new CreditCard();
        
        if (cardResult.isValid()) {
            customerCard.setCardnumber(cardNo);
            customerCard.setName(cardName);
            customerCard.setEndDate(cardDate);
            customerCard.setCvv(cardCvv);
        } else {
            result = "<p id=\"resultText\" style=\"color:red;\">ERROR - " + cardResult.getError() + ".</p>";
            error = true;
        }
        
        // Only attempt the transfer if no errors happened (meaning the card and amount are completely valid)
        if (!error) {
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
    }
%>
<jsp:include page="headersaleservice.jsp"/>
<div id="appContainer">
    <div id="resultContainer">
        <div id="result">
            <%= result %>
        </div>
    </div>
    
    <div id="formContainer">
        <form id="addCardForm" class="innerForm" method="post" autocomplete="off">
            <input type="hidden" name="action" value="doTransaction">
            
            <label>Card Number</label><input type="text" name="cardNumber" placeholder="1111222233334444" pattern="[0-9]{16}" required><br>
            <label>Name on Card</label><input type="text" name="cardName" placeholder="John Doe" required><br>
            <label>Expiration Date</label><input type="text" name="cardDate" placeholder="01/26" pattern="([0-9]{2}[/]?){2}" required><br>
            <label>Cvv</label><input type="text" name="cardCvv" placeholder="123" pattern="[0-9]{3}" required><br>
            <label>Amount to send £</label><input type="text" name="amount" placeholder="0.00" required><br>
            <button>Submit</button>
        </form>
    </div>
</div>
<jsp:include page="footersaleservice.jsp"/>