package org.solent.oodd.ae1.bank.model.dto;

/**
 * Transaction request object representation
 * @author Will
 */
public class TransactionRequestMessage {

    private CreditCard fromCard;

    private CreditCard toCard;

    private Double amount;

    /**
     *
     * @return The from card
     */
    public CreditCard getFromCard() {
        return fromCard;
    }

    /**
     *
     * @param fromCard The from card to set to
     */
    public void setFromCard(CreditCard fromCard) {
        this.fromCard = fromCard;
    }

    /**
     *
     * @return The to card
     */
    public CreditCard getToCard() {
        return toCard;
    }

    /**
     *
     * @param toCard The to card to set to
     */
    public void setToCard(CreditCard toCard) {
        this.toCard = toCard;
    }

    /**
     *
     * @return The amount
     */
    public Double getAmount() {
        return amount;
    }

    /**
     *
     * @param amount The amount to set to
     */
    public void setAmount(Double amount) {
        this.amount = amount;
    }

    @Override
    public String toString() {
        return "TransactionRequestMessage{" + "fromCard=" + fromCard + ", toCard=" + toCard + ", amount=" + amount + '}';
    }
    
    
}
