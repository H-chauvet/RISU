const favCtrl = require("./favorites");
const userCtrl = require("./user");
const ticketCtrl = require("../Common/tickets");
const rentCtrl = require("./rent");

/**
 * Clean user data before deleting his account
 *
 * @param {*} userId of the user
 * @param {*} notificationsId of the notifications linked to the user
 */
exports.cleanUserData = async (res, userId, notificationsId) => {
  await favCtrl.cleanUserFavorite(userId);
  await userCtrl.cleanUserNotifications(notificationsId);
  await ticketCtrl.cleanMobileUserTickets(res, userId);
  await rentCtrl.returnAllUserRents(userId);
};
