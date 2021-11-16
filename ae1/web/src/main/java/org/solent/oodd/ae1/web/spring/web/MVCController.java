/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.oodd.ae1.web.spring.web;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import org.solent.oodd.ae1.web.dao.properties.PropertiesDao;
import org.solent.oodd.ae1.web.dao.properties.WebObjectFactory;
import org.solent.oodd.ae1.card.checker.RegexCardValidator;
import org.solent.oodd.ae1.card.checker.CardValidationResult;
import org.solent.oodd.ae1.bank.client.impl.BankRestClientImpl;
import org.solent.oodd.ae1.bank.model.dto.TransactionReplyMessage;
import org.solent.oodd.ae1.bank.model.dto.BankTransactionStatus;
import org.solent.oodd.ae1.bank.model.dto.CreditCard;
import org.solent.oodd.ae1.password.PasswordUtils;

/**
 *
 * @author Will
 */
@Controller
@RequestMapping("/")
public class MVCController {
    private final PropertiesDao adminSettings = WebObjectFactory.getPropertiesDao();
    
    
    @RequestMapping(value = "/", method = {RequestMethod.GET, RequestMethod.POST})
    public String index(Model model) {
        return "redirect:/index.html";
    }

    // Call the sale service page
    @RequestMapping(value = "/saleservice", method = {RequestMethod.GET, RequestMethod.POST})
    public String saleservice(Model model, HttpSession session,
                              @RequestParam(name = "action", required = false) String action,
                              @RequestParam(name = "cardNumber", required = false) String cardNo,
                              @RequestParam(name = "cardName", required = false) String cardName,
                              @RequestParam(name = "cardDate", required = false) String cardDate,
                              @RequestParam(name = "cardCvv", required = false) String cardCvv,
                              @RequestParam(name = "amount", required = false) String amount) {
        // Set loggedIn to false whenever this page is gone to
        session.setAttribute("loggedIn", false);
        
        // Create a new rest client and get admin bank account details (as they may have changed)
        BankRestClientImpl restClient = new BankRestClientImpl(adminSettings.getProperty("org.solent.oodd.ae1.web.url"));
        String bankCardNo = adminSettings.getProperty("org.solent.oodd.ae1.web.cardNumber");
        String bankCardName = adminSettings.getProperty("org.solent.oodd.ae1.web.cardName");
        String bankDate = adminSettings.getProperty("org.solent.oodd.ae1.web.cardDate");
        String bankCvv = adminSettings.getProperty("org.solent.oodd.ae1.web.cardCvv");
        CreditCard bankCard = new CreditCard(bankCardNo, bankCardName, bankDate, bankCvv);

        // Get the current username and password for admin
        String bankUser = adminSettings.getProperty("org.solent.oodd.ae1.web.username");
        String bankPass = adminSettings.getProperty("org.solent.oodd.ae1.web.password");

        String result = "<p id=\"resultText\"> Please enter your details and an amount to send below.</p>";

        // Action from form determines what's done, happens after form is submitted
        // doTransaction - money is being sent to the admin from a customer
        if ("doTransaction".equals(action)) {
            
            // Ensure the entered amount is a valid double
            boolean error = false;
            try {
                double numAmount = Double.parseDouble(amount);
            } catch (Exception e) {
                error = true;
            }
            
            // Validate the card, set its details if it's valid
            CreditCard customerCard = new CreditCard();
            CardValidationResult cardResult = RegexCardValidator.isValid(cardNo);

            if (cardResult.isValid()) {
                customerCard.setEndDate(cardDate);
                if (!customerCard.cardDateExpiredOrError()) {
                    customerCard.setCardnumber(cardNo);
                    customerCard.setName(cardName);
                    customerCard.setCvv(cardCvv);
                } else {
                    result = "<p id=\"resultText\" style=\"color:red;\">ERROR - Your card has expired.</p>";
                    error = true;
                }
            } else {
                result = "<p id=\"resultText\" style=\"color:red;\">ERROR - " + cardResult.getError() + ".</p>";
                error = true;
            }
            
            // Only continue with the transaction if no errors have happened
            if (!error) {
                try {
                    // Try sending the transaction to the admin card, doing auth using their username and password
                    TransactionReplyMessage restResponse = restClient.transferMoney(customerCard, bankCard, Double.valueOf(amount), bankUser, bankPass);

                    // Check whether the transaction was successful or not
                    if (restResponse.getStatus() == BankTransactionStatus.SUCCESS) {
                        result = "<p id=\"resultText\" style=\"color:green;\">SUCCESS - £" + amount + " has been taken from your account.</p>";
                    } else {
                        // null isn't a helpful message if the bank properties haven't been correctly configured.
                        if (restResponse.getMessage() != null) {
                            result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - " + restResponse.getMessage() + ".</p>";
                        } else {
                            result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - couldn't perform transactional operations, please ensure your card is added to an account.</p>";
                        }
                    }
                // An exception could happen during the transfer, catch it here
                } catch (Exception e) {
                    result = "<p id=\"resultText\" style=\"color:red;\">FAILURE - couldn't perform transactional operations on the currently configured bank.</p>";
                }
            }
        }
        
        // Return the page and result
        model.addAttribute("result", result);
        return "saleservice";
    }

    // Call the admin page
    @RequestMapping(value = "/admin", method = {RequestMethod.GET, RequestMethod.POST})
    public String admin(Model model, HttpSession session,
                        @RequestParam(name = "action", required = false) String action,
                        @RequestParam(name = "propertiesUsername", required = false) String enteredUsername,
                        @RequestParam(name = "propertiesPassword", required = false) String enteredPassword,
                        @RequestParam(name = "propertiesURL", required = false) String enteredBankUrl,
                        @RequestParam(name = "propertiesCard", required = false) String enteredBankCardNo,
                        @RequestParam(name = "cardNumber", required = false) String cardNumber,
                        @RequestParam(name = "amount", required = false) String amount) {
        
        // Get the most recent bank information
        String bankUrl = adminSettings.getProperty("org.solent.oodd.ae1.web.url");
        String bankCardNo = adminSettings.getProperty("org.solent.oodd.ae1.web.cardNumber");
        String bankHashedPassword = adminSettings.getProperty("org.solent.oodd.ae1.web.hashedPassword");
        BankRestClientImpl restClient = new BankRestClientImpl(adminSettings.getProperty("org.solent.oodd.ae1.web.url"));
        CreditCard bankCard = new CreditCard(bankCardNo);
        
        // Get the actual username and password, we'll check these later in case a properties file doesn't exist
        String bankUsername = adminSettings.getProperty("org.solent.oodd.ae1.web.username");
        String bankPassword = adminSettings.getProperty("org.solent.oodd.ae1.web.password");
        
        // if loggedIn doesn't exist, make it false
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        if (loggedIn == null) {
            loggedIn = false;
            session.setAttribute("loggedIn", false);
        }
        
        // If there's currently no account configured, allow auto-login
        if (bankUsername.equals("") || bankPassword.equals("")) {
            loggedIn = true;
        }
        
        String result = "<p id=\"resultText\"> Admin Control Panel </p>";
        
        // If attempting to login, simply check the entered username and password against the stored username and hashed password
        if ("adminLogin".equals(action)) {
            if (PasswordUtils.checkPassword(enteredPassword, bankHashedPassword) && enteredUsername.equals(bankUsername)) {
                loggedIn = true;
                session.setAttribute("loggedIn", true);
                result = "<p id=\"resultText\" style=\"color:green;\"> SUCCESS - This session will expire when you return to the sale service. </p>";
            } else {
                result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - The account details are incorrect, you may want to check the properties file. </p>";
            }
        // If setting properties, we need to validate the card and then send a spoof transaction to the new URL
        } else if ("setProperties".equals(action)) {
            CardValidationResult cardResult = RegexCardValidator.isValid(enteredBankCardNo);

            if (cardResult.isValid()) {
                BankRestClientImpl propertiesRestClient = new BankRestClientImpl(enteredBankUrl);
                CreditCard propertiesCard = new CreditCard(enteredBankCardNo, "", "", "");

                try {
                    // (spoof transaction here)
                    TransactionReplyMessage propertiesResponse = propertiesRestClient.transferMoney(propertiesCard, propertiesCard, 0.00, enteredUsername, enteredPassword);
                    
                    // If it worked, the new properties can be set
                    if (propertiesResponse.getStatus() == BankTransactionStatus.SUCCESS) {
                        adminSettings.setProperty("org.solent.oodd.ae1.web.url", enteredBankUrl);
                        adminSettings.setProperty("org.solent.oodd.ae1.web.username", enteredUsername);
                        adminSettings.setProperty("org.solent.oodd.ae1.web.password", enteredPassword);
                        adminSettings.setProperty("org.solent.oodd.ae1.web.hashedPassword", PasswordUtils.hashPassword(enteredPassword));
                        adminSettings.setProperty("org.solent.oodd.ae1.web.cardNumber", enteredBankCardNo);
                        result = "<p id=\"resultText\" style=\"color:green;\"> SUCCESS - The new properties were saved. </p>";
                    // Else, reject the changes
                    } else {
                        result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - Invalid bank credentials, changes won't be saved. </p>";
                    }
                // Similarly to bank transactions, if an exception happens we need to catch it
                } catch (Exception e) {
                    result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - Something went wrong when setting properties: " + e.getMessage() + "</p>";
                }
            } else {
                result = "<p id=\"resultText\" style=\"color:red;\"> ERROR - The card isn't valid, changes won't be saved. </p>";
            }
        // If doing a refund, we just do a transaction but from the admin card to the entered card, it follows a similar process but with other results
        } else if ("doRefund".equals(action)) {
            boolean error = false;
            try {
                double numAmount = Double.parseDouble(amount);
            } catch (Exception e) {
                error = true;
            }

            CardValidationResult cardResult = RegexCardValidator.isValid(cardNumber);
            CreditCard customerCard = new CreditCard();
            
            // Whilst some code is repeated, the process of making the refund card is different as we have less info to work with
            if (cardResult.isValid()) {
                customerCard.setCardnumber(cardNumber);
            } else {
                result = "<p id=\"resultText\" style=\"color:red;\">ERROR - " + cardResult.getError() + ".</p>";
                error = true;
            }
            
            // Similar rest transaction to doTransaction
            if (!error) {
                try {
                    TransactionReplyMessage restResponse = restClient.transferMoney(bankCard, customerCard, Double.valueOf(amount));

                    // Check whether the transaction is successful or not
                    if (restResponse.getStatus() == BankTransactionStatus.SUCCESS) {
                        result = "<p id=\"resultText\" style=\"color:green;\">SUCCESS - £" + amount + " has been refunded to " + cardNumber + ".</p>";
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

        model.addAttribute("result", result);
        model.addAttribute("loggedIn", loggedIn);
        model.addAttribute("bankUrl", bankUrl);
        model.addAttribute("bankUsername", bankUsername);
        model.addAttribute("bankCardNo", bankCardNo);
        
        return "admin";
    }

    // Error handling
    @ExceptionHandler(Exception.class)
    public String myExceptionHandler(final Exception e, Model model, HttpServletRequest request) {
        final StringWriter sw = new StringWriter();
        final PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);

        // Exception made into a String
        final String strStackTrace = sw.toString();
        String urlStr = "not defined";
        if (request != null) {
            StringBuffer url = request.getRequestURL();
            urlStr = url.toString();
        }

        model.addAttribute("requestUrl", urlStr);
        model.addAttribute("strStackTrace", strStackTrace);
        model.addAttribute("exception", e);

        // Return the user to an error page
        return "error"; // default friendly exception message for user
    }
}