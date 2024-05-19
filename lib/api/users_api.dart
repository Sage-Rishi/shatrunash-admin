// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersApi {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>?> getAllUsers(BuildContext context) async {
    try {
      final response = await supabase.from('users').select('*');
      print("object: $response ");
      return response;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error fetching users')));
    }
    return null;
  }

  Future<void> verifyUser(BuildContext context, String userId, String role) async {
    try {
      await supabase.from('users').update({'verified': true, 'role': role}).eq('uid', userId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User verified')));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error verifying user')));
    }
  }

  Future<void> deleteUser(BuildContext context, String userId) async {
    try {
      await supabase.from('users').delete().eq('uid', userId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted')));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error deleting user')));
    }
  }
}
