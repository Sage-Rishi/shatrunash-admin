import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
  //Widget Build
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
      body: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              width: width,
              child: Image.asset("lib/assets/logo.png"),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  const Text("Shatrunash Admin Application", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      title: const Text("Invite Admin to App", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Click here to invite a new admin'),
                      leading: const Icon(Icons.lock),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: true,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: SizedBox(
                                  width: width,
                                  height: height * 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text("Invite Admin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        const Text("Enter the email of the user you want to invite as an admin"),
                                        Expanded(
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics: const BouncingScrollPhysics(),
                                            children: [
                                              Form(
                                                key: formKey,
                                                child: TextFormField(
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
                                                    hintText: "Enter the email of the user",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () async {
                                            if (formKey.currentState!.validate()) {
                                              await supabase.auth.admin.inviteUserByEmail(emailController.text);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite sent')));
                                            }
                                          },
                                          style: FilledButton.styleFrom(fixedSize: Size(width, 50)),
                                          child: const Text('Send Invite'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(fixedSize: Size(width, 50)),
              onPressed: () => supabase.auth.signOut(),
              icon: const Icon(Icons.exit_to_app_outlined),
              label: const Text('Logout'),
            ),
            Wrap(
              spacing: 2,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text("Developed by Rishi C", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(fixedSize: const Size(70, 10)),
                  onPressed: () {
                    launchUrlString('https://github.com/Sage-Rishi');
                  },
                  child: const Text('Github'),
                ),
                TextButton(
                  style: TextButton.styleFrom(fixedSize: const Size(90, 10)),
                  onPressed: () {
                    launchUrlString('https://www.linkedin.com/in/rishi-ch/');
                  },
                  child: const Text('Linkedin'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
