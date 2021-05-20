package agh.cs.lab1;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int CategoryId;
    private String name;

    public Category(String name) {
        this.name = name;
    }
    public Category(){}

    public String getName() {
        return name;
    }
    public void setProducts(HashSet<Product> products) {
        Products = products;
    }

    public Set<Product> getProducts() {
        return Products;
    }
    @OneToMany(cascade = CascadeType.PERSIST)
    private Set<Product> Products = new HashSet<Product>();
    public void addProduct(Product p){
        this.Products.add(p);
    }
}
