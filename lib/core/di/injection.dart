import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart'; // generated file
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
  // Do not register SharedPreferences or Dio here – let the generated code handle it.
  await getIt.init();
}
