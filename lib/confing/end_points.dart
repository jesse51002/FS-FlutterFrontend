class EndPoints {
  static String baseUrl = "http://192.168.29.236:8000/hairstyle_creation";

  //  This is the link for Jesse Musa to use to test (dont delete)
  // static String baseUrl = "http://10.0.2.2:8000/hairstyle_creation";

  Uri getStarted() {
    return Uri.parse("$baseUrl/start");
  }

  Uri hairStylePreset({required String eventId}) {
    return Uri.parse("$baseUrl/hairstyle_presets?eventid=$eventId");
  }
}
