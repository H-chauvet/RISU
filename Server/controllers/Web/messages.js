const { db } = require('../../middleware/database')

/**
 * Delete a message by its id
 *
 * @param {number} id of the message to be deleted
 */
exports.deleteMessageById = async (id) => {
    try {
      await db.Contact_Web.delete({
        where: { id },
      });
    } catch (error) {
      console.error('Error deleting message:', error);
      throw new Error('Failed to delete message');
    }
  };

/**
 * Retrieve every messages from the database
 *
 * @returns messages objects
 */
exports.getAllMessages = async () => {
  try {
    const messages = await db.Contact_Web.findMany();
    return messages;
  } catch (error) {
    console.error('Error retrieving messages:', error);
    throw new Error('Failed to retrieve messages');
  }
};

/**
 * Find a message by its id
 *
 * @param {number} id of the message to be found
 * @returns the message if found
 */
exports.findById = id => {
  try {
    const message = db.Contact_Web.findUnique({ where: { id } });
    return message;
  } catch (error) {
    console.error('Error retrieving message by ID:', error);
    throw new Error('Failed to retrieve message by ID');
  }
};
