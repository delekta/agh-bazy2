package agh.cs.lab1;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import java.lang.reflect.Array;
import java.util.*;

public class Main {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

    public static void main(final String[] args) throws Exception {
        final Session session = getSession();
//        Address address = new Address("Słodka", "Nowy Sącz", "34-123");
//        Supplier supplier = new Supplier("Koral", "Kwaśna", "Rzeszow", "12-345");

          Supplier supplier1 = new Supplier("Koral", "Zabłocie", "Rzeszów", "12-234", "123445678");
          Supplier supplier2 = new Supplier("Słodka Budka", "Kolorowa", "Rzeszów", "56-789", "9876543231");
          Customer customer1 = new Customer("Sklep u Bogdana", "Rzeszowska", "Rzeszów", "56-789", 7);
          Customer customer2 = new Customer("Pomaranczowa Budka", "Kolorowa", "Rzeszów", "56-789", 10);
//        Category category1 = new Category("Lody");
//        Category category2 = new Category("Batony");
//
//        Product product1 = new Product("Lody Ekipy", 100);
//        Product product2 = new Product("Big Milk", 10);
//        Product product3 = new Product("Snickers", 50);
//
//        product1.setCategory(category1);
//        product2.setCategory(category1);
//        product3.setCategory(category2);
//
//        category1.addProduct(product1);
//        category1.addProduct(product2);
//        category2.addProduct(product3);
//
//        product1.setSupplier(supplier);
//        product2.setSupplier(supplier);
//        product3.setSupplier(supplier);
//
//        supplier.addProducts(product1);
//        supplier.addProducts(product2);
//        supplier.addProducts(product3);
//
//        Invoice invoice1 = new Invoice();
//        Invoice invoice2 = new Invoice();
//
//        invoice1.addProducts(product1);
//        invoice1.addProducts(product2);
//        product1.addInvoice(invoice1);
//        product2.addInvoice(invoice1);
//
//        invoice2.addProducts(product2);
//        invoice2.addProducts(product3);
//        product2.addInvoice(invoice2);
//        product3.addInvoice(invoice2);

        try {
            Transaction tx = session.beginTransaction();
            session.persist(supplier1);
            session.persist(supplier2);
            session.persist(customer1);
            session.persist(customer2);
//            session.save(category1);
//            session.save(category2);
//            session.save(invoice1);
//            session.save(invoice2);
//            session.save(product1);
//            session.save(product2);
//            session.save(product3);
//            session.save(supplier);

//            Product product = session.get(Product.class, 5);
//            Category category = product.getCategory();
//            System.out.println("Product: " + product.getProductName()  + " Category: " + category.getName());

//            session.remove(foundProduct);
            tx.commit();
        } finally {
            session.close();
        }
    }
}