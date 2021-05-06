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
        Supplier supplier = new Supplier("Koral", "Słodka", "Nowy Sącz");
        Product product1 = new Product("Lody Ekipy", 100);
        Product product2 = new Product("Big Milk", 10);
        Product product3 = new Product("Grand", 50);
//        Set<Product> products = new Set<Product>(product1, product2, product3) {
        supplier.addProducts(product1);
        supplier.addProducts(product2);
        supplier.addProducts(product3);


        try {
            Transaction tx = session.beginTransaction();
//            Product foundProduct = session.get(Product.class, 3);
//            session.remove(foundProduct);
            session.save(product1);
            session.save(product2);
            session.save(product3);
            session.save(supplier);
            tx.commit();
        } finally {
            session.close();
        }
    }
}