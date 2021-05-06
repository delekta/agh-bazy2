package agh.cs.lab1;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int SupplierId;
    private String CompanyName;
    private String Street;
    private String City;

    @OneToMany
    private Set<Product> SuppliedProducts = new HashSet<Product>();

    public Set<Product> getSuppliedProducts() {
        return SuppliedProducts;
    }

    public void addProducts(Product product){
        this.SuppliedProducts.add(product);
    }

    public void setCompanyName(String companyName) {
        CompanyName = companyName;
    }

    public void setStreet(String street) {
        Street = street;
    }

    public void setCity(String city) {
        City = city;
    }

    public String getCompanyName() {
        return CompanyName;
    }

    public String getStreet() {
        return Street;
    }

    public String getCity() {
        return City;
    }

    public Supplier(){};

    public Supplier(String companyName, String street, String city){
        this.CompanyName = companyName;
        this.Street = street;
        this.City = city;
    }
}

