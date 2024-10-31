const express = require("express");
const router = express.Router();

const userCtrl = require("../../controllers/Web/user");
const jwtMiddleware = require("../../middleware/jwt");
const generator = require("generate-password");
const languageMiddleware = require("../../middleware/language");

router.post("/login", async function (req, res, next) {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      res.status(400);
      throw res.__("missingMailPwd");
    }

    const existingUser = await userCtrl.findUserByEmail(res, email);
    if (!existingUser) {
      res.status(400);
      throw res.__("mailNotExist");
    }

    const user = await userCtrl.loginByEmail(res, { email, password });
    languageMiddleware.setServerLanguage(req, user);
    const accessToken = jwtMiddleware.generateAccessToken(user);

    res.json({
      accessToken : accessToken,
      language : user.language
    });
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/google-login", async function (req, res, next) {
  try {
    const { email } = req.body;
    if (!email) {
      res.status(400);
      throw res.__("missingMailPwd");
    }

    const existingUser = await userCtrl.findUserByEmail(res, email);
    let user = null;
    if (!existingUser) {
      const password = generator.generate({
        length: 8,
        numbers: true,
        symbols: true,
        uppercase: false,
        excludeSimilarCharacters: true,
        strict: true,
      });
      user = await userCtrl.registerByEmail(res, { email, password: password });
    }

    const accessToken = jwtMiddleware.generateAccessToken(user);

    res.json({
      accessToken,
    });
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/register", async function (req, res, next) {
  try {
    const { firstName, lastName, email, password } = req.body;
    if (!email || !password) {
      res.status(400);
      throw res.__("missingMailPwd");
    }
    const existingUser = await userCtrl.findUserByEmail(res, email);
    if (existingUser) {
      res.status(400);
      throw res.__("mailAlreadyExist");
    }

    const user = await userCtrl.registerByEmail(res, {
      firstName,
      lastName,
      email,
      password,
    });
    languageMiddleware.setServerLanguage(req, user);
    const accessToken = jwtMiddleware.generateAccessToken(user);

    res.status(200).json({
      accessToken,
    });
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/forgot-password", async function (req, res, next) {
  try {
    const { email } = req.body;

    if (!email) {
      res.status(400);
      throw res.__("missingMail");
    }

    const existingUser = await userCtrl.findUserByEmail(res, email);
    if (!existingUser) {
      res.status(400);
      throw res.__("wrongMail");
    }
    languageMiddleware.setServerLanguage(req, existingUser);
    userCtrl.forgotPassword(res, email);
    res.json(res.__("Success"));
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/update-password", async function (req, res, next) {
  try {
    const { uuid, password } = req.body;

    if (!uuid || !password) {
      res.status(400);
      throw res.__("missingMailPwd");
    }

    const existingUser = await userCtrl.findUserByUuid(res, uuid);
    if (!existingUser) {
      res.status(401);
      throw res.__("accountNotExist");
    }
    languageMiddleware.setServerLanguage(req, existingUser);
    const ret = await userCtrl.updatePassword(res, { uuid, password });
    res.json(ret);
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/register-confirmation", async function (req, res, next) {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const { email } = req.body;

    if (!email) {
      res.status(400);
      throw res.__("missingMail");
    }
    const existingUser = await userCtrl.findUserByEmail(res, email);
    if (!existingUser) {
      res.status(400);
      throw res.__("wrongMail");
    }

    languageMiddleware.setServerLanguage(req, existingUser);
    userCtrl.registerConfirmation(res, email);
    res.json(res.__("Success"));
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/confirmed-register", async function (req, res, next) {
  try {
    const { uuid } = req.body;

    if (!uuid) {
      res.status(400);
      throw res.__("missingUuid");
    }

    const user = await userCtrl.confirmedRegister(res, uuid);
    languageMiddleware.setServerLanguage(req, user);
    const accessToken = jwtMiddleware.generateAccessToken(user);
    res.json({ accessToken });
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/delete", async function (req, res, next) {
  const { email } = req.body;

  try {
    await userCtrl.deleteUser(res, email);
    res.json(res.__("Success")).status(200);
  } catch (err) {
    res.status(500).send(err);
  }
});

router.get("/privacy", async function (req, res, next) {
  try {
    const privacyDetails =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";

    res.send(privacyDetails);
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.get("/listAll", async function (req, res, next) {
  try {
    const user = await userCtrl.getAllUsers(res);

    res.status(200).json({ user });
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.get("/user-details/:email", async (req, res) => {
  const email = req.params.email;

  try {
    const userDetails = await userCtrl.findUserDetailsByEmail(res, email);

    if (!userDetails) {
      res.status(400);
      throw "Email don't exist";
    }

    res.status(200).json(userDetails);
  } catch (error) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(error);
  }
});

router.post("/update-details/:email", async (req, res, next) => {
  const email = req.params.email;
  console.log(email)
  try {
    const { firstName, lastName, language } = req.body;
    console.log(language)
    const existingUser = await userCtrl.findUserByEmail(res, email);
    if (!existingUser) {
      console.log("???")
      res.status(404).send(res.__("userNotFound"));
      return;
    }
    console.log(language)
    const updatedUser = await userCtrl.updateName(res, existingUser, {
      firstName,
      lastName,
      language
    });
    console.log(updatedUser.language)
    res.status(200).json(updatedUser);
  } catch (err) {
    console.log("WAIT")
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/update-mail", async (req, res, next) => {
  try {
    const { oldMail, newMail } = req.body;

    if (!oldMail || !newMail) {
      res.status(400).send(res.__("missingMail"));
      return;
    }

    const existingUser = await userCtrl.findUserByEmail(res, oldMail);
    if (!existingUser) {
      res.status(404).send(res.__("userNotFound"));
      return;
    }
    languageMiddleware.setServerLanguage(req, existingUser);
    const updatedUser = await userCtrl.updateMail(res, { oldMail, newMail });
    res.status(200).json(updatedUser);
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/update-company/:email", async (req, res, next) => {
  const email = req.params.email;

  try {
    const { company } = req.body;

    if (!company) {
      res.status(400).send(res.__("missingCompany"));
      return;
    }

    const existingUser = await userCtrl.findUserByEmail(res, email);
    if (!existingUser) {
      res.status(404).send(res.__("userNotFound"));
      return;
    }
    languageMiddleware.setServerLanguage(req, existingUser);
    const updatedUser = await userCtrl.updateCompany(res, { email, company });
    res.status(200).json(updatedUser);
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.put("/update-company", async (req, res) => {
  try {
    const { email, company, manager } = req.body;

    const user = await userCtrl.findUserByEmail(res, email);
    if (!user) {
      res.status(404);
      throw res.__("userNotFound");
    }

    languageMiddleware.setServerLanguage(req, user);
    const userUpdated = await userCtrl.addCompanyToUser(
      res,
      user,
      company,
      manager === "true"
    );
    res.status(200).send(userUpdated);
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

router.post("/update-password/:email", async (req, res, next) => {
  const email = req.params.email;

  try {
    const { password } = req.body;

    if (!password) {
      res.status(400).send(res.__("missingParameters"));
      return;
    }

    const existingUser = await userCtrl.findUserByEmail(res, email);
    if (!existingUser) {
      res.status(404).send(res.__("userNotFound"));
      return;
    }
    languageMiddleware.setServerLanguage(req, existingUser);
    const updatedUser = await userCtrl.updateUserPassword(res, {
      email,
      password,
    });
    res.status(200).json(updatedUser);
  } catch (err) {
    if (res.statusCode == 200) {
      res.statusCode = 500;
    }
    res.send(err);
  }
});

module.exports = router;
