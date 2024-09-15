const nodemailer = require("nodemailer");

let transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false,
  auth: {
    user: process.env.MAIL_ADDRESS,
    pass: process.env.MAIL_PASS,
  },
});

/**
 * Send email
 *
 * @param {*} mail mail object
 */
function sendMail(mail) {
  try {
    transporter.sendMail(mail, (error, info, next) => {
      if (error) {
        console.log(error);
      }
    });
  } catch (err) {
    throw err;
  }
}

module.exports = { sendMail };
