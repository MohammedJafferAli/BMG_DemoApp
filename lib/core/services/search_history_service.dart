import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;

  static Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  static Future<void> addSearchTerm(String term) async {
    if (term.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    
    // Remove if already exists to avoid duplicates
    history.remove(term);
    
    // Add to beginning
    history.insert(0, term);
    
    // Keep only the most recent items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }
    
    await prefs.setStringList(_searchHistoryKey, history);
  }

  static Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  static Future<void> removeSearchTerm(String term) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    history.remove(term);
    await prefs.setStringList(_searchHistoryKey, history);
  }
}