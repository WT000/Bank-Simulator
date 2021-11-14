function clearResult() {
    document.getElementById("resultText").style.color = "black";
    document.getElementById("resultText").innerHTML = "Please enter your details and an amount to send below.";
};

// Get validMonths and append them to the list
let validMonths = [];

for (i=1; i<13; i++) {
    if (i<10) {
        validMonths.push(`0${i}`);
    } else {
        validMonths.push(`${i}`);
    }
};

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
    
    cardMonth = cardDate[0] + cardDate[1];
    if (cardDate.trim() == "" || cardDate.length !== 5 || cardDate[2] !== "/" || !(validMonths.includes(cardMonth))) {
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
    
    if (amount.trim() == "" || isNaN(amount) || parseFloat(amount) < 0.01) {
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

setTimeout(() => {  clearResult(); }, 8000);
