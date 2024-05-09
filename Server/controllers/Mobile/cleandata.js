const favCtrl = require("./favorites")
const userCtrl = require("./user")
const ticketCtrl = require("../Common/tickets")
const rentCtrl = require("./rent")

/**
 * Clean user data before deleting it
 *
 * @param {*} userId of the user
 * @param {*} notificationsId of the notifications linked to the user
 */
exports.cleanUserData = async (userId, notificationsId) => {
    await favCtrl.cleanUserFavorite(userId);
    await userCtrl.cleanUserNotifications(notificationsId);
    await ticketCtrl.cleanMobileUserTickets(userId);
    await rentCtrl.returnAllUserRents(userId);
}