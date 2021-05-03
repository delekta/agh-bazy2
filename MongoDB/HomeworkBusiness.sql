use KamilDelekta3
db.createCollection("student")

db.student.insert({
    name: "Jakub",
    surname: "Delekta",
    attendance: true,
    lab_mark: null,
    currDate: ISODate("2021-04-22T16:40:18.965Z"),
    completed_subjects: ["Handel", "EKonomia", "Zapasy"]
})

db.student.find({})

// Ile miejsc ocenionych na 5 gwiazdek
db.review.countDocuments({ stars: {$eq: 5}})

// Ile restauracji znajduje sie ̨w każdym mieście.(pole categories w
//dokumencie business musi zawierać wartość Restaurants).
//Do znalezienia wyniku użyj mechanizmu pipeline aggregation
// (http://docs.mongodb.org/manual/core/aggregation- pipeline/).

db.business.aggregate([
   { $match: { categories: "Restaurants" } },
   { $group: { _id: "$city", count: { $sum: 1 } } }
])


// Podaj Iiczbę hoteli (w atrybucie categories powinno być
// wymienione Hotels jako jedna z wartości) w każdym stanie/okręgu
//(state), które posiadają darmowe Wi-fi (w polu attributes powinna
// znaleźć się wartość ‘Wi-Fi’:’free’) oraz ocenę co najmniej 4.5 gwiazdki
//(pole stars).

db.business.aggregate([
   { $match: {
       categories: "Hotels & Travel" ,
       attributes: {'Wi-Fi':'free'},
       stars:{ $gte: 4.5}
             }
   },
   { $group: { _id: "$state", count: { $sum: 1 } } }
])

// sprawdzenie
db.business.aggregate([
   { $match: {
      categories: "Hotels & Travel" ,
      attributes: {'Wi-Fi':'free'},
             }
   },
   { $group: { _id: "$state", count: { $sum: 1 } } }
])

// Recenzje mogą być oceniane przez innych użytkowników jako cool, funny lub useful
//(jedna recenzja może mieć kilka głosów w każdej kategorii). Wykorzystaj
// mechanizmu map-reduce. (http://docs.mongodb.org/manual/core/map-reduce/)
//Napisz zapytanie, które zwraca dla każdej z tych kategorii, ile sumarycznie
// recenzji zostało oznaczonych przez te kategorie 5
//(recenzja ma kategorię funny jeśli co najmniej jedna osoba
//zagłosowała w ten sposób na daną recenzję).

// nie działa, ale ogólnie to map reduce to wielkie gówno, nie pozdrawiam
db.review.mapReduce(
    function(){
            emit(this.review_id, this.votes);
        },
    function(key, values) {return Array.sum(value)},
    {
    query: {votes: {'funny': {$gt: 0}}},
    out: "Sum of votes"
    }
)

// Homework

// Zad 1a
use KamilDelekta3

db.business.find({open: false}, {_id: 0, name:1, full_address: 1, stars: 1})

// Zad 1b

db.user.find({
    $and: [
    {"votes.funny": 0},
    {"votes.useful": 0},
    ]
}).sort({'name': 1})

// zad 1c
use KamilDelekta3
db.tip.aggregate([
{
    $match : {"date": /.*2012.*/},
},
{
    $group:
    {
    _id: "$business_id",
    count: {$sum: 1}
    }
},
{
    $sort: {count: -1},
}
])

use KamilDelekta3
// zad 1d
db.review.countDocuments()

use KamilDelekta3
db.review.aggregate
([
{
    $group: {
        _id: "$business_id",
        avgStars: {$avg: "$stars"}
    }
},
{
    $lookup: {
        from: "business",
        localField: "_id",
        foreignField: "business_id",
        as: "business_vals"
    }
},
{
 $unwind: "$business_vals"
},
{
    $project:
    {
        "name": "$business_vals.name",
        "avgStars": "$avgStars"
    }
},
{
    $match: {
        avgStars: {$gte: 4}
    }
},
{   // I take only 500 documents to speed up calculations
    $limit: 500
}
])

// zad 1e
use KamilDelekta3
db.business.countDocuments()
db.business.deleteMany({"stars": {$eq: 2}})
db.business.countDocuments()

// zad 2

function insertReview(business_id, review_id, stars, text, user_id, votes){
    db.review.insertOne(
        {
            business_id: business_id,
            date: new Date(),
            review_id: review_id,
            stars: stars,
            text: text,
            type: "review",
            user_id: user_id,
            votes: votes
        }
    )
}
insertReview("1", "Unique review id", 6, "Ten tekst", "Unique user id", {"funny": 0, "useful": 2, "cool": 1})

// zad 3
function getBusinesses(category){
    return db.business.find({
        categories: category
    })
}

var businesses = getBusinesses("Car Rental")
businesses

// zad 4

function updateUserName(id, newName){
    db.user.updateOne(
    {user_id: id},
    {$set: {name: newName}}
    )
}

updateUserName("kTpGfnUhc2EBWQCB14Ggkw", "Kamil")

// zad 5

// Error: Unable to handle 'this' keyword outside of method definition
// Nie zrobisz tego w DataGripie
var mapFunction1 = function() {
   emit(this.business_id, 1);
};

var reduceFunction1 = function(id, values) {
   return Array.sum(values);
};

var finalizeFunction1 = function(key, sum){
    var unique_len = db.tip.distinct("business_id").length
    return sum / unique_len
};

db.tip.mapReduce(
    function(){emit(this.business_id, 1);},
    reduceFunction1,
    {
        out: "Tips per business average",
        finalize: finalizeFunction1
    }
)


//
var mapFunction = function() {
    var key = this.user_id; var value =
    {
    sum: this.review_count,
    count: 1 }
        emit(key, value);
};
var reduceFunction = function(key, values) {
    var result = {
    sum: 0,
    count: 0 };
    values.forEach( function(value)
    {
    result.sum += value.sum; result.count += value.count;
    } )
    return result + 1;
}
var finalizeFunction = function(key, reducedValue) {
    var avgReviews = reducedValue.sum / reducedValue.count;
    return avgReviews;
}
db.user.mapReduce(
    mapFunction,
    reduceFunction,
    {
            out: "tips_per_business_avg",
        finalize: finalizeFunction
    }
)