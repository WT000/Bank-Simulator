<%-- 
    Document   : saleservice
    Created on : 27 Oct 2021, 20:46:37
    Author     : Will
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.solent.oodd.ae1.card.checker.RegexCardValidator"%>
<%@page import="org.solent.oodd.ae1.bank.client.impl.BankRestClientImpl"%>

<jsp:include page="header.jsp"/>
<!-- Page start -->
<div id="appContainer">
    <div id="resultContainer">
        <div id="result">
            <p id="resultText">Welcome. Please click one of the buttons below.</p>
        </div>
    </div>
    
    <div id="formContainer">
        
    </div>
    
    <div id="functionContainer">
        <div class="functionButton" id="buttonCard">
            <p>Enter Card</p>
        </div>
        
        <div class="functionButton" id="buttonTransaction">
            <p>Transaction</p>
        </div>
        
        <div class="functionButton" id="buttonRefund">
            <p>Refund</p>
        </div>
    </div>
</div>
<!-- Page end -->
<jsp:include page="footer.jsp"/>