<%-- 
    Document   : header
    Created on : 30 Oct 2021, 16:43:28
    Author     : Will
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                    <input type="url" name="propertiesURL" placeholder="Bank URL">
                    <input name="propertiesCard" placeholder="Card Number">
                    <input name="propertiesUsername" placeholder="Bank Username">
                    <input type="password" name="propertiesPassword" placeholder="Bank Password">
                </div>

                <div class="propertiesFormRow">
                    <button>Submit</button>
                </div>
            </form>
        </div>
