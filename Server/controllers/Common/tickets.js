const { db } = require('../../middleware/database')

/**
 * Create a new ticket in the database
 * The ticketInfo must include the content, the title and the creator uid
 * It shall also specify the user assigned and the chat uid if it's not the first ticket of the conversation
 *
 * @param {*} ticketInfo object that contains the data
 * @returns the new object stored in the database
 */
exports.createTicket = (ticketInfo) => {
  return db.Tickets.create({
    data: ticketInfo,
  });
};

/**
 * Update the assigned user of a new ticket
 *
 * @param {*} id of the ticket to be updated
 * @param {*} assignedId of the admin who will be assigned to the ticket
 * @returns the freshly updated object
 */
exports.assignTicket = (id, assignedId) => {
  intId = parseInt(id)
  return db.Tickets.update({
    where: {
      id: intId,
    },
    data: {
      assignedId
    }
  });
}

/**
 * Make every tickets within the same conversation closed
 *
 * @param {*} chatUid of the conversation to be closed
 * @returns the freshly updated objects
 */
exports.closeConversation = (chatUid) => {
  return db.Tickets.update({
    where: {
      chatUid
    },
    data: {
      closed: true
    }
  })
}

/**
 * Delete a conversation of the database
 *
 * @param {*} chatUid of the conversation to be deleted
 * @returns none
 */
exports.deleteConversation = (chatUid) => {
  return db.Tickets.delete({
    where: {
      chatUid,
    },
  });
}

/**
 * Get every ticket that the user has created or has been assigned to
 *
 * @param {*} id of the user
 * @returns the user's tickets
 */
exports.getAllUserTickets = (id) => {
  return db.Tickets.findMany({
    where: {
      OR: [
        { creatorId: id },
        { assignedId: id },
      ]
    }
  });
}

/**
 * Retrieve a specific conversation from the database
 *
 * @param {*} id of the searched conversation
 * @returns the tickets related to the conversation
 */
exports.getConversation = (id) => {
  return db.Tickets.findMany({
    where: {
      chatUid : id
    }
  });
}