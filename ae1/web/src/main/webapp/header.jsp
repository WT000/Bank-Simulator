<%-- 
    Document   : header
    Created on : 30 Oct 2021, 16:43:28
    Author     : Will
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.solent.oodd.ae1.web.dao.properties.PropertiesDao"%>
<%@page import="org.solent.oodd.ae1.web.dao.properties.WebObjectFactory"%>
<%
    // Create / load (if already created) the properties file
    PropertiesDao adminSettings = WebObjectFactory.getPropertiesDao();
    
    // Get the current properties from the file
    String bankUrl = adminSettings.getProperty("org.solent.oodd.ae1.web.url");
    String bankCard = adminSettings.getProperty("org.solent.oodd.ae1.web.cardNumber");
    String bankUsername = adminSettings.getProperty("org.solent.oodd.ae1.web.username");
    String bankPassword = adminSettings.getProperty("org.solent.oodd.ae1.web.password");
    
    // If the action is to set new properties, get the relevant strings and set them to the relevant keys
    String action = (String) request.getParameter("action");
    
    if ("setProperties".equals(action)) {
        bankUrl = (String) request.getParameter("propertiesURL");
        bankCard = (String) request.getParameter("Card Number");
        bankUsername = (String) request.getParameter("Bank Username");
        bankPassword = (String) request.getParameter("Bank Password");
        
        adminSettings.setProperty("org.solent.oodd.ae1.web.url", bankUrl);
        adminSettings.setProperty("org.solent.oodd.ae1.web.cardNumber", bankCard);
        adminSettings.setProperty("org.solent.oodd.ae1.web.username", bankUsername);
        adminSettings.setProperty("org.solent.oodd.ae1.web.password", bankPassword);
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
        <div id="adminMenu">
            <div id="adminMenuHeader">
                <h2>STAFF MENU</h2>
            </div>

            <form id="propertiesForm" method="post">
                <input type="hidden" name="action" value="setProperties">
                <div class="propertiesFormRow">
                    <label>Bank URL</label><input type="url" name="propertiesURL" placeholder="Bank URL" value="<%=bankUrl%>">
                    <label>Bank Card</label><input name="propertiesCard" placeholder="Card Number" value="<%=bankCard%>">
                    <label>Bank User</label><input name="propertiesUsername" placeholder="Bank Username" value="<%=bankUsername%>">
                    <label>Bank Password</label><input type="password" name="propertiesPassword" placeholder="Bank Password" value="<%=bankPassword%>">
                </div>

                <div class="propertiesFormRow">
                    <button>Submit</button>
                </div>
            </form>
        </div>
