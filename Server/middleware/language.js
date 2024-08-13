/**
 * Set the language of the server response
 * depending on the language of the asking user
 *
 * @param {*} user the user object
 */
function setServerLanguage(req, user) {
    if (user && user.language) {
        req.setLocale(user.language);
    } else {
        req.setLocale('en');
    }
}

module.exports = { setServerLanguage };
