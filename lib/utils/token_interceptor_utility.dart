import 'package:http/http.dart' as http;
import 'package:myboard/utils/token_interceptor_client.dart';

class TokenInterceptorUtility {
  static http.Client createClientWithTokenInterceptor(String token) {
    final innerClient = http.Client();
    return TokenInterceptorClient(token, innerClient);
  }
}
