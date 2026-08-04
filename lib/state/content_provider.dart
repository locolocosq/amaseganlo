import 'package:flutter/foundation.dart';

import '../content/content_repository.dart';

enum ContentLoadState { loading, loaded, error }

/// Loads the curriculum once at app start and exposes it to the rest of the
/// app. A failed load still leaves the app usable (empty content, not a
/// crash) - see ContentRepository for per-file error handling.
class ContentProvider extends ChangeNotifier {
  final ContentRepository repository;
  ContentLoadState state = ContentLoadState.loading;

  ContentProvider({ContentRepository? repository}) : repository = repository ?? ContentRepository();

  Future<void> load() async {
    try {
      await repository.load();
      state = ContentLoadState.loaded;
    } catch (_) {
      state = ContentLoadState.error;
    }
    notifyListeners();
  }
}
