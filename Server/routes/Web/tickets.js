const express = require("express");
const router = express.Router();
const ticketCtrl = require("../../controllers/Common/tickets");
const userCtrl = require("../../controllers/Web/user");
const jwtMiddleware = require("../../middleware/jwt");
const mobileUserCtrl = require("../../controllers/Mobile/user");

router.get("/all-tickets", async function (req, res, next) {
  try {
    const tickets = await ticketCtrl.getAllTickets();
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
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    const user = await userCtrl.findUserByUuid(uuid);
    if (!user) {
      return res.status(404).send("User not found");
    }
    const tickets = await ticketCtrl.getAllUserTickets(user.uuid);

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
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    const { uuid, content, title, createdAt, assignedId, chatUid } = req.body;

    const user = await userCtrl.findUserByUuid(uuid);
    if (!user) {
      return res.status(404).send("User not found");
    }

    if (!content || !title) {
      return res.status(400).send("Bad Request : Missing required parameters");
    }

    if (chatUid) {
      const conversation = await ticketCtrl.getConversation(chatUid);
      if (!conversation) {
        return res.status(404).send("Bad Request : Conversation not found");
      }
    }

    const creatorId = uuid;

    const ticket = await ticketCtrl.createTicket({
      content,
      title,
      creatorId,
      createdAt: new Date(createdAt),
      assignedId: assignedId ?? "",
      chatUid: chatUid,
    });
    return res.status(201).send("Success: Ticket Created.");
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.put("/assign/:assignedId", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    const assignedId = req.params.assignedId;
    const { ticketIds } = req.body;
    if (!assignedId || !ticketIds) {
      return res.status(400).json("Bad Request : Missing required parameters");
    }
    const assigned = await userCtrl.findUserByUuid(assignedId);
    if (!assigned) {
      return res.status(404).send("Bad Request : Assigned User not found");
    }
    ids = ticketIds.split("_");
    for (let i = 0; i < ids.length; i++) {
      await ticketCtrl.assignTicket(ids[i], assignedId);
    }
    return res.status(201).send("Success : Ticket assigned");
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

router.put("/:chatId", async (req, res, next) => {
  try {
    jwtMiddleware.verifyToken(req.headers.authorization);
  } catch (err) {
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    const user = await userCtrl.findUserByUuid(req.body.uuid);
    if (!user) {
      return res.status(404).send("User not found");
    }
    const chatId = req.params.chatId;
    if (!chatId) {
      return res.status(400).json("Bad Request : Missing conversation id");
    }
    await ticketCtrl.closeConversation(chatId);

    return res.status(201).send("Success : Conversation closed");
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
    res.status(401).send("Unauthorized");
    return;
  }
  try {
    const assignedId = req.params.assignedId;
    if (!assignedId) {
      return res.status(400).json("Bad Request : Missing assigned id");
    }
    const webUser = await userCtrl.findUserByUuid(assignedId);
    if (webUser) {
      return res
        .status(200)
        .json({ firstName: webUser.firstName, lastName: webUser.lastName });
    }
    const mobileUser = await mobileUserCtrl.findUserById(assignedId);
    if (mobileUser) {
      return res.status(200).json({
        firstName: mobileUser.firstName,
        lastName: mobileUser.lastName,
      });
    }
    return res.status(404).send("Assigned user was not found");
  } catch (err) {
    if (res.statusCode == 200) {
      res.status(500);
    }
    res.send(err);
  }
});

module.exports = router;
