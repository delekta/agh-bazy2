package agh.cs.lab1;
import org.hibernate.HibernateException;

import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import java.lang.reflect.Array;
import java.util.*;

public class JPA_Main {


    public static void main(final String[] args) throws Exception {
        final EntityManagerFactory emf = Persistence.createEntityManagerFactory("derby");
        EntityManager em = emf.createEntityManager();
        EntityTransaction etx = em.getTransaction();
        Address address = new Address("Słodka", "Nowy Sącz", "34-123");

        Supplier supplier = new Supplier("Koral", "Zabłocie", "Rzeszów", "12-234", "123445678");
        Supplier supplier2 = new Supplier("Słodka Budka", "Kolorowa", "Rzeszów", "56-789", "9876543231");
        Customer customer1 = new Customer("Sklep u Bogdana", "Rzeszowska", "Rzeszów", "56-789", 7);
        Customer customer2 = new Customer("Pomaranczowa Budka", "Kolorowa", "Rzeszów", "56-789", 10);

        Category category1 = new Category("Lody");
        Category category2 = new Category("Batony");

        Product product1 = new Product("Lody Ekipy", 100);
        Product product2 = new Product("Grand", 10);
        Product product3 = new Product("Snickers", 50);

        product1.setCategory(category1);
        product2.setCategory(category1);
        product3.setCategory(category2);

        category1.addProduct(product1);
        category1.addProduct(product2);
        category2.addProduct(product3);

        product1.setSupplier(supplier);
        product2.setSupplier(supplier);
        product3.setSupplier(supplier);

        supplier.addProducts(product1);
        supplier.addProducts(product2);
        supplier.addProducts(product3);

        Invoice invoice1 = new Invoice();
        Invoice invoice2 = new Invoice();

        invoice1.addProducts(product1);
        invoice1.addProducts(product2);
        product1.addInvoice(invoice1);
        product2.addInvoice(invoice1);

        invoice2.addProducts(product2);
        invoice2.addProducts(product3);
        product2.addInvoice(invoice2);
        product3.addInvoice(invoice2);

        try {
            etx.begin();
            em.persist(address);
            em.persist(category1);
            em.persist(category2);
            em.persist(invoice1);
            em.persist(invoice2);
            em.persist(product1);
            em.persist(product2);
            em.persist(product3);
            em.persist(supplier);

            etx.commit();
        } finally {
            em.close();
        }
    }
}