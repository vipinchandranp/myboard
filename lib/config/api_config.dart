class APIConfig {
  // Base API URL
  static String _rootURL = 'http://192.168.1.43:8080/myboard';

  // WebSocket URL
  static String _webSocketURL = 'ws://192.168.1.43:8080/myboard/websocket'; // Adjust according to your setup

  // Method to set the root API URL
  static void setRootURL(String rootURL) {
    _rootURL = rootURL;
  }

  // Method to get the root API URL
  static String getRootURL() {
    return _rootURL;
  }

  // Method to get the WebSocket URL
  static String getWebSocketUrl() {
    return _webSocketURL;
  }

  // Method to set the WebSocket URL
  static void setWebSocketURL(String webSocketURL) {
    _webSocketURL = webSocketURL;
  }
}
