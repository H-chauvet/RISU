const express = require("express");

const router = express.Router();

const passport = require("passport");
const userCtrl = require("../../controllers/Mobile/user");
const authCtrl = require("../../controllers/Mobile/auth");
const cleanCtrl = require("../../controllers/Mobile/cleandata");
const bcrypt = require("bcrypt");
const jwtMiddleware = require("../../middleware/Mobile/jwt");
const languageMiddleware = require("../../middleware/language");

router.get("/listAll", async (req, res, next) => {
  try {
    const user = await userCtrl.getAllUsers();
    return res.status(200).json({ user });
  } catch (err) {
    next(err);
    return res.status(400).send(res.__("errorOccured"));
  }
});

router.put(
  "/password",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      const currentPassword = req.body.currentPassword;
      if (!currentPassword || currentPassword === "") {
        return res.status(400).send(res.__("missingCurrPwd"));
      }
      const newPassword = req.body.newPassword;
      if (!newPassword || newPassword === "") {
        return res.status(400).send(res.__("missingNewPwd"));
      }
      const isMatch = await bcrypt.compare(currentPassword, user.password);
      if (!isMatch) {
        return res.status(401).send(res.__("wrongCurrPwd"));
      }
      var updatedUser = await userCtrl.setNewUserPassword(user, newPassword);
      return res.status(200).json({ updatedUser });
    } catch (err) {
      console.error(err.message);
      return res.status(500).send(res.__("errorOccured"));
    }
  }
);

router.post("/password/reset", async (req, res) => {
  const { email } = req.body;
  if (!email || email === "") {
    return res.status(400).send(res.__("missingParamaters"));
  }

  try {
    user = await userCtrl.findUserByEmail(res, email);
    if (!user) {
      return res.status(404).send(res.__("userNotFound"));
    }
    languageMiddleware.setServerLanguage(req, user);
    resetToken = jwtMiddleware.generateResetToken(user);
    resetToken = resetToken.substring(0, 64);
    user = await userCtrl.updateUserResetToken(user.id, resetToken);
    await userCtrl.sendResetPasswordEmail(user.email, resetToken);
    user = await userCtrl.removeUserResetToken(user.id);

    return res.status(200).send(res.__("mailResetPwdsent"));
  } catch (error) {
    console.error("Failed to reset password:", error);
    return res.status(500).send(res.__("failResetPwd"));
  }
});

router.get(
  "/:userId",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      if (req.user.id != req.params.userId) {
        return res.status(401).send(res.__("unauthorized"));
      }
      const user = await userCtrl.findUserById(req.params.userId);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      return res.status(200).json({ user });
    } catch (err) {
      console.error(err.message);
      return res.status(500).send(res.__("errorOccured"));
    }
  }
);

router.put(
  "/",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(401).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      const updatedUser = await userCtrl.updateUserInfo(user, req.body);
      return res.status(200).json({ updatedUser });
    } catch (error) {
      console.error("Failed to update notifications: ", error);
      return res.status(500).send(res.__("failUpdateNotif"));
    }
  }
);

router.put(
  "/newEmail",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      const user = await userCtrl.findUserById(req.user.id);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      if (!req.body.newEmail || req.body.newEmail === "") {
        return res.status(400).send(res.__("missingNewMail"));
      }
      const updatedUser = await userCtrl.updateNewEmail(user);
      const token = req.headers.authorization.split(" ")[1];
      authCtrl.sendConfirmationNewEmail(req.body.newEmail, token);
      return res.status(200).json({ updatedUser });
    } catch (error) {
      return res.status(500).send(res.__("failUpdateNewMail"));
    }
  }
);

router.delete(
  "/:userId",
  jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate("jwt", { session: false }),
  async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send(res.__("invalidToken"));
      }
      if (req.user.id != req.params.userId) {
        return res.status(401).send(res.__("unauthorized"));
      }
      const user = await userCtrl.findUserById(req.params.userId);
      if (!user) {
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      await cleanCtrl.cleanUserData(res, user.id, user.notificationsId);
      await userCtrl.deleteUser(user.id);
      return res.status(200).send(res.__("userDeleted"));
    } catch (error) {
      console.error("Failed to delete account: ", error);
      return res.status(500).send(res.__("failUserDelete"));
    }
  }
);

module.exports = router;
