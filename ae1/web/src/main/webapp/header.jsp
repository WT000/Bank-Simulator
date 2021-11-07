<%-- 
    Document   : header
    Created on : 30 Oct 2021, 16:43:28
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
    // Create / load (if already created) the properties file
    PropertiesDao adminSettings = WebObjectFactory.getPropertiesDao();
    
    // Get the current properties from the file
    String bankUrl = adminSettings.getProperty("org.solent.oodd.ae1.web.url");
    String bankCard = adminSettings.getProperty("org.solent.oodd.ae1.web.cardNumber");
    String bankCardName = adminSettings.getProperty("org.solent.oodd.ae1.web.cardName");
    String bankCardDate = adminSettings.getProperty("org.solent.oodd.ae1.web.cardDate");
    String bankCardCvv = adminSettings.getProperty("org.solent.oodd.ae1.web.cardCvv");
    String bankUsername = adminSettings.getProperty("org.solent.oodd.ae1.web.username");
    String bankPassword = adminSettings.getProperty("org.solent.oodd.ae1.web.password");
    
    // If the action is to set new properties, get the relevant strings and set them to the relevant keys
    String propertiesAction = (String) request.getParameter("action");
    boolean setProperties = false;
    boolean propertiesFail = false;
    String propertiesFailMessage = "";
    
    if ("setProperties".equals(propertiesAction)) {
        bankUrl = (String) request.getParameter("propertiesURL");
        bankCard = (String) request.getParameter("propertiesCard");
        bankCardName = (String) request.getParameter("propertiesCardName");
        bankCardDate = (String) request.getParameter("propertiesCardDate");
        bankCardCvv = (String) request.getParameter("propertiesCardCvv");
        bankUsername = (String) request.getParameter("propertiesUsername");
        bankPassword = (String) request.getParameter("propertiesPassword");
        
        CardValidationResult cardResult = RegexCardValidator.isValid(bankCard);
        
        // The result was valid, so next we'll test the new properties through a ReST transfer
        if (cardResult.isValid()) {
            BankRestClientImpl propertiesRestClient = new BankRestClientImpl(bankUrl);
            CreditCard propertiesCard = new CreditCard(bankCard, bankCardName, bankCardDate, bankCardCvv);
            
            try {
                TransactionReplyMessage propertiesResponse = propertiesRestClient.transferMoney(propertiesCard, propertiesCard, 0.00, bankUsername, bankPassword);
                
                if (propertiesResponse.getStatus() == BankTransactionStatus.SUCCESS) {
                    adminSettings.setProperty("org.solent.oodd.ae1.web.url", bankUrl);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.cardNumber", bankCard);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.cardName", bankCardName);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.cardDate", bankCardDate);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.cardCvv", bankCardCvv);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.username", bankUsername);
                    adminSettings.setProperty("org.solent.oodd.ae1.web.password", bankPassword);
                    setProperties = true;
                } else {
                    propertiesFail = true;
                    propertiesFailMessage = "Invalid login.";
                }
            } catch (Exception e) {
                propertiesFail = true;
                propertiesFailMessage = "The URL isn't valid: " + e.toString();
            }
        } else {
            propertiesFail = true;
            propertiesFailMessage = "The card isn't valid.";
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Online Sale Service</title>
        <!-- Bootstrap -->
        <link rel="stylesheet" href="public/styles/bootstrap.min.css">

        <!-- Custom stylesheet -->
        <link rel="stylesheet" href="public/styles/style.css">
    </head>
    <body>
        <!-- Header start -->
        <% if (propertiesFail) { %>
            <script>alert("The entered properties are incorrect, rejecting changes. Reason: <%=propertiesFailMessage%>")</script>
        <% } else if (setProperties) { %>
            <script>alert("The new properties were succesfully set. Please remember to enter the bank password again if the system goes offline.")</script>
        <% } %>
        
        <div id="adminMenu">
            <div id="adminMenuHeader">
                <h2>OWNER MENU</h2>
            </div>

            <form id="propertiesForm" method="post" autocomplete="off">
                <input type="hidden" name="action" value="setProperties">
                <div class="propertiesFormRow">
                    <label>Bank URL</label><input type="url" name="propertiesURL" placeholder="Bank URL" value="<%=bankUrl%>" required>
                </div>
                
                <div class="propertiesFormRow">
                    <label>Bank User</label><input type="text" name="propertiesUsername" placeholder="Bank Username" value="<%=bankUsername%>" required>
                    <label>Bank Password</label><input type="password" name="propertiesPassword" placeholder="Bank Password" required>
                    <label>Bank Card</label><input type="text" name="propertiesCard" placeholder="Bank Card" pattern="[0-9]{16}" value="<%=bankCard%>" required>
                    <label>Name on card</label><input type="text" name="propertiesCardName" placeholder="(optional)" value="<%=bankCardName%>">
                    <label>Card End Date</label><input type="text" name="propertiesCardDate" placeholder="(optional)" value="<%=bankCardDate%>">
                    <label>Card Cvv</label><input type="text" name="propertiesCardCvv" placeholder="(optional)" value="<%=bankCardCvv%>">
                </div>

                <div class="propertiesFormRow">
                    <button>Submit</button>
                </div>
            </form>
        </div>
        <!-- Header end -->
