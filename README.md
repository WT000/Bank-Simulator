# COM528AE1 - GROUP A5

This is our groups submission for the AE1 for COM528, a credit card app that uses ReST with a front-facing UI built with JSP for users.

ae1 contains code and resources related to our project.

# APPLICATION SETUP

Firstly, ensure that you've got [Java JDK 8](https://www.oracle.com/java/technologies/downloads/#java8) or newer installed on your system. You'll also need [Apache Maven](https://maven.apache.org/download.cgi) to ensure the application can build its dependencies and function correctly.

Once installed, navigate to the parent folder (ae1) and run:
```
mvn clean install
```

You can now deploy the web application using Tomcat! Furthermore, you could navigate to the web directory and run:
```
mvn cargo:run
```

After doing one of these, navigate to http://localhost:8080/web/ for credits and a gateway to the running app! I recommend using a browser which supports JavaScript. 

# DOCUMENTATION

- Click [here](https://github.com/WT000/COM528AE1/blob/main/ae1/documentation/appDesign.md) to see documentation for the app.
- Click [here](https://github.com/WT000/COM528AE1/blob/main/ae1/documentation/appTestPlan.md) to see tests against the requirements / use cases.
