import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart'; // generated file

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // Do not register SharedPreferences or Dio here – let the generated code handle it.
  // IMPORTANT: await the initialization to ensure all futures are resolved
  await getIt.init();
}
