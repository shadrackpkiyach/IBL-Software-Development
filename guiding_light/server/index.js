// IMPORTS FROM PACKAGES
const express = require("express");
var http = require("http");
const mongoose = require("mongoose");
mongoose.set("strictQuery", false);

const Message = require("./models/messageModel");


// IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const sendMessageRouter=  require("./routes/sendMail");
var cors = require('cors');
const app = express();
var server = http.createServer(app);




// INIT
const PORT = process.env.PORT || 3000;

const DB =
'mongodb+srv://shaddypkiach:Kortome88@cluster0.m3c8ibh.mongodb.net/'
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(sendMessageRouter);


const corsOptions ={
  origin:'http://127.0.0.1:3000', 
  credentials:true,            //access-control-allow-credentials:true
  optionSuccessStatus:200
}
app.use(cors(corsOptions));
var io = require("socket.io")(server,{cors:{corsOptions}});
 var clients = [];
io.on("connection",(socket)=>{
  console.log("Connection to socket Successful");
  console.log(socket.id,"has joined");
  socket.on("signin",(id)=>{
console.log(id);
clients[id]= socket;
console.log(clients)
});
 socket.on("message",(msg)=>{
console.log(msg);

const newMessage = new Message({
  senderId: msg.sourceId,
  targetId: msg.targetId,
  content: msg.message,
  name:msg.name,
});

newMessage.save().catch((error) => {
  console.error("Error saving message:", error);
});

let targetId=msg.targetId
if(clients[targetId])
clients[targetId].emit("message",msg);
//clients[targetId].emit("notification", msg);
});
});
// Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection to Db Successful");
  })
  .catch((e) => {
    console.log(e);
  });



server.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});
