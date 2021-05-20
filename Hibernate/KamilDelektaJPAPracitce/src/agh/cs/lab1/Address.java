package agh.cs.lab1;

import javax.persistence.*;

@Embeddable
public class Address {
    private String Street;
    private String City;
    private String ZipCode;

    public Address(){ };
    public Address(String street, String city, String zipCode){
        this.Street = street;
        this.City = city;
        this.ZipCode = zipCode;
    }
}
