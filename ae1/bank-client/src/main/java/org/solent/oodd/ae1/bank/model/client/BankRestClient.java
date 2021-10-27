package org.solent.oodd.ae1.bank.model.client;

import org.solent.oodd.ae1.bank.model.dto.CreditCard;
import org.solent.oodd.ae1.bank.model.dto.TransactionReplyMessage;

public interface BankRestClient {

    public  TransactionReplyMessage transferMoney(CreditCard fromCard, CreditCard toCard, Double amount);

    public  TransactionReplyMessage transferMoney(CreditCard fromCard, CreditCard toCard, Double amount, String userName, String password);
}
