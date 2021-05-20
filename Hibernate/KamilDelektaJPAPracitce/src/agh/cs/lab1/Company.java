package agh.cs.lab1;

import javax.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public class Company {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int CompanyId;
    private String CompanyName;
    private String Street;
    private String City;
    private String ZipCode;

    public Company(){};

    public Company(String companyName, String city, String street, String zipCode){
        this.CompanyName = companyName;
        this.City = city;
        this.Street = street;
        this.ZipCode = zipCode;
    }
}
