import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shatrunash_admin/services/authentication.service.dart';
import 'package:shatrunash_admin/widget_tree.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/util.dart';
import 'theme/theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(url: dotenv.env['SUPABASE_URL']!, anonKey: dotenv.env['SUPABASE_KEY']!);
  AuthenticationService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Ubuntu Mono", "Ubuntu");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Shatrunash Admin',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: const WidgetTree(),
    );
  }
}
