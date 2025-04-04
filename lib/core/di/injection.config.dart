// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/fourchan/data/repositories/fourchan_repository.dart'
    as _i1063;
import '../../features/fourchan/data/sources/fourchan/chan_data_source.dart'
    as _i394;
import '../../features/fourchan/data/sources/fourchan/fourchan_data_source.dart'
    as _i347;
import '../../features/fourchan/domain/repositories/board_repository.dart'
    as _i736;
import '../../features/fourchan/domain/repositories/thread_repository.dart'
    as _i481;
import '../../features/hackernews/data/datasources/hackernews_api_client.dart'
    as _i765;
import '../../features/hackernews/data/repositories/hackernews_repository_impl.dart'
    as _i321;
import '../../features/hackernews/domain/repositories/hackernews_repository.dart'
    as _i117;
import '../../features/lobsters/data/datasources/lobsters_api_client.dart'
    as _i470;
import '../../features/lobsters/data/repositories/lobsters_repository_impl.dart'
    as _i934;
import '../../features/lobsters/domain/repositories/lobsters_repository.dart'
    as _i756;
import '../services/theme_persistence_service.dart' as _i565;
import 'providers_module.dart' as _i770;
import 'service_module.dart' as _i180;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final serviceModule = _$ServiceModule();
    final providersModule = _$ProvidersModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => serviceModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => serviceModule.dio);
    gh.singleton<_i565.ThemePersistenceService>(
      () => _i565.ThemePersistenceService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i394.ChanDataSource>(
      () => _i347.FourChanDataSource(gh<_i361.Dio>()),
      instanceName: '4chan',
    );
    gh.factory<_i765.HackerNewsApiClient>(
      () => _i765.HackerNewsApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i470.LobstersApiClient>(
      () => _i470.LobstersApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i756.LobstersRepository>(
      () => _i934.LobstersRepositoryImpl(gh<_i470.LobstersApiClient>()),
    );
    gh.lazySingleton<_i117.HackerNewsRepository>(
      () => _i321.HackerNewsRepositoryImpl(gh<_i765.HackerNewsApiClient>()),
    );
    gh.lazySingleton<_i1063.FourChanRepository>(
      () => _i1063.FourChanRepository(
        gh<_i394.ChanDataSource>(instanceName: '4chan'),
        gh<_i460.SharedPreferences>(),
      ),
      instanceName: '4chan',
    );
    gh.lazySingleton<_i736.BoardRepository>(
      () => providersModule.provideBoardRepository(
        gh<_i1063.FourChanRepository>(instanceName: '4chan'),
      ),
      instanceName: '4chan',
    );
    gh.lazySingleton<_i481.ThreadRepository>(
      () => providersModule.provideThreadRepository(
        gh<_i1063.FourChanRepository>(instanceName: '4chan'),
      ),
      instanceName: '4chan',
    );
    return this;
  }
}

class _$ServiceModule extends _i180.ServiceModule {}

class _$ProvidersModule extends _i770.ProvidersModule {}
