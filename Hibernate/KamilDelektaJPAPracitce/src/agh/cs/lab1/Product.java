package agh.cs.lab1;

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
public class Product implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ProductId;
    private String ProductName;
    private int UnitsOnStock;

    public Category getCategory() {
        return Category;
    }

    @ManyToOne
    private Supplier Supplier;

    @ManyToOne
    private Category Category;

//    @ManyToMany(mappedBy = "Products") nie dziala
    @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Set<Invoice> Invoices = new LinkedHashSet<Invoice>();
    public void addInvoice(Invoice invoice){
        this.Invoices.add(invoice);
    }

    public void setCategory(Category category){
        this.Category = category;
    }

    public void setSupplier(Supplier supplier) {
        Supplier = supplier;
    }


    public String getProductName() {
        return ProductName;
    }

    public int getUnitsOnStock() {
        return UnitsOnStock;
    }

    public void setProductName(String productName) {
        ProductName = productName;
    }

    public void setUnitsOnStock(int unitsOnStock) {
        UnitsOnStock = unitsOnStock;
    }

    public Product(){}

    public Product(String name, int units){
        this.ProductName = name;
        this.UnitsOnStock = units;
//        this.Supplier = supplier;


    }
}

