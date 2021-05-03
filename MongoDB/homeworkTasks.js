// create the client class
const MongoClient = require("mongodb").MongoClient;

const url = "mongodb://localhost:27017";
MongoClient.connect(url, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}, (err, client) => {
    if (err) {
        return console.log(err);
    }

    const db = client.db('KamilDelekta3');
    // test(db);
    // zad6a(db);
    // zad6b(db);
    // zad6c(db);
    // zad6d(db);
    zad6e(db);
    // client.close()
});

function test(db){
    const studentCollection = db.collection('student');
    studentCollection.find({}).toArray((err, result) => {
        if (err) throw err;
        for(student of result){
            console.log("Test:" + student.name);
        }
        
      });
}

function zad6a(db){
    const businessCollection = db.collection('business');
    businessCollection.find({open: false})
    .toArray((err, res) => {
        if (err) throw err;
        for(business of res){
            console.log("----")
            console.log(`Open: ${business.open}, Name: ${business.name}`)
            console.log(`Address: ${business.full_address}, Stars: ${business.stars}`)
            console.log("----")
        }
    })
}

function zad6b(db){
    const userCollection = db.collection('user');
    userCollection.find(
        {
            $and: [
            {"votes.funny": 0},
            {"votes.useful": 0},
            ]
        }
    ).sort({'name': 1})
    .toArray((err, res) => {
        if (err) throw err;
        for(user of res){
            console.log("----")
            console.log(`Name: ${user.name}, Votes: f: ${user.votes.funny}, u: ${user.votes.useful}, c: ${user.votes.cool}`)
            console.log("----")
        }
    })
}

function zad6c(db){
    const tipCollection = db.collection('tip');
    tipCollection.aggregate([
        {$match : {"date": /.*2012.*/}},
        {$group:{
            _id: "$business_id",
            count: {$sum: 1}}},
        {$sort: {count: 1}}
        ]).toArray((err, results) => {
            if (err) throw err;
            for(business of results){
                console.log(`Business: ${business._id} | Count: ${business.count}`);
            }
        });
}

function zad6d(db){
    const reviewCollection = db.collection('review');
    reviewCollection.aggregate
    ([{$group: {
            _id: "$business_id",
            avgStars: {$avg: "$stars"}}},
    {$lookup: {
            from: "business",
            localField: "_id",
            foreignField: "business_id",
            as: "business_vals"}},
    {$unwind: "$business_vals"},
    {$project:
        {
            "name": "$business_vals.name",
            "avgStars": "$avgStars"
        }},
    {$match: {avgStars: {$gte: 4}}},
    {   // I take only 500 documents to speed up calculations
        $limit: 500}
    ]).toArray((err, results) => {
            if (err) throw err;
            for(business of results){
                console.log(`Business: ${business.name} | Average Stars: ${business.avgStars}`);
            }
        });
}

function zad6e(db){
    let stars = 1.0
    db.collection("business").deleteMany({"stars": {$eq: stars}}, function(err, obj) {
        if (err) throw err;
        console.log(obj.result.n + ` ${stars}'th stars document(s) deleted`);
      });
}

var mapFunction1 = function() {
    //   var sum = db.tip.countDocuments({business_id: this.business_id})
       emit(this.business_id, 1);
    };
    
    var reduceFunction1 = function(id, values) {
       return Array.sum(values);
    };
    
    var finalizeFunction1 = function(key, sum){
        var len = 0;
        unique.forEach(
            function(doc){
            len += 1
            }
        )
        return sum / len
    };
    
    // testing
    var unique = db.business.aggregate([
       { $group: { _id: "$city", count: { $sum: 1 } } }
        ]);
    var len = 0;
    unique.forEach(
        function(doc){
        len += 1
        }
    )
    len
    
    db.tip.mapReduce(
        function(){emit(this.business_id, 1);},
        reduceFucntion1,
        {
            out: "Tips per business average",
            finalize: finzalizeFunction1
        }
    )