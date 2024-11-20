class ConfigApi {
  static const String appName = "ROPA & GLAMOUR";
  static const String apiURL = "192.168.0.103:9090";
  static String buildUrl(String endpoint) {
    return 'http://$apiURL$endpoint';
  }
}
