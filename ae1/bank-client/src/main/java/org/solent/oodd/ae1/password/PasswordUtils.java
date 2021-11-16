/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.oodd.ae1.password;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Used to hash or compare strings to hashed
 * @author gallenc
 */
public class PasswordUtils {
    
    /**
     *
     * Performs hashing on a given password
     * @param password The password to hash
     * @return The hashed password
     */
    public static String hashPassword(String password){
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }
    
    /**
     *
     * Checks a hash against plain text
     * @param password The password to compare to
     * @param hashed The hashed password
     * @return A boolean which returns True if matching
     */
    public static boolean checkPassword(String password, String hashed){
        return BCrypt.checkpw(password, hashed);
    }
    
}
