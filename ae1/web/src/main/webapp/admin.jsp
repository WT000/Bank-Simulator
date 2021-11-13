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
    
    String result = "<p id=\"resultText\"> Welcome to the control panel. </p>";
    
    String action = (String) request.getParameter("action");
    if ("adminLogin".equals(action)) {
        String enteredUsername = (String) request.getParameter("propertiesUsername");
        String enteredPassword = (String) request.getParameter("propertiesPassword");
        
        // Check if the password equals the hashed password
        if (PasswordUtils.checkPassword(enteredPassword, bankHashedPassword) && enteredUsername.equals(bankUsername)) {
            loggedIn = true;
            session.setAttribute("loggedIn", true);
            result = "<p id=\"resultText\" style=\"color:green;\"> SUCCESS - You've now been logged in. </p>";
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
                    result = "<p id=\"resultText\" style=\"color:green;\"> SUCCESS - The properties were set. </p>";
                } else {
                    result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - Invalid bank credentials. </p>";
                }
            } catch (Exception e) {
                result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - Something went wrong when setting properties: " + e.getMessage() + "</p>";
            }
        } else {
            result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - The card isn't valid. </p>";
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
        <div id="adminContainer">
            <form id="loginForm" method="post" autocomplete="off">
                <input type="hidden" name="action" value="adminLogin">
                <label>--- Username ---</label><input type="text" name="propertiesUsername" placeholder="(blank if not set, or values in default properties)">
                <label>--- Password ---</label><input type="password" name="propertiesPassword" placeholder="(blank if not set, or values in default properties)">
                <button>Submit</button>
            </form>
        </div>
    <% } else if (loggedIn) { %>
        <div id="adminFormContainer">
            <form id="propertiesForm" class="innerForm" method="post" autocomplete="off">
                <input type="hidden" name="action" value="setProperties">
                <label>Bank URL</label><input type="url" name="propertiesURL" placeholder="Bank URL" value="<%=bankUrl%>" required><br>
                <label>Bank Username</label><input type="text" name="propertiesUsername" placeholder="Bank Username" value="<%=bankUsername%>" required><br>
                <label>Bank Password</label><input type="password" name="propertiesPassword" placeholder="Bank Password" required><br>
                <label>Bank Card</label><input type="text" name="propertiesCard" placeholder="Bank Card" pattern="[0-9]{16}" value="<%=bankCardNo%>" required><br>
                
                <button>Submit</button>
            </form>
            
            <form id="refundForm" class="innerForm" method="post" autocomplete="off">
                <input type="hidden" name="action" value="doRefund">
                <label>Card Number</label><input type="text" name="cardNumber" placeholder="1111222233334444" pattern="[0-9]{16}" required><br>
                <label>Amount to refund £</label><input type="text" name="amount" placeholder="0.00" required><br>
                <button>Submit</button>
            </form>
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
<jsp:include page="footeradmin.jsp"/>
