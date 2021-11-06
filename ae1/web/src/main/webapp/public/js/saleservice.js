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
        if (currentForm !== null) {
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
        if (currentForm !== null) {
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
        if (currentForm !== null) {
            document.getElementById(currentForm).style.display = "none";
        };
        currentForm = "refundForm";
        document.getElementById(currentForm).style.display = "block";
    };
});

// Check addCard form
document.getElementById("addCardForm").addEventListener("submit", e => {
    e.preventDefault();
    let cardNo = document.forms["addCardForm"]["cardNumber"].value;
    let cardName = document.forms["addCardForm"]["cardName"].value;
    let cardDate = document.forms["addCardForm"]["cardDate"].value;
    let cardCvv = document.forms["addCardForm"]["cardCvv"].value;

    let foundError = false;
    
    if (cardNo.trim() == "" || cardNo.length !== 16 || isNaN(cardNo)) {
        foundError = true;
        document.forms["addCardForm"]["cardNumber"].style.backgroundColor = "red";
    } else {
        document.forms["addCardForm"]["cardNumber"].style.backgroundColor = "white";
    }

    if (cardName.trim() == "") {
        foundError = true;
        document.forms["addCardForm"]["cardName"].style.backgroundColor = "red";
    } else {
        document.forms["addCardForm"]["cardName"].style.backgroundColor = "white";
    }
    
    if (cardDate.trim() == "" || cardDate.length !== 5 || cardDate[2] !== "/") {
        foundError = true;
        document.forms["addCardForm"]["cardDate"].style.backgroundColor = "red";
    } else {
        document.forms["addCardForm"]["cardDate"].style.backgroundColor = "white";
    }

    if (cardCvv.trim() == "" || cardCvv.length !== 3 || isNaN(cardCvv)) {
        foundError = true;
        document.forms["addCardForm"]["cardCvv"].style.backgroundColor = "red";
    } else {
        document.forms["addCardForm"]["cardCvv"].style.backgroundColor = "white";
    }

    if (foundError) {
        document.getElementById("resultText").innerHTML = "ERROR: Please follow the guidance in the placeholders.";
        document.getElementById("resultText").style.color = "red";
    } else {
        document.getElementById("addCardForm").submit();
    };
});

// Check transaction form
document.getElementById("transactionForm").addEventListener("submit", e => {
    e.preventDefault();
    let amount = document.forms["transactionForm"]["amount"].value;

    let foundError = false;

    if (amount.trim() == "" || isNaN(amount)) {
        foundError = true;
        document.forms["transactionForm"]["amount"].style.backgroundColor = "red";
    } else {
        document.forms["transactionForm"]["amount"].style.backgroundColor = "white";
    }

    if (foundError) {
        document.getElementById("resultText").innerHTML = "ERROR: Please enter a valid number.";
        document.getElementById("resultText").style.color = "red";
    } else {
        document.getElementById("transactionForm").submit();
    };
});