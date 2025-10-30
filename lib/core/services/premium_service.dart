import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PremiumService {
  static const String _premiumKey = 'isPremium';
  static PremiumService? _instance;
  static PremiumService get instance => _instance ??= PremiumService._internal();
  
  PremiumService._internal();
  
  bool _isPremium = false;
  bool get isPremium => _isPremium;
  
  /// Initialize premium status from SharedPreferences
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isPremium = prefs.getBool(_premiumKey) ?? false;
      debugPrint('🔓 Premium status initialized: $_isPremium');
    } catch (e) {
      debugPrint('❌ Error initializing premium status: $e');
      _isPremium = false;
    }
  }
  
  /// Set premium status to true (when purchase is successful)
  Future<void> setPremiumStatus(bool isPremium) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_premiumKey, isPremium);
      _isPremium = isPremium;
      debugPrint('🔓 Premium status updated: $isPremium');
    } catch (e) {
      debugPrint('❌ Error updating premium status: $e');
    }
  }
  
  /// Enable premium (called when purchase is successful)
  Future<void> enablePremium() async {
    await setPremiumStatus(true);
  }
  
  /// Disable premium (called when subscription expires or is cancelled)
  Future<void> disablePremium() async {
    await setPremiumStatus(false);
  }
  
  /// Check if user has premium access
  bool hasPremiumAccess() {
    return _isPremium;
  }
  
  /// Clear premium status (for logout)
  Future<void> clearPremiumStatus() async {
    await setPremiumStatus(false);
  }
}
