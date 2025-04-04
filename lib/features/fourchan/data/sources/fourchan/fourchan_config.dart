import 'package:dio/dio.dart';

class FourChanConfig {
  static const String apiBaseUrl = 'https://a.4cdn.org';
  static const String mediaBaseUrl = 'https://i.4cdn.org';

  static const Map<String, String> defaultHeaders = {
    'User-Agent': 'VibeChan/1.0.0',
    'Accept': 'application/json',
  };

  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration minRequestInterval = Duration(milliseconds: 1000);

  static Options get defaultOptions => Options(
        headers: defaultHeaders,
        sendTimeout: defaultTimeout,
        receiveTimeout: defaultTimeout,
      );
}