import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DraftState {
  final String title;
  final String description;

  DraftState({this.title = '', this.description = ''});
}

class DraftNotifier extends StateNotifier<DraftState> {
  static const String _keyTitle = 'draft_title';
  static const String _keyDesc = 'draft_description';

  DraftNotifier() : super(DraftState()) {
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    state = DraftState(
      title: prefs.getString(_keyTitle) ?? '',
      description: prefs.getString(_keyDesc) ?? '',
    );
  }

  Future<void> updateTitle(String title) async {
    state = DraftState(title: title, description: state.description);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTitle, title);
  }

  Future<void> updateDescription(String desc) async {
    state = DraftState(title: state.title, description: desc);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDesc, desc);
  }

  Future<void> clearDraft() async {
    state = DraftState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTitle);
    await prefs.remove(_keyDesc);
  }
}

final draftProvider = StateNotifierProvider<DraftNotifier, DraftState>((ref) {
  return DraftNotifier();
});
