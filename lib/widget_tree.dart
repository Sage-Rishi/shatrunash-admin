import 'package:flutter/material.dart';
import 'package:shatrunash_admin/screens/auth/login_screen.dart';
import 'package:shatrunash_admin/screens/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final supabase = Supabase.instance.client;
  @override
  void initState() {
    _redirect();
    super.initState();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    try {
      final session = supabase.auth.currentSession;
      await supabase.auth.getUser(session?.accessToken);
      if (session == null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
      }
    } on AuthException catch (e) {
      print(e.message);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("lib/assets/logo.png", width: 50),
            const SizedBox(height: 20),
            const Text(
              "Shatrunash Admin Loading...",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
