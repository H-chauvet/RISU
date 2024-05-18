const CryptoJS = require('crypto-js');

const key = CryptoJS.enc.Hex.parse('0123456789abcdef0123456789abcdef');
const iv = CryptoJS.enc.Hex.parse('abcdef9876543210abcdef9876543210');

function encrypt(text) {
  const encrypted = CryptoJS.AES.encrypt(text, key, { iv: iv }).toString();
  return encodeURIComponent(encrypted);
}

function decrypt(ciphertext) {
  const decodedCiphertext = decodeURIComponent(ciphertext);
  const bytes = CryptoJS.AES.decrypt(decodedCiphertext, key, { iv: iv });
  return bytes.toString(CryptoJS.enc.Utf8);
}

module.exports = { encrypt, decrypt };