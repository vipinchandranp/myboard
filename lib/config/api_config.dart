class APIConfig {

  //static String _rootURL = 'https://myboard-user-api.azurewebsites.net';
  static String _rootURL = 'http://localhost:8080';

  static void setRootURL(String rootURL) {
    _rootURL = rootURL;
  }

  static String getRootURL() {
    return _rootURL;
  }
}
