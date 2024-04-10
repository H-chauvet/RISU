const fs = require("fs");
const PDFDocument = require("pdfkit");

/**
 * Create an Invoice in pdf format for a rent
 *
 * @param {*} invoice the invoice data
 * @returns Promise to wait the invoice creation
 */
async function createInvoice(invoice) {
  return new Promise((resolve, reject) => {
    let doc = new PDFDocument({ size: "A4", margin: 50 });

    generateHeader(doc);
    generateCustomerInformation(doc, invoice);
    generateInvoiceTable(doc, invoice);
    generateFooter(doc);

    const buffers = [];
    doc.on("data", buffers.push.bind(buffers));
    doc.on("end", () => {
      const pdfBytes = Buffer.concat(buffers);
      resolve(pdfBytes);
    });
    doc.on("error", (error) => {
      reject(error);
    });

    doc.end();
  });
}

/**
 * Generate invoice Header
 *
 * @param {*} doc the invoice file
 */
function generateHeader(doc) {
  doc
    .image("assets/logo.png", 50, 45, { width: 50 })
    .fillColor("#444444")
    .fontSize(10)
    .text("RISU", 200, 50, { align: "right" })
    .text("14-16 Rue Voltaire", 200, 65, { align: "right" })
    .text("94270 Le Kremlin-Bicêtre, France", 200, 80, { align: "right" })
    .moveDown();
}

/**
 * Generate the customer information part on the invoice
 *
 * @param {*} doc the invoice file
 * @param {*} invoice the invoice data
 */
function generateCustomerInformation(doc, invoice) {
  doc.fillColor("#444444").fontSize(20).text("Facture", 50, 160);

  generateHr(doc, 185);

  const customerInformationTop = 200;

  doc
    .fontSize(10)
    .text("Client : ", 50, customerInformationTop)
    .font("Helvetica-Bold")
    .text(invoice.shipping.name, 150, customerInformationTop)
    .font("Helvetica")
    .text("Date de facturation :", 50, customerInformationTop + 15)
    .text(formatDate(new Date()), 150, customerInformationTop + 15)
    .text("Montant total :", 50, customerInformationTop + 30)
    .text(
      formatCurrency(invoice.subtotal - invoice.paid),
      150,
      customerInformationTop + 30,
    )
    .text("Facturé par :", 50, customerInformationTop + 45)
    .text("Risu", 150, customerInformationTop + 45)

    .font("Helvetica")
    .text(invoice.shipping.address, 300, customerInformationTop + 15)
    .text(
      invoice.shipping.city + invoice.shipping.state + invoice.shipping.country,
      300,
      customerInformationTop + 30,
    )
    .moveDown();

  generateHr(doc, 267);
}

/**
 * Generate the invoice table
 *
 * @param {*} doc the invoice file
 * @param {*} invoice the invoice data
 */
function generateInvoiceTable(doc, invoice) {
  let i;
  const invoiceTableTop = 330;

  doc.font("Helvetica-Bold");
  generateTableRow(
    doc,
    invoiceTableTop,
    "Article",
    "Prix unitaire",
    "Quantité",
    "Prix total HT",
    "Prix total TTC",
  );
  generateHr(doc, invoiceTableTop + 20);
  doc.font("Helvetica");

  for (i = 0; i < invoice.items.length; i++) {
    const item = invoice.items[i];
    const position = invoiceTableTop + (i + 1) * 30;
    generateTableRow(
      doc,
      position,
      item.item,
      formatCurrency(item.amount / item.quantity),
      item.quantity,
      formatCurrency(item.amount),
      formatCurrency(item.amount),
    );

    generateHr(doc, position + 20);
  }

  const subtotalPosition = invoiceTableTop + (i + 1) * 30;
  generateTableRow(
    doc,
    subtotalPosition,
    "",
    "",
    "",
    "Total",
    formatCurrency(invoice.subtotal),
  );

  const paidToDatePosition = subtotalPosition + 20;
  const duePosition = paidToDatePosition + 25;
  doc.font("Helvetica-Bold");
  generateTableRow(
    doc,
    duePosition,
    "",
    "",
    "",
    "Payé à ce jour",
    formatCurrency(invoice.subtotal),
  );
  doc.font("Helvetica");
}

/**
 * Generate footer for the invoice
 *
 * @param {*} doc invoice file
 */
function generateFooter(doc) {
  console.log("generateFooter");
  doc.fontSize(10).text("Risu vous remercie pour votre confiance.", 50, 780, {
    align: "center",
    width: 500,
  });
}

/**
 * Generate the invoice informations for the table
 *
 * @param {*} doc the invoice file
 * @param {*} y the height
 * @param {*} item the name of the item
 * @param {*} unitCost the cost of the item
 * @param {*} quantity the quantity of the item
 * @param {*} totalHT the cost without taxes of the item
 * @param {*} totalTTC the cost total of the item
 */
function generateTableRow(doc, y, item, unitCost, quantity, totalHT, totalTTC) {
  console.log("generateTableRow");
  doc
    .fontSize(10)
    .text(item, 50, y)
    .text(unitCost, 150, y)
    .text(quantity, 280, y)
    .text(totalHT, 370, y)
    .text(totalTTC, 0, y, { align: "right" });
}

/**
 * Generate a hr similar to html
 *
 * @param {*} doc the invoice file
 * @param {*} y the height where to generate the hr
 */
function generateHr(doc, y) {
  console.log("generateHr");
  doc.strokeColor("#aaaaaa").lineWidth(1).moveTo(50, y).lineTo(550, y).stroke();
}

/**
 * Format the currency to human readable with cents
 *
 * @param {number} cents
 * @returns human readable cents
 */
function formatCurrency(cents) {
  console.log("formatCurrency");
  return "€" + cents.toFixed(2);
}

/**
 * Format the date to human readeable
 *
 * @param {number} date
 * @returns human readable date in string
 */
function formatDate(date) {
  console.log("formatDate");
  const day = date.getDate();
  const month = date.getMonth() + 1;
  const year = date.getFullYear();

  return day + "/" + month + "/" + year;
}

module.exports = {
  createInvoice,
};
