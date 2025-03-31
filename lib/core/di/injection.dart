import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';
import 'service_module.dart';
import '../data/sources/chan_data_source.dart';
import '../data/sources/fourchan/fourchan_data_source.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // Initialize third-party services
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  final dio = Dio();
  getIt.registerSingleton<Dio>(dio);

  // Register ChanDataSource
  getIt.registerLazySingleton<ChanDataSource>(
    () => FourChanDataSource(getIt<Dio>()),
    instanceName: '4chan',
  );

  // Initialize injectable
  await getIt.init();
}