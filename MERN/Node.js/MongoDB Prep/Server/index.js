const express = require('express')
const mongoose = require('mongoose')
const UserModel = require('./models/Users')
const cors = require('cors')
const app = express()
const serverAddress = 3001

app.use(express.json())
app.use(cors())

mongoose.connect("mongodb+srv://eqan1:pass123@cluster0.zk2im.mongodb.net/mongodbpractice?retryWrites=true&w=majority")

app.get("/getusers", (req, res) => {
    UserModel.find({}, (err, result) => {
      if (err) {
        res.json(err);
      } else {
        res.json(result);
      }
    });
  });

app.post('/createuser', async(req, res) => {
    const user = req.body;
    const newUser = new UserModel(user);
    await newUser.save();
    res.json(user);
})


app.listen(serverAddress, () => {
    console.log(`Server running on port ${serverAddress}`);
  });