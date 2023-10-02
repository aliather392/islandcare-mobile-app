class AppUrl {
  static String localBaseURL = "http://192.168.10.183:4522";
  static String webBaseURL = "https://islandcare.bm";
  static String webStorageUrl = "$webBaseURL/storage";
  static String localStorageUrl = "$localBaseURL/storage";
  static String localImageUser = "assets/images/user.png";
  static String services = "$webBaseURL/api/services";
  static String bankName = "$webBaseURL/api/bank-names";
  static String sampleImage = "$webBaseURL/storage/avatar/sample.jpg";

  static String getNotification = "$webBaseURL/api/get-notifications";
}

class SessionUrl {
  static String login = "${AppUrl.webBaseURL}/api/login";
  static String register = "${AppUrl.webBaseURL}/api/register";
  static String signup = "${AppUrl.webBaseURL}/api/signup";
  static String emailVerification = "${AppUrl.webBaseURL}/api/email-verification";
}

class CareGiverUrl {
  static String serviceProviderProfile = "${AppUrl.webBaseURL}/api/service-provider-profile";
  static String serviceProviderProfileReviews = "${AppUrl.webBaseURL}/api/provider-reviews";
  static String serviceProviderDashboard = "${AppUrl.webBaseURL}/api/service-provider-dashboard";
  static String serviceProviderBankDetails = "${AppUrl.webBaseURL}/api/service-receiver-bank-details";
  static String serviceProviderAllJob = "${AppUrl.webBaseURL}/api/service-provider-my-jobs";
  static String serviceProviderJobDetail = "${AppUrl.webBaseURL}/api/service-provider-job-detail";
  static String addServiceProviderBank = "${AppUrl.webBaseURL}/api/add-service-receiver-bank";

  static String serviceProviderJobApply = "${AppUrl.webBaseURL}/api/service-provider-job-apply";
}

// service-receiver-subscribe
class CareReceiverURl {
  static String serviceReceiverApplicantDetails = "${AppUrl.webBaseURL}/api/service-receiver-my-application-applicant-details";
  static String serviceReceiverApplicantionApplicantsAccept = "${AppUrl.webBaseURL}/api/service-receiver-my-application-applicant-details-approve";
  static String serviceReceiverApplicantionApplicants = "${AppUrl.webBaseURL}/api/service-receiver-my-application-applicants";
  static String serviceReceiverBankDetails = "${AppUrl.webBaseURL}/api/service-receiver-bank-details";
  static String addServiceReceiverBank = "${AppUrl.webBaseURL}/api/add-service-receiver-bank";
  static String serviceReceiverJobCompleted = "${AppUrl.webBaseURL}/api/service-receiver-job-completed";
  static String serviceReceiverHireCandicate = "${AppUrl.webBaseURL}/api/service-receiver-hire-candicate";
  static String serviceReceiverDashboard = "${AppUrl.webBaseURL}/api/service-receiver-dashboard";
  static String serviceReceiverAddFavourite = "${AppUrl.webBaseURL}/api/service-receiver-add-to-favourite";
  static String serviceReceiverFavourite = "${AppUrl.webBaseURL}/api/service-receiver-favourites";
  static String serviceReceiverProfile = "${AppUrl.webBaseURL}/api/service-receiver-profile";
  static String serviceReceiverApplication = "${AppUrl.webBaseURL}/api/service-receiver-my-application";

  static String serviceReceiverSeniorCareJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-seniorcare-job-create";
  static String serviceReceiverPetCareJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-petcare-job-create";
  static String serviceReceiverHouseKeepingJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-housekeeping-job-create";
  static String serviceReceiverLearningJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-learning-job-create";
  static String serviceReceiverSchoolCampJobCreater = "${AppUrl.webBaseURL}/api/service-receiver-schoolcamp-job-create";

  static String serviceReceiverAddCreditCards = "${AppUrl.webBaseURL}/api/service-receiver-add-credit-cards";
  static String serviceReceiverGetCreditCards = "${AppUrl.webBaseURL}/api/service-receiver-get-credit-cards";
  static String serviceReceiverJobBoardDetail = "${AppUrl.webBaseURL}/api/service-receiver-job-board-detail";
  static String serviceReceiverJobBoard = "${AppUrl.webBaseURL}/api/service-receiver-job-board";
  static String serviceReceiverProviderDetail = "${AppUrl.webBaseURL}/api/service-receiver-provider-detail";
  static String serviceReceiverAdd = "${AppUrl.webBaseURL}/api/service-receiver-rating";

  static String serviceReceiverUnSubscribe = "${AppUrl.webBaseURL}/api/service-receiver-unsubscribe";
  static String serviceSubscribe = "${AppUrl.webBaseURL}/api/subscription-package";
  static String serviceReceiverSubscribePackage = "${AppUrl.webBaseURL}/api/service-receiver-subscribe";
}

class ChatUrl {
  static String serviceReceiverChat = "${AppUrl.webBaseURL}/api/service-receiver-chat";
  static String serviceReceiverSendMessage = "${AppUrl.webBaseURL}/api/service-receiver-send-message";
  static String serviceReceiverChatMessageStatus = "${AppUrl.webBaseURL}/api/service-receiver-message-status";
  static String serviceProviderChat = "${AppUrl.webBaseURL}/api/service-provider-chat";
  static String serviceProviderSendMessage = "${AppUrl.webBaseURL}/api/service-provider-send-message";
  static String serviceProviderChatMessageStatus = "${AppUrl.webBaseURL}/api/service-provider-message-status";
}
