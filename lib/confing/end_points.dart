class EndPoints {
  static String baseUrl = "http://192.168.29.236:8000/hairstyle_creation";

  Uri getStarted() {
    return Uri.parse("$baseUrl/start");
  }

  Uri hairStylePreset({required String eventId}) {
    return Uri.parse("$baseUrl/hairstyle_presets?eventid=$eventId");
  }
}
