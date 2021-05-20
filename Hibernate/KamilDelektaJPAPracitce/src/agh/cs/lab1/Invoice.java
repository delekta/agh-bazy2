package agh.cs.lab1;

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
public class Invoice implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int InvoiceID;
    private int Quantity;

    public void Invoice(){}

    @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Set<Product> Products = new LinkedHashSet<Product>();
    public void addProducts(Product product){
        this.Products.add(product);
    }


}
