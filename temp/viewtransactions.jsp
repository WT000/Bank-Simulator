<%-- 
    Document   : viewtransactions
    Created on : 18 Oct 2021, 14:16:47
    Author     : Will
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sales App - Transactions</title>
    </head>
    <body>
        <h1>Transactions page</h1>
        <p>This page will simply display all the transactions that are sent to the owners account.</p>
        <p>It could do this by storing transaction id's and transaction amounts in session objects and displaying them here, clicking the refund button would check if the transaction Id still exists in the list, if it does then ReST the associated balance.</p>
        <p>We'd want to check if the Id exists before doing the refund as we don't want someone to keep refreshing the page and giving themselves more money!</p>
        <p>Each transaction could also have a refund button next to it, if clicked it removes it from transactions and refunds the money to the associated card.</p>
        <a href="./home.jsp">Home</a>
    </body>
</html>
