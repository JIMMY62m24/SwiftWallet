import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> _favorites = [];
  static const String _storageKey = 'favorites';

  List<Contact> get favorites => _favorites;

  ContactProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_storageKey);
      if (favoritesJson != null) {
        _favorites = favoritesJson
            .map((json) => Contact.fromJson(jsonDecode(json)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson =
          _favorites.map((contact) => jsonEncode(contact.toJson())).toList();
      await prefs.setStringList(_storageKey, favoritesJson);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> addFavorite(Contact contact) async {
    if (!_favorites.any((f) => f.phoneNumber == contact.phoneNumber)) {
      _favorites.add(contact);
      notifyListeners();
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(String phoneNumber) async {
    _favorites.removeWhere((f) => f.phoneNumber == phoneNumber);
    notifyListeners();
    await _saveFavorites();
  }

  bool isFavorite(String phoneNumber) {
    return _favorites.any((f) => f.phoneNumber == phoneNumber);
  }
}
