const express = require("express");
const passport = require('passport');
const auth = require('./passport/strategy_options');
const auth_token = require('./passport/bearer_token');
const session = require('express-session');

const app = express();
const userRoutes = require('./routes/Web/user');
const contactRoutes = require('./routes/Web/contact');
const messagesRoutes = require('./routes/Web/messages');
const containerRoutes = require('./routes/Web/container');
const feedbacksRoutes = require('./routes/Web/feedbacks');
const itemsRoutes = require('./routes/Web/items');
const paymentRoutes = require("./routes/Web/payment");
const userMobileRoutes = require("./routes/Mobile/user");

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
app.use("/api/mobile/user", userMobileRoutes);

module.exports = app;
