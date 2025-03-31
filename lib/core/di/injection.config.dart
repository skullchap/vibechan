// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_riverpod/flutter_riverpod.dart' as _i729;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../data/repositories/fourchan_repository.dart' as _i313;
import '../data/sources/chan_data_source.dart' as _i932;
import '../data/sources/fourchan/fourchan_data_source.dart' as _i508;
import '../domain/repositories/board_repository.dart' as _i1048;
import '../domain/repositories/thread_repository.dart' as _i609;
import 'providers_module.dart' as _i770;
import 'service_module.dart' as _i180;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final serviceModule = _$ServiceModule();
    final providersModule = _$ProvidersModule();
    gh.singletonAsync<_i460.SharedPreferences>(() => serviceModule.prefs);
    gh.singleton<_i361.Dio>(() => serviceModule.dio);
    gh.lazySingleton<_i932.ChanDataSource>(
      () => _i508.FourChanDataSource(gh<_i361.Dio>()),
      instanceName: '4chan',
    );
    gh.lazySingletonAsync<_i313.FourChanRepository>(
      () async => _i313.FourChanRepository(
        gh<_i932.ChanDataSource>(instanceName: '4chan'),
        await getAsync<_i460.SharedPreferences>(),
      ),
      instanceName: '4chan',
    );
    gh.lazySingletonAsync<_i1048.BoardRepository>(
      () async => providersModule.provideBoardRepository(
        await getAsync<_i313.FourChanRepository>(instanceName: '4chan'),
      ),
      instanceName: '4chan',
    );
    gh.lazySingletonAsync<_i609.ThreadRepository>(
      () async => providersModule.provideThreadRepository(
        await getAsync<_i313.FourChanRepository>(instanceName: '4chan'),
      ),
      instanceName: '4chan',
    );
    gh.singletonAsync<_i729.ProviderContainer>(
      () async => providersModule.provideContainer(
        await getAsync<_i1048.BoardRepository>(instanceName: '4chan'),
        await getAsync<_i609.ThreadRepository>(instanceName: '4chan'),
      ),
    );
    return this;
  }
}

class _$ServiceModule extends _i180.ServiceModule {}

class _$ProvidersModule extends _i770.ProvidersModule {}
