package agh.cs.lab1;

import javax.persistence.*;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ProductId;
    private String ProductName;
    private int UnitsOnStock;

//    public void setSupplier(agh.cs.lab1.Supplier supplier) {
//        Supplier = supplier;
//    }

//    @ManyToOne
//    private Supplier Supplier;

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

