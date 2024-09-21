class CommonResponseData {
  final int statusCode;
  final Map<String, String> headers;
  final dynamic body;

  CommonResponseData({
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  // Method to create a CommonResponseData instance from a map
  factory CommonResponseData.fromMap(Map<String, dynamic> map) {
    return CommonResponseData(
      statusCode: map['statusCode'] as int,
      headers: Map<String, String>.from(map['headers']),
      body: map['body'],
    );
  }

  // Method to convert the response data to a map for easier handling
  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'headers': headers,
      'body': body,
    };
  }
}
