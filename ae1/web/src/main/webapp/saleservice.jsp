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
        <form id="addCardForm" class="innerForm" method="post">
            <input type="hidden" name="action" value="addCard">
            
            <label>Card Number</label><input type="number" name="cardNumber"><br>
            <label>Name on Card</label><input name="cardName"><br>
            <label>Expiration Date</label><input type="number" name="cardDate"><br>
            <label>Cvv</label><input type="number" name="cardCvv"><br>
            <button>Submit</button>
        </form>
        
        <form id="transactionForm" class="innerForm" method="post">
            <input type="hidden" name="action" value="doTransaction">
            
            <label>Amount to send</label><input type="number" name="amount"><br>
            <button>Submit</button>
        </form>
        
        <form id="refundForm" class="innerForm" method="post">
            <input type="hidden" name="action" value="doRefund">
            
            <label>Amount to refund</label><input type="number" name="amount"><br>
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
        
        <div class="functionButton" id="buttonRefund">
            <p>Refund</p>
        </div>
    </div>
</div>
<!-- Page end -->
<jsp:include page="footer.jsp"/>