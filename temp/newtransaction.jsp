<%-- 
    Document   : newtransaction
    Created on : 18 Oct 2021, 14:16:38
    Author     : Will
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sale App - New Transaction</title>
    </head>
    <body>
        <h1>Transaction Page</h1>
        <p>Here there will simply be a field for the user to fill in their name and credit card details.</p>
        <p>This sends a ReST transaction, fromCard would be the users card and toCard is the owners card.</p>
        <p>This is sent to the hosted bank app, where we'll then display if the transaction was successful or not and log it to the properties file.</p>
        <p>Perhaps the Luhn code checker could be on this page too.</p>
        <a href="./home.jsp">Home</a>
    </body>
</html>
