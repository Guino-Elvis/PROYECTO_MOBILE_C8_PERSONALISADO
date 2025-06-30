class ConfigApi {
  static const String appName = "Import & Lion";
  static const String apiURL = "192.168.0.109:9090";
  static String buildUrl(String endpoint) {
    return 'http://$apiURL$endpoint';
  }
}
