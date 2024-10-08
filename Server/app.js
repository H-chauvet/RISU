const express = require("express");
const passport = require('passport');
const auth = require('./passport/strategy_options');
const auth_token = require('./passport/bearer_token');
const session = require('express-session');
const i18n = require('i18n');

const app = express();
const userRoutes = require('./routes/Web/user');
const containerRoutes = require('./routes/Web/container');
const feedbacksRoutes = require('./routes/Web/feedbacks');
const itemsRoutes = require('./routes/Web/items');
const paymentRoutes = require("./routes/Web/payment");
const organizationRoutes = require("./routes/Web/organization");
const itemCategoryRoutes = require('./routes/Web/itemCategory');
const ticketsRoutes = require('./routes/Web/tickets');
const imagesRoutes = require('./routes/Web/images');
const downloadRoutes = require('./routes/Web/download');
const assetlinksRoutes = require('./routes/Web/assetlinks');

const userMobileRoutes = require("./routes/Mobile/user");
const authMobileRoutes = require("./routes/Mobile/auth");
const containerMobileRoutes = require("./routes/Mobile/containers")
const itemMobileRoutes = require("./routes/Mobile/items")
const rentMobileRoutes = require("./routes/Mobile/rent")
const opinionMobileRoutes = require("./routes/Mobile/opinion")
const ticketsMobileRoutes = require("./routes/Mobile/tickets")
const favoriteMobileRoutes = require("./routes/Mobile/favorites")

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

app.use(passport.initialize());
app.use(passport.session());

i18n.configure({
  locales: ['en', 'fr'],
  directory: __dirname + '/locales',
  defaultLocale: 'fr',
  objectNotation: true,
});

app.use(i18n.init);

app.use('/api/auth', userRoutes);
app.use('/api/container', containerRoutes);
app.use('/api/feedbacks', feedbacksRoutes);
app.use('/api/items', itemsRoutes);
app.use("/api/payment", paymentRoutes);
app.use("/api/organization", organizationRoutes);
app.use('/api/itemCategory', itemCategoryRoutes)
app.use('/api/tickets', ticketsRoutes)
app.use('/api/images', imagesRoutes);
app.use("/api/apk", downloadRoutes);
app.use('/.well-known', assetlinksRoutes);

app.use("/api/mobile/user", userMobileRoutes);
app.use("/api/mobile/auth", authMobileRoutes);
app.use("/api/mobile/container", containerMobileRoutes);
app.use("/api/mobile/article", itemMobileRoutes);
app.use("/api/mobile/rent", rentMobileRoutes);
app.use("/api/mobile/opinion", opinionMobileRoutes);
app.use("/api/mobile/ticket", ticketsMobileRoutes);
app.use("/api/mobile/favorite", favoriteMobileRoutes);

module.exports = app;
