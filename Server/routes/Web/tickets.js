const express = require("express");
const router = express.Router();
const ticketCtrl = require("../../controllers/Common/tickets");
const userCtrl = require("../../controllers/Web/user")
const jwtMiddleware = require("../../middleware/jwt");
const mobileUserCtrl = require("../../controllers/Mobile/user")
const languageMiddleware = require('../../middleware/language')

router.get("/all-tickets", async function (req, res, next) {
  try {
    const tickets = await ticketCtrl.getAllTickets();
    res.status(200).json({ tickets });
  } catch (err) {
    next(err);
  }
});

router.get('/user-ticket/:uuid', async (req, res, next) => {
  const uuid = req.params.uuid;

  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = await userCtrl.findUserByUuid(uuid)
    if (!user) {
      return res.status(404).send(res.__('userNotFound'));
    }
    languageMiddleware.setServerLanguage(req, user)
    const tickets = await ticketCtrl.getAllUserTickets(user.uuid);

    return res.status(200).json({ tickets });
  } catch (err) {
    next(err);
  }
})


router.post('/create', async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const { uuid, content, title, createdAt, assignedId, chatUid} = req.body

    const user = await userCtrl.findUserByUuid(uuid)
    if (!user) {
      return res.status(404).send(res.__('userNotFound'));
    }
    languageMiddleware.setServerLanguage(req, user)
    if (!content || !title) {
      return res.status(400).send(res.__('missingParamaters'))
    }

    if (chatUid) {
      const conversation = await ticketCtrl.getConversation(chatUid)
      if (!conversation) {
        return res.status(404).send(res.__('chatNotFound'));
      }
    }

    const creatorId = uuid;

    const ticket = await ticketCtrl.createTicket({
      content,
      title,
      creatorId,
      createdAt : new Date(createdAt),
      assignedId : assignedId ?? "",
      chatUid : chatUid
    })
    return res.status(201).send(res.__('ticketCreated'))
  } catch (err) {
    next(err);
  }
});

router.put('/assign/:assignedId', async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

    const assignedId = req.params.assignedId
    const { ticketIds } = req.body
    if (!assignedId || !ticketIds) {
      return res.status(400).json(res.__('missingParamaters'))
    }
    const assigned = await userCtrl.findUserByUuid(assignedId)
    if (!assigned) {
      return res.status(404).send(res.__('assignedUserNotFound'));
    }
    ids = ticketIds.split("_")
    for (let i = 0; i < ids.length; i++) {
      await ticketCtrl.assignTicket(ids[i], assignedId)
    }
    return res.status(201).send(res.__('ticketAssigned'))
  } catch (err) {
    next(err);
  }
})

router.put('/:chatId', async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = await userCtrl.findUserByUuid(req.body.uuid)
    if (!user) {
      return res.status(404).send(res.__('userNotFound'));
    }
    languageMiddleware.setServerLanguage(req, user)
    const chatId = req.params.chatId
    if (!chatId) {
      return res.status(400).json(res.__('missingChatId'))
    }
    await ticketCtrl.closeConversation(chatId)

    return res.status(201).send(res.__('chatClosed'))
  } catch (err) {
    next(err);
  }
})

router.get('/assigned-info/:assignedId', async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error(res.__('unauthorized'));
  }
  try {
    const user = userCtrl.getUserFromToken(req)
    languageMiddleware.setServerLanguage(req, user)

    const assignedId = req.params.assignedId
    if (!assignedId) {
      return res.status(400).json(res.__('missingAssignedId'))
    }
    const webUser = await userCtrl.findUserByUuid(assignedId)
    if (webUser) {
      return res.status(200).json({ "firstName" : webUser.firstName, "lastName" : webUser.lastName })
    }
    const mobileUser = await mobileUserCtrl.findUserById(assignedId)
    if (mobileUser) {
      return res.status(200).json({ "firstName" : mobileUser.firstName, "lastName" : mobileUser.lastName })
    }
    return res.status(404).send(res.__('assignedUserNotFound'));
  } catch (err) {
    next(err);
  }
})

module.exports = router;
