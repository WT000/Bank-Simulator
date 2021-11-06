/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.oodd.ae1.web.dao.properties;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;
import java.util.Arrays;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
import org.solent.oodd.ae1.password.PasswordUtils;

/**
 *
 * @author cgallen
 */
public class PropertiesDao {

    final static Logger LOG = LogManager.getLogger(PropertiesDao.class);

    private File propertiesFile;

    private Properties properties = new Properties();
    
    private String storedPassword;

    public PropertiesDao(String propertiesFileLocation) {
        try {
            boolean firstLoad = false;
            propertiesFile = new File(propertiesFileLocation);
            
            if (!propertiesFile.exists()) {
                LOG.info("properties file does not exist: creating new file: " + propertiesFile.getAbsolutePath());
                propertiesFile.getParentFile().mkdirs();
                propertiesFile.createNewFile();
                saveProperties();
                firstLoad = true;
            } 
            loadProperties(firstLoad);
        } catch (IOException ex) {
            LOG.error("cannot load properties", ex);
        }
    }

    private String getStoredPassword() {
        return storedPassword;
    }
    
    // synchronized ensures changes are not made by another thread while reading
    public synchronized String getProperty(String propertyKey) {
        if (propertyKey.equals("org.solent.oodd.ae1.web.password")) {
            return storedPassword;
        }
        
        return properties.getProperty(propertyKey);
    }
    
    public synchronized void setProperty(String propertyKey, String propertyValue) {
        String propertyValueToStore = propertyValue;
        
        // Hash if it's a field that should be secured
        if (propertyKey.equals("org.solent.oodd.ae1.web.password")) {
            propertyValueToStore = PasswordUtils.hashPassword(propertyValue);
            storedPassword = propertyValue;
        }
        
        properties.setProperty(propertyKey, propertyValueToStore);
        saveProperties();
    }

    private void saveProperties() {
        OutputStream output = null;
        try {
            LOG.debug("saving properties to: " + propertiesFile.getAbsolutePath());

            output = new FileOutputStream(propertiesFile);
            String comments = "# saleapp settings file";
            properties.store(output, comments);

        } catch (IOException ex) {
            LOG.error("cannot save properties", ex);
        } finally {
            try {
                if (output != null) {
                    output.close();
                }
            } catch (IOException ex) {
            }
        }
    }

    private void loadProperties(boolean firstLoad) {
        InputStream input = null;
        try {
            // If the file hasn't been made, we need to get the data from the default file, load it into properties and save the file
            if (firstLoad) {
                LOG.info("loading default properties file...");
                input = PropertiesDao.class.getClassLoader().getResourceAsStream("application.properties");
                properties.load(input);
                saveProperties();
            // If it has been created, simply just load it 
            } else {
                LOG.debug("loading properties from: " + propertiesFile.getAbsolutePath());
                input = new FileInputStream(propertiesFile);
                properties.load(input);
            }
        } catch (IOException ex) {
            LOG.error("cannot load properties", ex);
        } finally {
            try {
                if (input != null) {
                    input.close();
                }
            } catch (IOException ex) {
            }
        }
    }

}
