module.exports = {
  components: {
    schemas: {
      User: {
        type: "object",
        properties: {
          email: {
            type: "string",
          },
        },
      },
      UserInfo: {
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
      UserWithUuid: {
        type: "object",
        properties: {
          uuid: {
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
