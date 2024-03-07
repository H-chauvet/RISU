module.exports = {
  components: {
    schemas: {
      User: {
        type: "object",
        properties: {
          email: {
            type: "string",
          },
          password: {
            type: "string",
          },
        },
      },
    },
  },
};
