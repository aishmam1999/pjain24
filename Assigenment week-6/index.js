// const express = require('express')
// const app = express()
// const port = 3000
// app.use(express.static('public'))
// app.get('/', (req, res) => res.send('Hello World!'))
//
// app.listen(port, () => console.log(`Example app listening on port ${port}!`))

const express = require('express');
const app = express();
const port = 3000

 let counter= 0;
 app.use(express.json());

 app.post('/counter',(req,res) => {
     counter +=1;
     console.log("counter is "+ counter);
     res.status(200).send("counter is "+ counter);
 });

 app.get('/counter', (req, res) =>{
// res.send();
 res.status(200).send("counter is "+ counter);
});

app.delete('/counter',(req,res) => {
  counter= 0;
  console.log("delete is working")
  res.status(204).send("counter is "+ counter);
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
