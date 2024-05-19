import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shatrunash_admin/screens/auth/login_screen.dart';
import 'package:shatrunash_admin/widget_tree.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AuthenticationService {
  var supabase = Supabase.instance.client;
  late StreamSubscription<AuthState> _authStateChangesSubscription;

  AuthenticationService() {
    _authStateChangesSubscription = supabase.auth.onAuthStateChange.listen((data) {
      var authState = data.event.name;
      if (authState == "signedIn" || authState == "tokenRefreshed") {
        navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const WidgetTree()), (route) => false);
      } else if (authState == "signedOut" || authState == "userUpdated" || authState == "passwordRecovery") {
        navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
        print("User signed out");
      } else {
        print("Auth state changed to: $authState");
      }
    });
  }

  void dispose() {
    _authStateChangesSubscription.cancel();
  }
}
