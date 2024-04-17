const express = require('express')

const router = express.Router()
const passport = require('passport')
const userCtrl = require("../../controllers/Mobile/user")
const ticketCtrl = require("../../controllers/Common/tickets")
const jwtMiddleware = require('../../middleware/Mobile/jwt')

router.get('/', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send('User not found');
      }
      const tickets = await ticketCtrl.getAllUserTickets(user.id);

      return res.status(200).json({ tickets })
    } catch (err) {
      console.error(err.message)
      return res.status(400).send('Unexpected behavior happened, please check the log for more details.')
    }
  }
)

router.post('/', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send('User not found');
      }

      const { content, title, assignedId, chatUid } = req.body

      if (!content || !title) {
        return res.status(400).send("Bad Request : Missing required parameters")
      }
      if (assignedId) {
        const assigned = await userCtrl.findUserById(assignedId)
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

      const creatorId = user.id;

      const ticket = await ticketCtrl.createTicket({
        content,
        title,
        creatorId,
        assignedId : assignedId ?? "",
        chatUid : chatUid
      })

      return res.status(201).send("Success: Ticket Created.")
    } catch (err) {
      console.error(err.message)
      return res.status(400).send('Unexpected behavior happened, please check the log for more details.')
    }
  }
)

router.put('/assign/:assignedId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
      if (!user) {
        return res.status(404).send('User not found');
      }

      const assignedId = req.params.assignedId
      const ticketId = req.body.ticketId

      if (!assignedId || !ticketId) {
        return res.status(400).json("Bad Request : Missing required parameters")
      }
      const assigned = await userCtrl.findUserById(assignedId)
        if (!assigned) {
          return res.status(404).send('Bad Request : Assigned User not found');
        }

      await ticketCtrl.assignTicket(ticketId, assignedId)

      return res.status(201).send("Success : Ticket assigned")
    } catch (err) {
      console.error(err.message)
      return res.status(400).send('Unexpected behavior happened, please check the log for more details.')
    }
  }
)

router.put('/:chatId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
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
      console.error(err.message)
      return res.status(400).send('Unexpected behavior happened, please check the log for more details.')
    }
  }
)

router.delete('/:chatId', jwtMiddleware.refreshTokenMiddleware,
  passport.authenticate('jwt', { session: false }), async (req, res) => {
    try {
      if (!req.user) {
        return res.status(401).send('Invalid token');
      }
      const user = await userCtrl.findUserById(req.user.id)
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
      console.error(err.message)
      return res.status(400).send('Unexpected behavior happened, please check the log for more details.')
    }
  }
)

module.exports = router
