/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

// Get the forms and make them invisible
const formContainer = document.getElementById("formContainer");
const forms = document.getElementsByClassName("innerForm");
let showingFormContainer = false;
let currentForm = null;

for (let i = 0; i < forms.length; i++) {
    forms[i].style.display = "none";
};

// Add Card Button
document.getElementById("buttonCard").addEventListener("click", e=> {
    // Display the form container if it's not showing
    if (!showingFormContainer) {
        formContainer.style.display = "block";
    };

    // Display the form
    if (currentForm != "addCardForm") {
        if (currentForm != null) {
            document.getElementById(currentForm).style.display = "none";
        };
        currentForm = "addCardForm";
        document.getElementById(currentForm).style.display = "block";
    };
});

// Transaction Button
document.getElementById("buttonTransaction").addEventListener("click", e=> {
    // Display the form container if it's not showing
    if (!showingFormContainer) {
        formContainer.style.display = "block";
    };

    // Display the form
    if (currentForm != "transactionForm") {
        if (currentForm != null) {
            document.getElementById(currentForm).style.display = "none";
        };
        currentForm = "transactionForm";
        document.getElementById(currentForm).style.display = "block";
    };
});

// Refund Button
document.getElementById("buttonRefund").addEventListener("click", e=> {
    // Display the form container if it's not showing
    if (!showingFormContainer) {
        formContainer.style.display = "block";
    };

    // Display the form
    if (currentForm != "refundForm") {
        if (currentForm != null) {
            document.getElementById(currentForm).style.display = "none";
        };
        currentForm = "refundForm";
        document.getElementById(currentForm).style.display = "block";
    };
});