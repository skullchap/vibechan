import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ServiceModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  Dio get dio => Dio();
  // ..interceptors.add(LogInterceptor(
  //   requestBody: true,
  //   responseBody: true,
  // ));
}
