const mobileSignUp = require('./Mobile/auth/signup')
const mobileLogIn = require('./Mobile/auth/login')
const mobileMailVerification = require('./Mobile/auth/mailVerification')
const mobileTickets = require('./Mobile/contact/tickets')
const mobileAssignTicket = require('./Mobile/contact/assignedId')
const mobileChatUid = require('./Mobile/contact/chatUid')
const mobileContainerListAll = require('./Mobile/container/listAll')
const mobileContainerId = require('./Mobile/container/containerId')
const mobileContainerArticleList = require('./Mobile/container/articleList')
const mobileItemListAll = require('./Mobile/items/listAll')
const mobileItemId = require('./Mobile/items/itemId')
const mobileOpinion = require('./Mobile/opinion/opinion')
const mobileOpinionId = require('./Mobile/opinion/opinionId')
const mobileRentArticle = require('./Mobile/rent/article')
const mobileRentListAll = require('./Mobile/rent/listAll')
const mobileRentId = require('./Mobile/rent/rentId')
const mobileRentReturn = require('./Mobile/rent/returnRent')
const mobileRentInvoice = require('./Mobile/rent/invoice')
const mobileUserListAll = require('./Mobile/user/listAll')
const mobileUserPassword = require('./Mobile/user/password')
const mobileUserResetPassword = require('./Mobile/user/resetPassword')
const mobileUserUpdate = require('./Mobile/user/update')
const mobileUserId = require('./Mobile/user/userId')

const WebContact = require('./Web/contact/contact')
const WebContainerGet = require('./Web/container/get')
const WebContainerDelete = require('./Web/container/delete')
const WebContainerUpdate = require('./Web/container/update')
const WebContainerListAll = require('./Web/container/listAll')
const WebContainerCreate = require('./Web/container/create')
const WebFeedbacksPost = require('./Web/feedback/create')
const WebFeedbacksListAll = require('./Web/feedback/listAll')
const WebItemDelete = require('./Web/items/delete')
const WebItemUpdate = require('./Web/items/update')
const WebItemListAll = require('./Web/items/listAll')
const WebItemCreate = require('./Web/items/create')
const WebMessageList = require('./Web/messages/list')
const WebMessageDelete = require('./Web/messages/delete')
const WebPayment = require('./Web/payment/card-pay')
const WebUserConfirmedRegister = require('./Web/user/confirmed-register')
const WebUserDelete = require('./Web/user/delete')
const WebUserForgotPassword = require('./Web/user/forgot-password')
const WebUserGoogleLogin = require('./Web/user/google-login')
const WebUserListAll = require('./Web/user/listAll')
const WebUserLogin = require('./Web/user/login')
const WebUserPrivacy = require('./Web/user/privacy')
const WebUserRegisterConfirmation = require('./Web/user/register-confirmation')
const WebUserRegister = require('./Web/user/register')
const WebUserUpdateCompany = require('./Web/user/update-company')
const WebUserUpdateDetails = require('./Web/user/update-details')
const WebUserUpdateMail = require('./Web/user/update-mail')
const WebUserUpdatePasswordEmail = require('./Web/user/update-password-email')
const WebUserUpdatePassword = require('./Web/user/update-password')
const WebUserDetails = require('./Web/user/userdetails')

module.exports = {
    paths: {
        '/api/mobile/auth/signup': {
            ...mobileSignUp
        },
        '/api/mobile/auth/login': {
            ...mobileLogIn
        },
        '/api/mobile/auth/mailVerification': {
            ...mobileMailVerification
        },
        '/api/mobile/ticket': {
            ...mobileTickets
        },
        '/api/mobile/ticket/:assignedId': {
            ...mobileAssignTicket
        },
        '/api/mobile/ticket/:chatUid' : {
            ...mobileChatUid
        },
        '/api/mobile/container/listAll': {
            ...mobileContainerListAll
        },
        '/api/mobile/container/:containerId': {
            ...mobileContainerId
        },
        '/api/mobile/container/:containerId/articlelist': {
            ...mobileContainerArticleList
        },
        '/api/mobile/article/listAll': {
            ...mobileItemListAll
        },
        '/api/mobile/article/:articleId': {
            ...mobileItemId
        },
        '/api/mobile/opinion/': {
            ...mobileOpinion
        },
        '/api/mobile/opinion/:opinionId': {
            ...mobileOpinionId
        },
        '/api/mobile/rent/article': {
            ...mobileRentArticle
        },
        '/api/mobile/rent/listAll': {
            ...mobileRentListAll
        },
        '/api/mobile/rent/:rentId': {
            ...mobileRentId
        },
        '/api/mobile/rent/:rentId/return': {
            ...mobileRentReturn
        },
        '/api/mobile/rent/:locationId/invoice' : {
            ...mobileRentInvoice
        },
        '/api/mobile/user/listAll': {
            ...mobileUserListAll
        },
        '/api/mobile/user/password': {
            ...mobileUserPassword
        },
        '/api/mobile/user/resetPassword': {
            ...mobileUserResetPassword
        },
        '/api/mobile/user/:userId': {
            ...mobileUserId
        },
        '/api/mobile/user/': {
            ...mobileUserUpdate
        },
        '/api/contact': {
            ...WebContact
        },
        '/api/container/get': {
            ...WebContainerGet
        },
        '/api/container/delete': {
            ...WebContainerDelete
        },
        '/api/container/create': {
            ...WebContainerCreate
        },
        '/api/container/update': {
            ...WebContainerUpdate
        },
        '/api/container/listAll': {
            ...WebContainerListAll
        },
        '/api/feedbacks/create': {
            ...WebFeedbacksPost
        },
        '/api/feedbacks/listAll': {
            ...WebFeedbacksListAll
        },
        '/api/items/listAll': {
            ...WebItemListAll
        },
        '/api/items/create': {
            ...WebItemCreate
        },
        '/api/items/delete': {
            ...WebItemDelete
        },
        '/api/items/update': {
            ...WebItemUpdate
        },
        '/api/messages/list': {
            ...WebMessageList
        },
        '/api/messages/delete': {
            ...WebMessageDelete
        },
        '/api/payment/card-pay': {
            ...WebPayment
        },
        '/api/auth/login': {
            ...WebUserLogin
        },
        '/api/auth/google-login': {
            ...WebUserGoogleLogin
        },
        '/api/auth/register': {
            ...WebUserRegister
        },
        '/api/auth/forgot-password': {
            ...WebUserForgotPassword
        },
        '/api/auth/update-password': {
            ...WebUserForgotPassword
        },
        '/api/auth/register-confirmation': {
            ...WebUserRegisterConfirmation
        },
        '/api/auth/confirmed-register': {
            ...WebUserConfirmedRegister
        },
        '/api/auth/privacy': {
            ...WebUserPrivacy
        },
        '/api/auth/listAll': {
            ...WebUserListAll
        },
        '/api/auth/update-details/:email/': {
            ...WebUserUpdateDetails
        },
        '/api/auth/update-mail': {
            ...WebUserUpdateMail
        },
        '/api/auth/update-company/:email': {
            ...WebUserUpdateCompany
        },
        '/api/auth/update-password/:email': {
            ...WebUserUpdatePasswordEmail
        },
    }
}
