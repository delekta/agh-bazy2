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
    test(db);
    countFiveStarDocuments(db);
    numberOfRestaurantsInCities(db);
    numberOfHotelsWithSpecificRequirments(db);

    // zad 7
    theManWithTheMostPositives(db);
    // console.log(`MongoDB Connected: ${url}`);
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

function countFiveStarDocuments(db){
    const reviewCollection = db.collection('review');
    reviewCollection.countDocuments({ stars: {$eq: 5}})
    .then((result, err) => {
        if (err) {
            return console.log(err);
        }
        console.log("Number of doucments with five stars: " + result);
    }
); 
}

function numberOfRestaurantsInCities(db){
    const businessCollection = db.collection('business');
    businessCollection.aggregate(
        [{ $match: { categories: "Restaurants" } },
         { $group: { _id: "$city", count: { $sum: 1 } } }]
        ).toArray((err, results) => {
            if (err) throw err;
            for(res of results){
                console.log("Restaurant: " + res._id + " | Count: " + res.count);
            }
        });
}

function numberOfHotelsWithSpecificRequirments(db){
    const businessCollection = db.collection('business');
    businessCollection.aggregate(
        [
            { $match: {
                categories: "Hotels & Travel" ,
                attributes: {'Wi-Fi':'free'},
                stars:{ $gte: 4.5}
                      }
            },
            { $group: { _id: "$state", count: { $sum: 1 } } }
         ]
        ).toArray((err, results) => {
            if (err) throw err;
            for(res of results){
                console.log("State: " + res._id + " | Count: " + res.count);
            }
        });
}

function theManWithTheMostPositives(db){
    const businessCollection = db.collection('review');
    businessCollection.aggregate(
        [{ $match: {
                    stars:{ $gte: 4.5}
                   }
         },
        { $group: { 
                    _id: "$user_id", count: { $sum: 1 } 
                  } }]
        ).toArray((err, results) => {
            if (err) throw err;
            // var max = 0;
            // for(res of results){
            //     console.log("User ID: " + res._id + " | Count: " + res.count);
            //     if(res.count > max){
            //         max = res.count;
            //         console.log("Here I am !!!!!!!!!!!!!!!!")
            //     }
            // }
            // console.log("Max positive reviews: " + max)
            var manWithTheMostPositives = [...results].reduce((a, b) => a['count'] > b['count'] ? a : b);
            console.log("[The Man With Most Positives] User ID: " + manWithTheMostPositives._id + " |  Count:" + manWithTheMostPositives.count)

            // Searching For Name Of User With The Most Positive Revievs
            searched_user_id = manWithTheMostPositives._id
            const userCollection = db.collection("user");
            userCollection.findOne({
                user_id: searched_user_id
            }).then(
                (result, err) => {
                    if(err){
                        console.log(err);
                    }
                    console.log("Name: " + result.name);
                    console.log(result)
                }
            )
        });
}
