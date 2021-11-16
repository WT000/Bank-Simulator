package org.solent.oodd.ae1.bank.model.dto;

import javax.persistence.Embeddable;
import javax.persistence.Transient;
import org.solent.oodd.ae1.password.PasswordUtils;

/**
 * User object representation
 * @author Will
 */
@Embeddable
public class User {

    private String firstName = "";

    private String secondName = "";

    private String address = "";

    private String username = "";

    private String password = "";

    private String hashedPassword = "";

    /**
     *
     * @return First name
     */
    public String getFirstName() {
        return firstName;
    }

    /**
     *
     * @param firstName First name to set to
     */
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    /**
     *
     * @return Surname
     */
    public String getSecondName() {
        return secondName;
    }

    /**
     *
     * @param secondName Surname to set to
     */
    public void setSecondName(String secondName) {
        this.secondName = secondName;
    }

    /**
     *
     * @return Address
     */
    public String getAddress() {
        return address;
    }

    /**
     *
     * @param address Address to set to
     */
    public void setAddress(String address) {
        this.address = address;
    }

    /**
     *
     * @return Username
     */
    public String getUsername() {
        return username;
    }

    /**
     *
     * @param username Username to set to
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * Note that this is never saved anywhere
     * @return Plain text password
     */
    @Transient
    public String getPassword() {
        return password;
    }

    /**
     * Hashed password is stored in a database
     * @param password Password to set to
     */
    public void setPassword(String password) {
        this.password = password;
        setHashedPassword(PasswordUtils.hashPassword(password));
    }

    /**
     *
     * @return Hashed password
     */
    public String getHashedPassword() {
        return hashedPassword;
    }

    /**
     *
     * @param hashedPassword Hashed password to set to
     */
    public void setHashedPassword(String hashedPassword) {
        this.hashedPassword = hashedPassword;
    }

    // no password or hashed password
    @Override
    public String toString() {
        return "User{" + "firstName=" + firstName + ", secondName=" + secondName + ", address=" + address + ", username=" + username + '}';
    }

}
