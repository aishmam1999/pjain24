const express = require('express');
const app = express();
const port = 3000;

var MongoClient = require('mongodb').MongoClient;
var ObjectID = require('mongodb').ObjectID;

app.use(express.json());


MongoClient.connect('mongodb://localhost:27017/book', function (err, client) {
  if (err) throw err

  let db = client.db('book');
  let book = db.collection('book');

    //add some book
    app.post('/book',(req,res) => {
        let newbook = req.body;


        book.insert(newbook, function(err,result) {
            if(err){
                console.log(err);
                res.status(500).send("There was an internal error");
            } else {
                res.send(result);
            }
        });
    });

    //get a book
    app.get('/book/:id',(req,res) => {
        let id = ObjectID.createFromHexString(req.params.id);

        book.findOne({"_id":id}, function(err,book) {
            if(err){
                console.log(err);
                res.status(500).send("There was an internal error");
            } else {
                if (book === null) {
                    res.status(404).send("Not found")
                }
                res.send(book);
            }
        });
    });
    app.put('/book/:id',(req,res) => {
    let id = ObjectID.createFromHexString(req.params.id);

    book.updateOne({"_id":id}, { $set: req.body}, function(err,details) {
        if(err){
            console.log(err);
            res.status(500).send("There was an internal error");
        } else {
            res.status(204).send();
        }
    });
});

//delete
app.delete('/book/:id',(req,res) => {
    let id = ObjectID.createFromHexString(req.params.id);

    book.deleteOne({"_id":id}, function(err) {
        if(err){
            console.log(err);
            res.status(500).send("There was an internal error");
        } else {
            res.status(204).send();
        }
    });
});

});





app.listen(port, () => console.log(`book app listening on port ${port}!`));
