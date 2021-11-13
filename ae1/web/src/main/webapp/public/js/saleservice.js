/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

// Check addCard form
document.getElementById("addCardForm").addEventListener("submit", e => {
    e.preventDefault();
    let cardNo = document.forms["addCardForm"]["cardNumber"].value;
    let cardName = document.forms["addCardForm"]["cardName"].value;
    let cardDate = document.forms["addCardForm"]["cardDate"].value;
    let cardCvv = document.forms["addCardForm"]["cardCvv"].value;
    let amount = document.forms["addCardForm"]["amount"].value;

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
    
    if (amount.trim() == "" || isNaN(amount)) {
        foundError = true;
        document.forms["addCardForm"]["amount"].style.backgroundColor = "red";
    } else {
        document.forms["addCardForm"]["amount"].style.backgroundColor = "white";
    }

    if (foundError) {
        document.getElementById("resultText").innerHTML = "ERROR - Please follow the guidance in the placeholders.";
        document.getElementById("resultText").style.color = "red";
    } else {
        document.getElementById("addCardForm").submit();
    };
});