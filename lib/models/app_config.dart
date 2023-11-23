class AppConfig {
  late String registerEndpoint;
  late String locationEndpoint;
  late String imageEndpoint;
  late String loginEndPoint;
  late String deviceRegisterEndpoint;

  AppConfig({
    required this.loginEndPoint,
    required this.registerEndpoint,
    required this.locationEndpoint,
    required this.imageEndpoint,
    required this.deviceRegisterEndpoint,
  });

  factory AppConfig.initial() {
    return AppConfig(
      loginEndPoint: "https://example.com/login",
      registerEndpoint: "https://example.com/reg",
      locationEndpoint: "https://example.com/loc",
      imageEndpoint: "https://example.com/img",
      deviceRegisterEndpoint: "https://example.com/img",
    );
  }

  String getloginEndPoint() {
    return loginEndPoint;
  }

  String getregisterEndpoint() {
    return registerEndpoint;
  }

  String getlocationEndpoint() {
    return locationEndpoint;
  }

  String getimageEndpoint() {
    return imageEndpoint;
  }

  String getdeviceRegisterEndpoint() {
    return imageEndpoint;
  }

  void updateloginEndPoint(String newUrl) {
    loginEndPoint = newUrl;
  }

  void updateregisterEndpoint(String newUrl) {
    registerEndpoint = newUrl;
  }

  void updatelocationEndpoint(String newUrl) {
    locationEndpoint = newUrl;
  }

  void updateimageEndpoint(String newUrl) {
    imageEndpoint = newUrl;
  }

  void updatedeviceRegisterEndpoint(String newUrl) {
    imageEndpoint = newUrl;
  }
}
