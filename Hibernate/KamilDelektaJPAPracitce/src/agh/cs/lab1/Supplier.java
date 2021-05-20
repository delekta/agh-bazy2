package agh.cs.lab1;

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
//@SecondaryTable(name = "ADDRESS")
public class Supplier extends Company implements Serializable {
    private String BankAccountNumber;

    public String getBankAccountNumber() {
        return BankAccountNumber;
    }

    @OneToMany(cascade = CascadeType.PERSIST)
    private Set<Product> SuppliedProducts = new HashSet<Product>();

    public Set<Product> getSuppliedProducts() {
        return SuppliedProducts;
    }

    public void addProducts(Product product){
        this.SuppliedProducts.add(product);
    }

    public Supplier(){};

    public Supplier(String companyName, String street, String city, String zipCode, String bankAccountNumber){
        super(companyName, city, street, zipCode);
        this.BankAccountNumber = bankAccountNumber;
    }
}

