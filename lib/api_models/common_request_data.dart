class CommonRequestData {
  final String url;
  final String method;
  final Map<String, String> headers;
  final dynamic body;
  final Map<String, String> queryParameters;

  CommonRequestData({
    required this.url,
    this.method = 'GET',
    this.headers = const {},
    this.body,
    this.queryParameters = const {},
  });

  // Method to convert the request data to a map for easier HTTP request handling
  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'method': method,
      'headers': headers,
      'body': body,
      'queryParameters': queryParameters,
    };
  }
}
