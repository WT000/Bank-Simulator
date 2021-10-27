/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.solent.oodd.ae1.card.checker;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Will
 */
public class RegexCardValidatorTest {
    
    public RegexCardValidatorTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of isValid method, of class RegexCardValidator.
     */
    @Test
    public void testIsValid() {
        System.out.println("isValid");
        String cardIn = "";
        CardValidationResult expResult = null;
        CardValidationResult result = RegexCardValidator.isValid(cardIn);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of luhnCheck method, of class RegexCardValidator.
     */
    @Test
    public void testLuhnCheck() {
        System.out.println("luhnCheck");
        String cardNumber = "";
        boolean expResult = false;
        boolean result = RegexCardValidator.luhnCheck(cardNumber);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
