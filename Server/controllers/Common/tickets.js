const { db } = require("../../middleware/database");

/**
 * Create a new ticket in the database
 * The ticketInfo must include the content, the title and the creator uid
 * It shall also specify the user assigned and the chat uid if it's not the first ticket of the conversation
 *
 * @param {*} ticketInfo object that contains the data
 * @throws {Error} with a specific message to find the problem
 * @returns the new object stored in the database
 */
exports.createTicket = async (ticketInfo) => {
  try {
    return await db.Tickets.create({
      data: ticketInfo,
    });
  } catch (err) {
    throw "Something happen while creating ticket";
  }
};

/**
 * Update the assigned user of a new ticket
 *
 * @param {*} id of the ticket to be updated
 * @param {*} assignedId of the admin who will be assigned to the ticket
 * @throws {Error} with a specific message to find the problem
 * @returns the freshly updated object
 */
exports.assignTicket = async (id, assignedId) => {
  try {
    intId = parseInt(id);
    return await db.Tickets.update({
      where: {
        id: intId,
      },
      data: {
        assignedId,
      },
    });
  } catch (err) {
    throw "Something happen while assigning ticket";
  }
};

/**
 * Make every tickets within the same conversation closed
 *
 * @param {*} chatUid of the conversation to be closed
 * @throws {Error} with a specific message to find the problem
 * @returns the freshly updated objects
 */
exports.closeConversation = async (chatUid) => {
  try {
    return await db.Tickets.updateMany({
      where: {
        chatUid,
      },
      data: {
        closed: true,
      },
    });
  } catch (err) {
    throw "Something happen while assigning ticket";
  }
};

/**
 * Delete a conversation of the database
 *
 * @param {*} chatUid of the conversation to be deleted
 * @throws {Error} with a specific message to find the problem
 * @returns none
 */
exports.deleteConversation = async (chatUid) => {
  try {
    return await db.Tickets.deleteMany({
      where: {
        chatUid,
      },
    });
  } catch (err) {
    throw "Something happen while assigning ticket";
  }
};

/**
 * Get every ticket that the user has created or has been assigned to
 *
 * @param {*} id of the user
 * @throws {Error} with a specific message to find the problem
 * @returns the user's tickets
 */
exports.getAllUserTickets = async (id) => {
  try {
    return await db.Tickets.findMany({
      where: {
        OR: [{ creatorId: id }, { assignedId: id }],
      },
    });
  } catch (err) {
    throw "Something happen while assigning ticket";
  }
};

/**
 * Retrieve a specific conversation from the database
 *
 * @param {*} id of the searched conversation
 * @throws {Error} with a specific message to find the problem
 * @returns the tickets related to the conversation
 */
exports.getConversation = async (id) => {
  try {
    return await db.Tickets.findMany({
      where: {
        chatUid: id,
      },
    });
  } catch (err) {
    throw "Something happen while assigning ticket";
  }
};

/**
 * Retrieve every tickets of the database (Admin purpose only)
 *
 * @throws {Error} with a specific message to find the problem
 * @returns every tickets in a list
 */
exports.getAllTickets = async () => {
  try {
    return await db.Tickets.findMany();
  } catch (err) {
    throw "Something happen while assigning ticket";
  }
};

/**
 * Clean every ticket related to a mobile user before deleting his account
 *
 * @param {*} userId of the user
 * @throws {Error} with a specific message to find the problem
 * @returns none
 */
exports.cleanMobileUserTickets = async (userId) => {
  try {
    return await db.Tickets.deleteMany({
      where: {
        OR: [{ creatorId: userId }, { assignedId: userId }],
      },
    });
  } catch (err) {
    throw "Something happen while assigning ticket";
  }
};
