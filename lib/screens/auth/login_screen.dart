import 'package:flutter/material.dart';
import 'package:shatrunash_admin/screens/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loginLoading = false;
  bool hidden = true;

  //Controllers and Keys
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  //Regexes
  final emailRegex = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
  //Widget Build
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              SizedBox(
                height: 100,
                width: width,
                child: Image.asset("lib/assets/logo.png"),
              ),
              loginBanner(height),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  } else if (!emailRegex.hasMatch(value)) {
                    return "Invalid email";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                ),
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                obscureText: hidden,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    icon: Icon(hidden ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        hidden = !hidden;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(fixedSize: Size(width, 50)),
                onPressed: () => login(),
                child: loginLoading ? const CircularProgressIndicator.adaptive() : const Text("Login as Admin"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded loginBanner(double height) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: height * 0.10),
          const Text(
            "Shatrunash\nAdmin Application",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          const Text("Admin login to Shatrunash Health Application"),
        ],
      ),
    );
  }

  //Login Function
  Future<void> login() async {
    setState(() {
      loginLoading = true;
    });
    if (formKey.currentState!.validate()) {
      try {
        await supabase.auth.signInWithPassword(email: emailController.text, password: passwordController.text);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      } on AuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
    setState(() {
      loginLoading = false;
    });
  }
}
