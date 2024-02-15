const { db } = require("../middleware/database");

exports.deleteMessageById = async (id) => {
  try {
    await db.Contact.delete({
      where: { id },
    });
  } catch (error) {
    console.error("Error deleting message:", error);
    throw new Error("Failed to delete message");
  }
};

exports.getAllMessages = async () => {
  try {
    const messages = await db.Contact.findMany();
    return messages;
  } catch (error) {
    console.error("Error retrieving messages:", error);
    throw new Error("Failed to retrieve messages");
  }
};

exports.findById = (id) => {
  try {
    const message = db.Contact.findUnique({ where: { id } });
    return message;
  } catch (error) {
    console.error("Error retrieving message by ID:", error);
    throw new Error("Failed to retrieve message by ID");
  }
};
