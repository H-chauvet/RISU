const { formatDate, drawTable } = require('../../routes/Mobile/utils.js');

describe('Invoice Functions', () => {
  describe('formatDate', () => {
    it('should format the date correctly', () => {
      const date = new Date('2022-02-22T10:30:00');
      const formattedDate = formatDate(date);
      expect(formattedDate).toEqual('22/02/2022 10:30');
    });
  });
});
