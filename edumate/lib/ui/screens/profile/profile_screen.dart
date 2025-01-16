import 'dart:io';

import 'package:edumate/data/env/env.dart';
import 'package:edumate/ui/screens/profile/ProfileService.dart';
import 'package:edumate/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edumate/domain/blocs/auth/auth_bloc.dart';
import 'package:edumate/domain/blocs/user/user_bloc.dart';
import 'package:edumate/ui/helpers/animation_route.dart';
import 'package:edumate/ui/screens/login/login_page.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final userData = await _profileService.getProfile();
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 9),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userData == null
              ? Center(child: Text('No profile data found.'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: _changeAvatar,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                '${Environment.baseUrl}/${_userData!['image'] ?? 'avatar-default.png'}'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Full Name
                        Text(
                          _userData!['fullname'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Email
                        Text(
                          _userData!['email'] ?? 'No email provided',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Edit Profile
                        ElevatedButton.icon(
                          onPressed: () async {
                            final updatedName = await _editNameDialog(context);
                            if (updatedName != null) {
                              setState(() {
                                _userData!['fullname'] = updatedName;
                              });
                            }
                          },
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Logout
                        OutlinedButton.icon(
                          onPressed: () {
                            authBloc.add(OnLogOutEvent());
                            userBloc.add(OnLogOutUser());
                            Navigator.pushAndRemoveUntil(
                                context,
                                routeSlide(page: const LoginPage()),
                                (_) => false);
                          },
                          icon: Icon(Icons.logout, color: Colors.red),
                          label: Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<String?> _editNameDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController(
      text: _userData!['fullname'],
    );
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'New Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  try {
                    final success =
                        await _profileService.updateFullName(newName);
                    if (success) {
                      setState(() {
                        _userData!['fullname'] = newName; // Cập nhật giao diện
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Fullname updated successfully!')),
                      );
                      Navigator.pop(context, newName);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update fullname: $e')),
                    );
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      try {
        final success = await _profileService.updateProfileImage(file);
        if (success) {
          setState(() {
            _avatarUrl = file.path; // Cập nhật giao diện
          });
          _loadUserProfile();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile image updated successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile image: $e')),
        );
      }
    }
  }
}
