import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/domain/entities/app_user_entity.dart';

class MemberSelectionViewModel extends Notifier<AsyncValue<List<AppUserEntity>>> {
  Timer? _debounceTimer;

  @override
  AsyncValue<List<AppUserEntity>> build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const AsyncData([]);
  }

  void onQueryChanged(String email) {
    _debounceTimer?.cancel();
    
    // Start searching as soon as 3 characters are typed
    if (email.isEmpty || email.length < 3) {
      state = const AsyncData([]);
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(email);
    });
  }

  Future<void> _performSearch(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final results = await ref.read(authUseCasesProvider).searchUsersByEmail(email);
      final currentUser = ref.read(authRepositoryProvider).currentUser;
      
      // Filter out the current user from suggestions
      return results.where((u) => u.uid != currentUser?.uid).toList();
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    state = const AsyncData([]);
  }
}

final memberSelectionViewModelProvider =
    NotifierProvider<MemberSelectionViewModel, AsyncValue<List<AppUserEntity>>>(
  MemberSelectionViewModel.new,
);
