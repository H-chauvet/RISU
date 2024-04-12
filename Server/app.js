const express = require("express");
const passport = require('passport');
const auth = require('./passport/strategy_options');
const auth_token = require('./passport/bearer_token');
const session = require('express-session');
const path = require('path');

const app = express();
const userRoutes = require('./routes/Web/user');
const contactRoutes = require('./routes/Web/contact');
const messagesRoutes = require('./routes/Web/messages');
const containerRoutes = require('./routes/Web/container');
const feedbacksRoutes = require('./routes/Web/feedbacks');
const itemsRoutes = require('./routes/Web/items');
const paymentRoutes = require("./routes/Web/payment");

const userMobileRoutes = require("./routes/Mobile/user");
const authMobileRoutes = require("./routes/Mobile/auth");
const contactMobileRoutes = require("./routes/Mobile/contact");
const containerMobileRoutes = require("./routes/Mobile/containers")
const itemMobileRoutes = require("./routes/Mobile/items")
const rentMobileRoutes = require("./routes/Mobile/rent")
const opinionMobileRoutes = require("./routes/Mobile/opinion")

var cors = require("cors");
var bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json({ limit: "50mb" }));
app.use(express.json({ limit: "50mb" }));
app.use(cors());

app.get("/", (req, res) => {
  res.send("Configurateur server!");
});

app.get("/.well-known/assetlinks.json", (req, res) => {
  res.sendFile(path.join(__dirname, "assetlinks.json"));
});

app.use(session({ secret: 'SECRET', resave: false, saveUninitialized: false }))

passport.serializeUser((user, done) => {
  done(null, user.id)
})

passport.deserializeUser((id, done) => {
  done(null, { id: id })
})

app.use(passport.initialize())
app.use(passport.session())

app.use('/api/auth', userRoutes)
app.use('/api', contactRoutes)
app.use('/api/container', containerRoutes)
app.use('/api/messages', messagesRoutes)
app.use('/api/feedbacks', feedbacksRoutes)
app.use('/api/items', itemsRoutes)
app.use("/api/payment", paymentRoutes);

app.use("/api/mobile/user", userMobileRoutes)
app.use("/api/mobile/auth", authMobileRoutes)
app.use("/api/mobile", contactMobileRoutes)
app.use("/api/mobile/container", containerMobileRoutes)
app.use("/api/mobile/article", itemMobileRoutes)
app.use("/api/mobile/rent", rentMobileRoutes)
app.use("/api/mobile/opinion", opinionMobileRoutes)

module.exports = app;
