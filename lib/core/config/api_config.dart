class ApiConfig {
  static const String localhost = "http://192.168.1.71:5000";
  static const String devServerUrl = "https://gis-lrs.vercel.app";
  static const String apiUrl = "/api";
  // static const String baseUrl = devServerUrl + apiUrl;
  static const String baseUrl = localhost + apiUrl;

  static const String loginUrl = "/login";

  static const String userUrl = "/user";
  static const String userUpdateUrl = "/update-user";
  static const String userImageUrl = "/user-image";
  static const String frontCitizenshipImageUrl = "/user-front-image";
  static const String backCitizenshipImageUrl = "/user-back-image";

  static const String landUrl = "/land";
  static const String addLandUrl = "/add-land";
  static const String userLandsUrl = "/user-lands";
  static const String saleLandsUrl = "/land-sale";
  static const String individualSaleLandsUrl = "/individual";
  static const String requestToBuySaleLandsUrl = "/request-land-buy";
  static const String acceptToBuySaleLandsUrl = "/approve-land-buyer";
  static const String rejectToBuySaleLandsUrl = "/reject-land-buyer";
  static const String ownedRequestedSaleLandsUrl = "/requested";
  static const String ownedAcceptedSaleLandsUrl = "/accepted";
  static const String ownedRejectedSaleLandsUrl = "/rejected";
  static const String geoJSONDataUrl = "/geoJSON";
}
