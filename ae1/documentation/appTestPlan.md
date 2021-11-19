# TEST PLAN

Click [here](https://github.com/WT000/COM528AE1/blob/main/ae1/documentation/appDesign.md) to go back to the main documentation for the app.

A recap of the use cases:
- **UC1**: Admins must be able to log into a secure control panel
- **UC2**: Admins must be able to enter new properties / overwrite default properties
- **UC3**: Admins must be able to (after validation) refund to cards
- **UC4**: Users must be able to add their card details and (after validation) review their details
- **UC5**: Users must be able to submit the transaction, sending the amount to the REST URL
- **UC6**: The bank must be able to transfer money between the accounts during transactions and refunds

# TESTS

**Test Number**|**Use Case(s)**|**Test to Perform**|**Method**|**Result**
:-----:|:-----:|:-----:|:-----:|:-----:
1.1|UC1|Users must be able to log into the control panel with the correct details|Attempt to enter "testuser2" and "defaulttestpass" and see if it works|PASS
1.2|UC1|Users must be rejected when entering the wrong username or password|Attempt to enter invalid username and password combination|PASS
1.3|UC1|Users must skip the login page if properties values don't exist|Wipe the properties file (but not delete it as this would reform the default values) and attempt to go to the control panel|PASS
1.4|UC1|User login credentials must be wiped when returning to the saleapp|Go back to the saleapp page|PASS
2.1|UC2|Users must be able to submit valid properties|Attempt to change the properties to the testuser1 details|PASS
2.2|UC2|Users must not be able to set the properties to invalid values|Attempt to use an invalid URL, username, password and card number|PASS
2.3|UC2|Properties must be written to a file|Check the properties after setting them to see if they exist|PASS
3.1|UC3|Users must be able to refund to card|Attempt to refund £5 to 5133880000000012|PASS
3.2|UC3|Users must not be able to enter invalid cards - it shouldn't do the ReST refund|Attempt to enter an invalid card (1111222233334444) to stop the transfer early|PASS
4.1|UC4|Users must be able to add their card details|Attempt to use the virtual keypad and get to the submit screen at the end|PASS
4.2|UC4|Users must not be able to enter a card below or above 16 digits|Attempt to submit a card under 16 digits (going over is impossible with the system)|PASS
4.3|UC4|Users must only be able to enter dates in MM/YY or MM/YYYY format|Attempt to enter invalid dates|PASS
4.4|UC4|Users must only be able to enter a 3 digit length cvv|Attempt to enter invalid cvv's|PASS
4.5|UC4|Users must only be able to place one decimal place in the amount|Attempt to enter . more than once|PASS
4.6|UC4|Users must be able to cancel their transaction|Attempt to click the X button during the transaction process|PASS
5.1|UC5/6|Transactions must be sent to the appropriate ReST URL|Attempt to send a transaction using 5133880000000012 and view the transactions page|PASS
5.2|UC5/6|Refunds must be sent to the appropriate ReST URL|Attempt to refund the previous transaction|PASS
