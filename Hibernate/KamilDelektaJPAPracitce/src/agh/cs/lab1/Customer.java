package agh.cs.lab1;

import javax.persistence.Entity;
import java.io.Serializable;

@Entity
public class Customer extends Company implements Serializable {
    private int Discount;

    public Customer(){};

    public Customer(String companyName, String city, String street, String zipCode, int discount){
        super(companyName, city, street, zipCode);
        this.Discount = discount;
    }
}
