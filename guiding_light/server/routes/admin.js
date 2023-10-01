const express = require("express");
const adminRouter = express.Router();
const bcryptjs = require("bcryptjs");

const User = require("../models/user");



  adminRouter.post("/api/addAdmin", async (req, res) => {
    try {
      const { name, email, password, phoneNumber} = req.body;
  
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res
          .status(400)
          .json({ msg: "User with same email already exists!" });
      }
  
      const hashedPassword = await bcryptjs.hash(password, 8);
  
      let user = new User({
        email,
        password: hashedPassword,
        name,
        phoneNumber,
        type:'admin',
        verified: true
        
      });
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  


  
  
  
  module.exports = adminRouter;