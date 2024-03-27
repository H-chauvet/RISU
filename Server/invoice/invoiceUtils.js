/**
 * Format the date to human readable for emails
 *
 * @param {*} date of the mail
 * @returns the formatted date
 */
function formatDate(date) {
  const options = {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  };
  return date.toLocaleDateString("fr-FR", options);
}

/**
 * Draw a table on a document
 *
 * @param {*} doc the document
 * @param {*} tableData the data to be drew
 */
function drawTable(doc, tableData) {
  const startY = doc.y;
  const startX = doc.x;
  const cellPadding = 5;
  const fontSize = 12;
  const tableWidth = 500;

  const columnWidth = tableWidth / tableData[0].length;

  tableData.forEach((row, i) => {
    row.forEach((cell, j) => {
      doc
        .fontSize(fontSize)
        .text(
          cell,
          startX + j * columnWidth,
          startY + i * (fontSize + cellPadding),
          { width: columnWidth, align: "center" },
        );
    });
  });

  const tableHeight = tableData.length * (fontSize + cellPadding);

  doc.rect(startX, startY, tableWidth, tableHeight).stroke();
}

module.exports = {
  formatDate,
  drawTable,
};
