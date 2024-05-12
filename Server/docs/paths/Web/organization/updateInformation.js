module.exports = {
    put: {
      tags: ["Web", "Organization"],
      summary: "Update organization's information in the database",
      description: "Update a new organization's information with the body data",
      operationId: "WebOrganizationInformationUpdate",
      consumes: ["application/json"],
      produces: ["application/json"],
      parameters: [
        {
            name: 'contactInformation',
            description: 'the new contactInformation for the organization',
            in: 'body',
            schema : {
                $ref: "#/components/schemas/Organization"
            }
        },
      ],
      responses: {
        200: {
          description: 'OK',
          content : {
            schema: {
                $ref : "#/components/schemas/Organization"
            }
          }
        },
        400: {
            description: "Error occured",
            content: {
                "application/json": {
                    example: "Id and contactInformation are required"
                }
            }
        }
      }
    }
  }