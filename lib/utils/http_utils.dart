import 'package:http/http.dart' as http;

class TokenHttpClient extends http.BaseClient {
  final String token;
  final http.Client _inner;

  TokenHttpClient(this.token, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $token';
    return _inner.send(request);
  }
}

http.Client createClientWithTokenInterceptor(String token) {
  var client = http.Client();
  return TokenHttpClient(token, client);
}
