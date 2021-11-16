## Contents
- **[APP DESIGN](#appDesign)**
- [Requirements and Planning](#requirements)
- [Use Cases](#usecases)
- [Initial Designs](#designs)
- **[FINISHED APP](#finished)**
- [List of features](#features)
- [Diagrams](#diagrams)
- [Javadoc](#javadoc)

# <a name="appDesign"></a> APP DESIGN

## <a name="requirements"></a> Requirements and Planning
This application is built to resemble a modern point of sale application, allowing users to enter their credit card details into a website and see a result depending on the information they put in. From knowing this, it allows us to split the program into a short list of simple requirements: 

- **Users must be able to enter credit card details**
- **Users must be able to enter an amount to send**
- **Users must be able to send that amount to the stored bank card, but only if the entered card exists on the bank service**

However, not just users will be operating on this application. Administrators (the owner of the point of sale application in this case) will need to be able to perform the following operations using the same service:

- **Update properties such as the remote bank URL, stored card and credentials**
- **Issue refunds to entered cards**

There will also be a few miscellaneous properties of the application that will allow for higher security and easier diagnosis of errors caused:

- **The system needs an appropriate amount of try / catch blocks and form validation to ensure it doesn't crash or use incorrect information**
- **The system needs an intuitive UI so users don't feel like they're using an outdated site**
- **The system should log transactions to a rolling file and console**

From these requirements, a set of development phases could be created and tasks could be picked by group members to complete. You can look at the [Projects](https://github.com/WT000/COM528AE1/projects) board for specific details on who did what, but in a nutshell:

| Github User | Phase 1                                                                                       | Phase 2                                          | Phase 3                                                                                |
|-------------|-----------------------------------------------------------------------------------------------|--------------------------------------------------|----------------------------------------------------------------------------------------|
| [Will](https://github.com/WT000)        | Developed designs for the site and implemented ReST, logging, properties, and error detection | Improved the design and secured the admin page   | Secured the admin page, wrote Javadoc and implemented SpringMVC                        |
| [Nastaran](https://github.com/nastaransharifisadr)    | Aided with design and tested CreditCard, ReST, Properties along with a test plan              | Created further documentation and tested classes | Finalised unit tests and designed the UML use cases, along with refining the test plan |
| [Hayri](https://github.com/hairicko21)       | Nothing                                                                                       | Nothing                                          | Nothing                                                                                |
| Benjamin (unknown github)    | Nothing                                                                                       | Nothing                                          | Nothing                                                                                |
  
## <a name="usecases"></a> Use Cases
The following are use cases for the application based on the previously identified requirements:

### Admin Actor
- **UC1**: Admins must be able to log into a secure control panel
- **UC2**: Admins must be able to enter new properties / overwrite default properties
- **UC3**: Admins must be able to (after validation) refund to cards

### User Actor
- **UC4**: Users must be able to add their card details
- **UC5**: Users must be able to (after validation) use their card details in a transaction against the configured remote bank URL

### Bank Actor
- **UC6**: The bank must be able to transfer money between accounts

![UML Diagram](https://github.com/WT000/GROUPA5AE1/blob/main/ae1/documentation/UML/use-case-v2.drawio.png "UML Diagram")

## <a name="designs"></a> Initial Designs
- initial design (screenshots of the images from the PowerPoint)

# <a name="finished"></a> FINISHED APP

## <a name="features"></a> List of finished features
- list of use cases and if they're completed, features and what requirements they solve, include other features at the end of the table
- link to the test plan

## <a name="diagrams"></a> Diagrams
- UML class / robustness diagrams

- images of final site

## <a name="javadoc"></a> Javadoc
For those who want a greater understanding of our program works, Javadoc has been used across the code to give details on how things are done. To view it, go to the ae1 parent folder and use ``` mvn javadoc:javadoc ```.
