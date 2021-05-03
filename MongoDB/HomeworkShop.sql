use shop
db.customer.insertOne({
    _id: ObjectId(),
    name: "Jakub",
    address: {
        country: "Polska",
        city: "Rzeszów",
        street: "Zablocie"
    },
    orders: []
})

db.customer.drop()

db.customer.updateOne(
    {_id: ObjectId("609006432e80a414e5505e5d")},
    {$set: {orders: [
    {orderId: "609008272e80a414e5505e62"},
    ]}}
    )

db.order.insertOne({
    _id: ObjectId(),
    customer_id: "609006432e80a414e5505e5d",
    order_date: new Date,
    items: [
    {item_id: 3,
    amount: 10},
    ]
})

db.item.insertOne({
    _id: ObjectId(),
    name: "Tosty",
    price: 8
})