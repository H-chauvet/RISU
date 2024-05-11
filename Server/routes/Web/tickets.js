const express = require("express");
const router = express.Router();
const ticketCtrl = require("../../controllers/Common/tickets");
const userCtrl = require("../../controllers/Web/user")
const jwtMiddleware = require("../../middleware/jwt");


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
    throw new Error("Unauthorized");
  }
  try {
    const user = await userCtrl.findUserByUuid(uuid)
    if (!user) {
      return res.status(404).send('User not found');
    }
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
    throw new Error("Unauthorized");
  }
  try {
    const { uuid, content, title, createdAt, assignedId, chatUid} = req.body

    const user = await userCtrl.findUserByUuid(uuid)
    if (!user) {
      return res.status(404).send('User not found');
    }

    if (!content || !title) {
      return res.status(400).send("Bad Request : Missing required parameters")
    }
    if (assignedId) {
      const assigned = await userCtrl.findUserByUuid(assignedId)
      if (!assigned) {
        return res.status(404).send('Bad Request : Assigned User not found');
      }
    }

    if (chatUid) {
      const conversation = await ticketCtrl.getConversation(chatUid)
      if (!conversation) {
        return res.status(404).send('Bad Request : Conversation not found');
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
    return res.status(201).send("Success: Ticket Created.")
  } catch (err) {
    next(err);
  }
});

router.put('/assign/:assignedId', async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const user = await userCtrl.findUserByUuid(req.params.assignedId);
    if (!user) {
      return res.status(404).send('User not found');
    }
    const assignedId = req.params.assignedId
    const ticketId = req.body.ticketId
    if (!assignedId || !ticketId) {
      return res.status(400).json("Bad Request : Missing required parameters")
    }
    const assigned = await userCtrl.findUserByUuid(assignedId)
      if (!assigned) {
        return res.status(404).send('Bad Request : Assigned User not found');
      }
    await ticketCtrl.assignTicket(ticketId, assignedId)
    return res.status(201).send("Success : Ticket assigned")
  } catch (err) {
    next(err);
  }
})

router.put('/:chatId', async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const user = await userCtrl.findUserByUuid(req.body.uuid)
    if (!user) {
      return res.status(404).send('User not found');
    }
    const chatId = req.params.chatId
    if (!chatId) {
      return res.status(400).json("Bad Request : Missing conversation id")
    }
    await ticketCtrl.closeConversation(chatId)

    return res.status(201).send("Success : Conversation closed")
  } catch (err) {
    next(err);
  }
})

router.delete('/:chatId', async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401);
    throw new Error("Unauthorized");
  }
  try {
    const user = await userCtrl.findUserByUuid(req.body.uuid)
    if (!user) {
      return res.status(404).send('User not found');
    }
    const chatId = req.params.chatId
    if (!chatId) {
      return res.status(400).json("Bad Request : Missing conversation id")
    }
    await ticketCtrl.deleteConversation(chatId)
    
    return res.status(200).send("Success : Conversation deleted")
  } catch (err) {
    next(err);
  }
})

module.exports = router;