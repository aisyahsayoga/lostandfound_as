import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  XFile? _avatar;

  @override
  void initState() {
    super.initState();
    final user = AuthService().currentUser;
    _nameController.text = user?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final user = AuthService().currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save changes')),
      );
      return;
    }
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }
    try {
      await AuthService().updateName(name);
      if (_avatar != null) {
        await AuthService().updateAvatarFromPath(_avatar!.path);
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() => _avatar = file);
    }
  }

  // removed _changePassword button; change password handled on Save

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: (_avatar != null)
                        ? Image.file(File(_avatar!.path)).image
                        : (AuthService().fileViewUrl(
                                    AuthService().currentUser?.avatarFileId,
                                  ) !=
                                  null
                              ? Image.network(
                                  AuthService().fileViewUrl(
                                    AuthService().currentUser?.avatarFileId,
                                  )!,
                                ).image
                              : null),
                    child:
                        (AuthService().fileViewUrl(
                                  AuthService().currentUser?.avatarFileId,
                                ) ==
                                null &&
                            _avatar == null)
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _pickAvatar,
                    child: const Text('Change Photo'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Full Name', style: appThemeData.textTheme.bodyLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Your full name'),
              ),
              const SizedBox(height: 16),
              Text('Change Password', style: appThemeData.textTheme.bodyLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _oldPasswordController,
                decoration: const InputDecoration(hintText: 'Old password'),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(hintText: 'New password'),
                obscureText: true,
              ),
              // Forgot Password removed
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
