import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      debugPrint("🔥 Firebase Initialized Successfully");
    } catch (e) {
      debugPrint("❌ Firebase Initialization Failed: $e");
    }
  }
}
