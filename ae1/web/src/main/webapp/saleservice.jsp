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
    String result = "<p id=\"resultText\"> Please enter your details and an amount to send below.</p>";
        
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
            // Validate the Expiry date
            customerCard.setEndDate(cardDate);
            if (!customerCard.cardDateExpiredOrError()) {
                customerCard.setCardnumber(cardNo);
                customerCard.setName(cardName);
                customerCard.setCvv(cardCvv);
            } else {
                result = "<p id=\"resultText\" style=\"color:red;\">ERROR - The card has expired.</p>";
                error = true;
            }
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
    <div id="resultContainer" class="bg-dark">
        <div id="result">
            <%= result %>
        </div>
    </div>
    
    <div id="formPlacer">
        <div id="formContainer" class="container-md">
            <form id="transactionForm" method="post" autocomplete="off">
                <input type="hidden" name="action" value="doTransaction">
                
                <div class="row">
                    <div class="col-md-6">
                        <label for="customerCardNo">Card Number</label>
                        <input type="text" class="form-control" id="customerCardNo" name="cardNumber" placeholder="1111222233334444" pattern="[0-9]{16}" max="999999999999999" onclick="show_easy_numpad(this, 'number');" required>
                    </div>
                    <div class="col-md-6">
                        <label for="customerNameOnCard">Name on Card</label>
                        <input type="text" class="form-control" id="customerNameOnCard" name="cardName" placeholder="John Doe" required>
                    </div>
                </div>
                
                <div class="row mt-3 mb-3">
                    <div class="col">
                        <label for="customerExpireDate">Expiry Date</label>
                        <input type="text" class="form-control" id="customerExpireDate" name="cardDate" placeholder="MM/YY" pattern="([0-9]{2}[/]?){2}" onclick="show_easy_numpad(this, 'date');" required>
                    </div>
                    <div class="col">
                        <label for="customerCvv">Cvv</label>
                        <input type="text" class="form-control" id="customerCvv" name="cardCvv" placeholder="123" pattern="[0-9]{3}" max="99" onclick="show_easy_numpad(this, 'number');" required>
                    </div>
                    <div class="col">
                        <label for="customerAmount">Amount</label>
                        <input type="text" class="form-control" id="customerAmount" name="amount" placeholder="£0" pattern="[0-9]*\.?[0-9]*" max="1000000" onclick="show_easy_numpad(this, 'decimal');" required>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col text-center">
                        <button class="btn btn-dark submitButton">Submit</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<jsp:include page="footersaleservice.jsp"/>