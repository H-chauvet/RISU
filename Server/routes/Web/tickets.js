const express = require("express");
const router = express.Router();
const ticketCtrl = require("../../controllers/Common/tickets");
const userCtrl = require("../../controllers/Web/user");
const jwtMiddleware = require("../../middleware/jwt");
const mobileUserCtrl = require("../../controllers/Mobile/user");
const languageMiddleware = require("../../middleware/language");

router.get("/all-tickets", async function (req, res, next) {
  try {
    const tickets = await ticketCtrl.getAllTickets(res);
    res.status(200).json({ tickets });
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.get("/user-ticket/:uuid", async (req, res, next) => {
  const uuid = req.params.uuid;

  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const user = await userCtrl.findUserByUuid(res, uuid);
    if (!user) {
      return res.status(404).send(res.__("userNotFound"));
    }
    languageMiddleware.setServerLanguage(req, user);
    const tickets = await ticketCtrl.getAllUserTickets(res, user.uuid);

    return res.status(200).json({ tickets });
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.post("/create", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const { uuid, content, title, createdAt, assignedId, chatUid } = req.body;

    const user = await userCtrl.findUserByUuid(res, uuid);
    if (!user) {
      return res.status(404).send(res.__("userNotFound"));
    }
    languageMiddleware.setServerLanguage(req, user);
    if (!content || !title) {
      return res.status(400).send(res.__("missingParameters"));
    }

    if (chatUid) {
      const conversation = await ticketCtrl.getConversation(res, chatUid);
      if (!conversation) {
        return res.status(404).send(res.__("chatNotFound"));
      }
    }

    const creatorId = uuid;

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
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.put("/assign/:assignedId", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization.split(" ")[1]);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    console.log(token);
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const assignedId = req.params.assignedId;
    const { ticketIds } = req.body;
    if (!assignedId || !ticketIds) {
      return res.status(400).json(res.__("missingParameters"));
    }
    const assigned = await userCtrl.findUserByUuid(res, assignedId);
    if (!assigned) {
      return res.status(404).send(res.__("assignedUserNotFound"));
    }
    ids = ticketIds.split("_");
    for (let i = 0; i < ids.length; i++) {
      await ticketCtrl.assignTicket(res, ids[i], assignedId);
    }
    return res.status(201).send(res.__("ticketAssigned"));
  } catch (err) {
    if (res.statusCode == 200) {
    }
    res.send(err);
  }
});

router.put("/:chatId", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const user = await userCtrl.findUserByUuid(res, req.body.uuid);
    if (!user) {
      return res.status(404).send(res.__("userNotFound"));
    }
    languageMiddleware.setServerLanguage(req, user);
    const chatId = req.params.chatId;
    if (!chatId) {
      return res.status(400).json(res.__("missingChatId"));
    }
    await ticketCtrl.closeConversation(res, chatId);

    return res.status(201).send(res.__("chatClosed"));
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.get("/assigned-info/:assignedId", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send(res.__("unauthorized"));
    return;
  }
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwtMiddleware.decodeToken(token);

    const user = await userCtrl.findUserByEmail(res, decodedToken.userMail);
    languageMiddleware.setServerLanguage(req, user);

    const assignedId = req.params.assignedId;
    if (!assignedId) {
      return res.status(400).json(res.__("missingAssignedId"));
    }
    const webUser = await userCtrl.findUserByUuid(res, assignedId);
    if (webUser) {
      return res
        .status(200)
        .json({ firstName: webUser.firstName, lastName: webUser.lastName });
    }
    const mobileUser = await mobileUserCtrl.findUserById(res, assignedId);
    if (mobileUser) {
      return res.status(200).json({
        firstName: mobileUser.firstName,
        lastName: mobileUser.lastName,
      });
    }
    return res.status(404).send(res.__("assignedUserNotFound"));
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

module.exports = router;
