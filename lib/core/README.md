# Core Layer

This folder contains the Clean Architecture core of VibeChan.

## Structure:

- `domain/models/` → App-wide entities (Board, Thread, Post, etc.)
- `domain/repositories/` → Abstract interfaces (BoardRepository, etc.)
- `data/sources/` → Remote or local APIs (FourChanDataSource, etc.)
- `data/repositories/` → Implementations of domain interfaces
- `di/` → Dependency Injection setup with injectable/get_it

## Adding a New Data Source (e.g. Lobsters)
1. Create new source under `data/sources/lobsters/`
2. Implement `chan_data_source.dart` for Lobsters
3. Add to DI in `service_module.dart`
4. Done. Vibecode away.

