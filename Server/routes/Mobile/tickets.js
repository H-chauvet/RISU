const express = require("express");

const router = express.Router();
const passport = require("passport");
const userCtrl = require("../../controllers/Mobile/user");
const ticketCtrl = require("../../controllers/Common/tickets");
const jwtMiddleware = require("../../middleware/Mobile/jwt");
const webUserCtrl = require("../../controllers/Web/user");
const languageMiddleware = require("../../middleware/language");

router.get(
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
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      const tickets = await ticketCtrl.getAllUserTickets(res, user.id);

      return res.status(200).json({ tickets });
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.post(
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
        return res.status(404).send(res.__("userNotFound"));
      }
      languageMiddleware.setServerLanguage(req, user);
      const { content, title, createdAt, assignedId, chatUid } = req.body;

      if (!content || !title) {
        return res.status(400).send(res.__("missingParamaters"));
      }
      if (assignedId) {
        const assigned = await userCtrl.findUserById(assignedId);
        if (!assigned) {
          return res.status(404).send(res.__("assignedUserNotFound"));
        }
      }
      if (chatUid) {
        const conversation = await ticketCtrl.getConversation(res, chatUid);
        if (!conversation) {
          return res.status(404).send(res.__("chatNotFound"));
        }
      }

      const creatorId = user.id;

      const ticket = await ticketCtrl.createTicket(res, {
        content,
        title,
        creatorId,
        createdAt: new Date(createdAt),
        assignedId: assignedId ?? "",
        chatUid: chatUid,
      });

      return res.status(201).send(res.__("ticketCreated"));
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.put(
  "/assign/:assignedId",
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
      const assignedId = req.params.assignedId;
      const ticketId = req.body.ticketId;

      if (!assignedId || !ticketId) {
        return res.status(400).send(res.__("missingParamaters"));
      }
      const assigned = await userCtrl.findUserById(assignedId);
      if (!assigned) {
        return res.status(404).send(res.__("assignedUserNotFound"));
      }

      await ticketCtrl.assignTicket(res, ticketId, assignedId);

      return res.status(201).send(res.__("ticketAssigned"));
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.put(
  "/:chatId",
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
      const chatId = req.params.chatId;
      if (!chatId) {
        return res.status(400).send(res.__("missingChatId"));
      }

      await ticketCtrl.closeConversation(res, chatId);

      return res.status(201).send(res.__("chatClosed"));
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.delete(
  "/:chatId",
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
      const chatId = req.params.chatId;
      if (!chatId) {
        return res.status(400).send(res.__("missingChatId"));
      }

      await ticketCtrl.deleteConversation(res, chatId);

      return res.status(200).send(res.__("chatDeleted"));
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

router.get(
  "/assigned-info/:assignedId",
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
      const assignedId = req.params.assignedId;
      if (!assignedId) {
        return res.status(400).send(res.__("missingAssignedId"));
      }

      const assigned = await webUserCtrl.findUserByUuid(res, assignedId);
      if (!assigned) {
        return res.status(404).send(res.__("assignedUserNotFound"));
      }

      return res
        .status(200)
        .json({ firstName: assigned.firstName, lastName: assigned.lastName });
    } catch (err) {
      console.error(err.message);
      return res.status(400).send(res.__("errorOccured"));
    }
  }
);

module.exports = router;
