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
<%@page import="org.solent.oodd.ae1.bank.client.impl.BankRestClientImpl"%>
<%@page import="org.solent.oodd.ae1.bank.model.dto.TransactionReplyMessage"%>
<%@page import="org.solent.oodd.ae1.bank.model.dto.BankTransactionStatus"%>
<%
    // Setup the ReST client, note that the URL updates would have already been done in the header jsp
    PropertiesDao adminSettings = WebObjectFactory.getPropertiesDao();
    BankRestClientImpl restClient = new BankRestClientImpl(adminSettings.getProperty("org.solent.oodd.ae1.web.url"));
    
    // Get the required bank information before ReST transfers
    // Bank card
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
    
    String action = (String) request.getParameter("action");
    String result = "Welcome. Please click one of the buttons below.";
    String scriptToRun = "";
    
    if ("addCard".equals(action)) {
        String cardNo = (String) request.getParameter("cardNumber");
        String cardName = (String) request.getParameter("cardName");
        String cardDate = (String) request.getParameter("cardDate");
        String cardCvv = (String) request.getParameter("cardCvv");
        
        customerCard.setCardnumber(cardNo);
        customerCard.setName(cardName);
        customerCard.setEndDate(cardDate);
        customerCard.setCvv(cardCvv);
        
        // Card validation using if statements would be here
        // perhaps run a script so it makes the relevant form stay visible
        result = "<p style=\"color:green;\">SUCCESS - " + cardNo + " is now your current card.</p>";
    // TRANSACTION REST CONNECTION
    } else if ("doTransaction".equals(action)) {
        String amount = (String) request.getParameter("amount");
        
        // Perform the transfer
        TransactionReplyMessage restResponse = restClient.transferMoney(customerCard, bankCard, Double.valueOf(amount), bankUser, bankPass);
        
        if (restResponse.getStatus() == BankTransactionStatus.SUCCESS) {
            result = "<p style=\"color:green;\">SUCCESS - £" + amount + " has been taken from your account.</p>";
        } else {
            // null isn't a helpful message if the bank properties haven't been correctly configured.
            if (restResponse.getMessage() != null) {
                result = "<p style=\"color:red;\">FAILURE - " + restResponse.getMessage() + ".</p>";
            } else {
                result = "<p style=\"color:red;\">FAILURE - couldn't perform operations on the currently configured bank.</p>";
            }
        }
    // REFUND REST CONNECTION
    } else if ("doRefund".equals(action)) {
        String amount = (String) request.getParameter("amount");
        
        // Perform the refund, like the notes below, perhaps this could use a seperate form in the future
        TransactionReplyMessage restResponse = restClient.transferMoney(bankCard, customerCard, Double.valueOf(amount));
        
        if (restResponse.getStatus() == BankTransactionStatus.SUCCESS) {
            result = "<p style=\"color:green;\">SUCCESS - £" + amount + " has been refunded to " + restResponse.getToCardNo() + ".</p>";
        } else {
            if (restResponse.getMessage() != null) {
                result = "<p style=\"color:red;\">FAILURE - " + restResponse.getMessage() + ".</p>";
            } else {
                result = "<p style=\"color:red;\">FAILURE - couldn't perform operations on the currently configured bank.</p>";
            }
        }
    }
%>
<jsp:include page="header.jsp"/>
<!-- Page start -->
<div id="appContainer">
    <div id="resultContainer">
        <div id="result">
            <p id="resultText"><%= result %></p>
        </div>
    </div>
    
    <div id="formContainer">
        <form id="addCardForm" class="innerForm" method="post">
            <input type="hidden" name="action" value="addCard">
            
            <label>Card Number</label><input type="text" name="cardNumber" value="<%=customerCard.getCardnumber()%>" required><br>
            <label>Name on Card</label><input type="text" name="cardName" placeholder="(optional)" value="<%=customerCard.getName()%>"><br>
            <label>Expiration Date</label><input type="text" name="cardDate" placeholder="(optional)" value="<%=customerCard.getEndDate()%>"><br>
            <label>Cvv</label><input type="text" name="cardCvv" placeholder="(optional)" value="<%=customerCard.getCvv()%>"><br>
            <button>Submit</button>
        </form>
        
        <form id="transactionForm" class="innerForm" method="post">
            <input type="hidden" name="action" value="doTransaction">
            
            <label>Amount to send</label><input type="text" name="amount"><br>
            <button>Submit</button>
        </form>
        
        <form id="refundForm" class="innerForm" method="post">
            <input type="hidden" name="action" value="doRefund">
            
            <label>Amount to refund</label><input type="text" name="amount"><br>
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
<!-- Page end -->

<jsp:include page="footer.jsp"/>