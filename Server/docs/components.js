module.exports = {
  components: {
    schemas: {
      Item: {
        type: "object",
        properties: {
          name: {
            type: "string",
          },
          available: {
            type: "boolean",
          },
          price: {
            type: "float",
          },
          image: {
            type: "string",
          },
          description: {
            type: "string",
          },
          container: {
            $ref: "#/components/schemas/Container",
          },
        },
      },
      Container: {
        type: "object",
        properties: {
          organization: {
            $ref: "#/components/schemas/Organization",
          },
          containerMapping: {
            type: "string",
          },
          address: {
            type: "string",
          },
          city: {
            type: "string",
          },
          price: {
            type: "float",
          },
          width: {
            type: "float",
          },
          height: {
            type: "float",
          },
          designs: {
            type: "string",
          },
          informations: {
            type: "string",
          },
          latitude: {
            type: "float",
          },
          longitude: {
            type: "float",
          },
          items: {
            type: "array",
            items: {
              $ref: "#/components/schemas/Item",
            },
          },
          paid: {
            type: "boolean",
          },
          saveName: {
            type: "string",
          },
        },
      },
      Organization: {
        type: "object",
        properties: {
          name: {
            type: "string",
          },
          organizationtype: {
            type: "string",
          },
          contactInformation: {
            type: "string",
          },
          affiliateUsers: {
            type: "array",
            items: {
              $ref: "#/components/schemas/User_Web",
            },
          },
          containers: {
            type: "array",
            items: {
              $ref: "#/components/schemas/Container",
            },
          },
        },
      },
      Ticket: {
        type: "object",
        properties: {
          content: {
            type: "string",
          },
          title: {
            type: "string",
          },
          creatorId: {
            type: "string",
          },
          assignedId: {
            type: "string",
          },
          createdAt: {
            type: "integer",
            format: "date-time",
          },
          chatUid: {
            type: "string",
          },
          closed: {
            type: "boolean",
          },
        },
      },
      User_Web: {
        type: "object",
        required: ["email", "password"],
        properties: {
          email: {
            type: "string",
          },
          password: {
            type: "string",
          },
          firstName: {
            type: "string",
          },
          company: {
            type: "string",
          },
          token: {
            type: "string",
          },
          lastName: {
            type: "string",
          },
          confirmed: {
            type: "boolean",
          },
          organization: {
            $ref: "#/components/schemas/Organization",
          },
        },
      },
      Opinions_Web: {
        type: "object",
        properties: {
          firstName: {
            type: "string",
          },
          lastName: {
            type: "string",
          },
          email: {
            type: "string",
          },
          message: {
            type: "string",
          },
          mark: {
            type: "string",
          },
          date: {
            type: "integer",
            format: "date-time",
          },
        },
      },
      User_Mobile: {
        type: "object",
        required: ["email", "password"],
        properties: {
          email: {
            type: "string",
          },
          password: {
            type: "string",
          },
          firstName: {
            type: "string",
          },
          lastName: {
            type: "string",
          },
          mailVerification: {
            type: "boolean",
          },
          refreshToken: {
            type: "string",
          },
          locations: {
            $ref: "#/components/schemas/Location_Mobile",
          },
          notifications: {
            $ref: "#/components/schemas/Notifications_Mobile",
          },
        },
      },
      Location_Mobile: {
        type: "object",
        properties: {
          price: {
            type: "integer",
            format: "int32",
          },
          duration: {
            type: "integer",
            format: "date-time",
          },
          ended: {
            type: "boolean",
          },
          item: {
            $ref: "#/components/schemas/Item",
          },
        },
      },
      Notifications_Mobile: {
        type: "object",
        properties: {
          favoriteItemsAvailable: {
            type: "boolean",
          },
          endOfRenting: {
            type: "boolean",
          },
          newsOffersRisu: {
            type: "boolean",
          },
        },
      },
      Contact_Mobile: {
        type: "object",
        properties: {
          email: {
            type: "string",
          },
          message: {
            type: "string",
          },
          name: {
            type: "string",
          },
          createdAt: {
            type: "integer",
            format: "date-time",
          },
        },
      },
      Opinions_Mobile: {
        type: "object",
        properties: {
          userId: {
            type: "string",
          },
          comment: {
            type: "string",
          },
          note: {
            type: "string",
          },
          date: {
            type: "integer",
            format: "date-time",
          },
        },
      },
    },
  },
};
