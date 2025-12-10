// lib/provider/scanner_provider.dart
import 'package:flutter/foundation.dart';

class ScannerProvider extends ChangeNotifier {
  int _selectedTab = 0; // 0 = manual url, 1 = QR scanner

  int get selectedTab => _selectedTab;

  void changeTab(int idx) {
    if (_selectedTab == idx) return;
    _selectedTab = idx;
    notifyListeners();
  }

  // placeholder for scan history and other state
  final List<Map<String, String>> _history = [];

  List<Map<String, String>> get history => List.unmodifiable(_history);

  void addHistoryEntry(String url, String status) {
    _history.insert(0, {
      'url': url,
      'status': status,
      'time': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
