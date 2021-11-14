<%-- 
    Document   : admin
    Created on : 13 Nov 2021, 12:23:40
    Author     : Will
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.solent.oodd.ae1.web.dao.properties.PropertiesDao"%>
<%@page import="org.solent.oodd.ae1.web.dao.properties.WebObjectFactory"%>
<%@page import="org.solent.oodd.ae1.bank.client.impl.BankRestClientImpl"%>
<%@page import="org.solent.oodd.ae1.card.checker.CardValidationResult"%>
<%@page import="org.solent.oodd.ae1.card.checker.RegexCardValidator"%>
<%@page import="org.solent.oodd.ae1.bank.client.impl.BankRestClientImpl"%>
<%@page import="org.solent.oodd.ae1.bank.model.dto.TransactionReplyMessage"%>
<%@page import="org.solent.oodd.ae1.bank.model.dto.BankTransactionStatus"%>
<%@page import="org.solent.oodd.ae1.bank.model.dto.CreditCard"%>
<%@page import="org.solent.oodd.ae1.password.PasswordUtils"%>
<%
    PropertiesDao adminSettings = WebObjectFactory.getPropertiesDao();
    String bankUrl = adminSettings.getProperty("org.solent.oodd.ae1.web.url");
    String bankCardNo = adminSettings.getProperty("org.solent.oodd.ae1.web.cardNumber");
    String bankUsername = adminSettings.getProperty("org.solent.oodd.ae1.web.username");
    String bankPassword = adminSettings.getProperty("org.solent.oodd.ae1.web.password");
    String bankHashedPassword = adminSettings.getProperty("org.solent.oodd.ae1.web.hashedPassword");
    
    BankRestClientImpl restClient = new BankRestClientImpl(adminSettings.getProperty("org.solent.oodd.ae1.web.url"));
    CreditCard bankCard = new CreditCard(bankCardNo);
    
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    if (loggedIn == null) {
        loggedIn = false;
        session.setAttribute("loggedIn", false);
    }
    
    // Automatically log in if there's currently no set username or password
    if (bankUsername.equals("") || bankPassword.equals("")) {
        loggedIn = true;
    }
    
    String result = "<p id=\"resultText\"> Admin Control Panel </p>";
    
    String action = (String) request.getParameter("action");
    if ("adminLogin".equals(action)) {
        String enteredUsername = (String) request.getParameter("propertiesUsername");
        String enteredPassword = (String) request.getParameter("propertiesPassword");
        
        // Check if the password equals the hashed password
        if (PasswordUtils.checkPassword(enteredPassword, bankHashedPassword) && enteredUsername.equals(bankUsername)) {
            loggedIn = true;
            session.setAttribute("loggedIn", true);
            result = "<p id=\"resultText\" style=\"color:green;\"> SUCCESS - This session will expire when you return to the sale service. </p>";
        } else {
            result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - The account details are incorrect, you may want to check the properties file. </p>";
        }
    } else if ("setProperties".equals(action)) {
        bankUrl = (String) request.getParameter("propertiesURL");
        bankUsername = (String) request.getParameter("propertiesUsername");
        bankPassword = (String) request.getParameter("propertiesPassword");
        bankCardNo = (String) request.getParameter("propertiesCard");
        
        CardValidationResult cardResult = RegexCardValidator.isValid(bankCardNo);
        
        if (cardResult.isValid()) {
            BankRestClientImpl propertiesRestClient = new BankRestClientImpl(bankUrl);
            CreditCard propertiesCard = new CreditCard(bankCardNo, "", "", "");
            
            try {
                TransactionReplyMessage propertiesResponse = propertiesRestClient.transferMoney(propertiesCard, propertiesCard, 0.00, bankUsername, bankPassword);
            
                if (propertiesResponse.getStatus() == BankTransactionStatus.SUCCESS) {
                    adminSettings.setProperty("org.solent.oodd.ae1.web.url", bankUrl);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.username", bankUsername);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.password", bankPassword);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.cardNumber", bankCardNo);
                    result = "<p id=\"resultText\" style=\"color:green;\"> SUCCESS - The new properties were saved. </p>";
                } else {
                    result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - Invalid bank credentials, changes won't be saved. </p>";
                }
            } catch (Exception e) {
                result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - Something went wrong when setting properties: " + e.getMessage() + "</p>";
            }
        } else {
            result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - The card isn't valid, changes won't be saved. </p>";
        }
    } else if ("doRefund".equals(action)) {
        String cardNo = (String) request.getParameter("cardNumber");
        String amount = (String) request.getParameter("amount");
        boolean error = false;
        
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
        } else {
            result = "<p id=\"resultText\" style=\"color:red;\">ERROR - " + cardResult.getError() + ".</p>";
            error = true;
        }
        
        if (!error) {
            try {
                TransactionReplyMessage restResponse = restClient.transferMoney(bankCard, customerCard, Double.valueOf(amount));
                
                // Check whether the transaction is successful or not
                if (restResponse.getStatus() == BankTransactionStatus.SUCCESS) {
                    result = "<p id=\"resultText\" style=\"color:green;\">SUCCESS - £" + amount + " has been refunded to " + cardNo + ".</p>";
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
<jsp:include page="headeradmin.jsp"/>
<div id="resultContainer">
    <div id="result">
        <%= result %>
    </div>
</div>
        
<% if (!loggedIn) { %>
    <div id="formPlacer">    
        <div id="formContainerSmall" class="container-md">
            <form id="loginForm" method="post" autocomplete="off">
                <input type="hidden" name="action" value="adminLogin">
                
                <div class="row">
                    <div class="col">
                        <label for="loginUsername">Properties Username</label>
                        <input type="text" class="form-control" id="loginUsername" name="propertiesUsername" required>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col">
                        <label for="loginPassword">Properties Password</label>
                        <input type="password" class="form-control" id="loginPassword" name="propertiesPassword" required>
                    </div>
                </div>
                
                <div class="row mt-2">
                    <div class="col text-center">
                        <button class="btn btn-dark submitButton">Login</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
<% } else if (loggedIn) { %>
    <div id="formPlacer">
        <div id="formContainer">
            <form id="propertiesForm" class="innerForm" method="post" autocomplete="off">
                <input type="hidden" name="action" value="setProperties">
                
                <div class="row">
                    <div class="col">
                        <label for="propertyURL">Bank URL</label>
                        <input type="url" class="form-control" id="propertyURL" name="propertiesURL" placeholder="Bank URL" value="<%=bankUrl%>" required>
                    </div>
                </div>
                    
                    <div class="row mt-3 mb-3">
                        <div class="col-md-4">
                            <label for="propertyUser">Username</label>
                            <input type="text" class="form-control" id="propertyUser" name="propertiesUsername" placeholder="Bank Username" value="<%=bankUsername%>" required>
                        </div>
                        <div class="col-md-4">
                            <label for="propertyPass">Password</label>
                            <input type="password" class="form-control" id="propertyPass" name="propertiesPassword" placeholder="Bank Password" required>
                        </div>
                        <div class="col-md-4">
                            <label for="propertyCard">Card Number</label>
                            <input type="text" class="form-control" id="propertyCard" name="propertiesCard" placeholder="Bank Card" pattern="[0-9]{16}" value="<%=bankCardNo%>" required>
                        </div>
                    </div>
                
                <div class="row">
                    <div class="col text-center">
                        <button class="btn btn-dark submitButton">Submit</button>
                    </div>
                </div>
            </form>
            
            <form id="refundForm" class="innerForm" method="post" autocomplete="off">
                <input type="hidden" name="action" value="doRefund">
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="refundCard">Card Number</label>
                        <input type="text" class="form-control" id="refundCard" name="cardNumber" placeholder="1111222233334444" pattern="[0-9]{16}" required>
                    </div>
                    <div class="col-md-6">
                        <label for="refundAmount">Refund amount</label>
                        <input type="text" class="form-control" id="refundAmount" name="amount" placeholder="£0.00" pattern="[0-9]*\.?[0-9]*" required>
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
    
        <div id="functionContainer">
            <div class="functionButton" id="buttonProperties">
                <p>Properties Controller</p>
            </div>

            <div class="functionButton" id="buttonRefund">
                <p>Refund to Card</p>
            </div>
        </div>
<% } %>

<% if (loggedIn) { %>
<jsp:include page="footeradmin.jsp"/>
<% } else { %>
<jsp:include page="footeradminmin.jsp"/>
<% } %>