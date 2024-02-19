function formatDate(date) {
  const day = date.getDate();
  const month = date.getMonth() + 1; // +1 because month begin at 0
  const year = date.getFullYear();
  const hours = date.getHours();
  const minutes = date.getMinutes();

  const formattedDate = `${day}/${month}/${year} ${hours}:${minutes}`;

  return formattedDate;
}

function drawTable(doc, tableData) {
  const startY = doc.y;
  const startX = doc.x;
  const cellPadding = 5;
  const fontSize = 12;
  const tableWidth = 500;

  const columnWidth = tableWidth / tableData[0].length;

  tableData.forEach((row, i) => {
    row.forEach((cell, j) => {
      doc.fontSize(fontSize).text(cell, startX + j * columnWidth, startY + i * (fontSize + cellPadding), { width: columnWidth, align: 'center' });
    });
  });

  const tableHeight = tableData.length * (fontSize + cellPadding);

  doc.rect(startX, startY, tableWidth, tableHeight).stroke();
}

module.exports = {
    formatDate,
    drawTable
};
