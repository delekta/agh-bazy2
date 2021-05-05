package agh.cs.lab1;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ProductId;
    private String ProductName;
    private int UnitsOnStock;

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


    }
}

