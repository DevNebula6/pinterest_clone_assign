import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/pinterest_button.dart';
import '../../../presentation/providers/profile_providers.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(profileNotifierProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final keyboardPad = MediaQuery.of(context).viewInsets.bottom;
    final user = ref.watch(profileNotifierProvider).user;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardPad + 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: topPad),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  const Text('Edit profile', style: AppTypography.h2),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.lightGray,
                  backgroundImage: user?.avatarUrl != null
                      ? NetworkImage(user!.avatarUrl!)
                      : null,
                  child: user?.avatarUrl == null
                      ? const Icon(Icons.person, size: 48, color: AppColors.textSecondary)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: AppColors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Change photo',
              style: AppTypography.bodySmall.copyWith(color: AppColors.pinterestRed),
            ),
            const SizedBox(height: AppDimensions.paddingXLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FormLabel('Name'),
                  const SizedBox(height: 6),
                  _FormField(controller: _nameController, hint: 'Your name'),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  const _FormLabel('Username'),
                  const SizedBox(height: 6),
                  _FormField(controller: _usernameController, hint: '@username'),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  const _FormLabel('About'),
                  const SizedBox(height: 6),
                  _FormField(
                    controller: _bioController,
                    hint: 'Tell us about yourself',
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimensions.paddingXLarge),
                  PinterestButton(
                    onPressed: _isSaving ? null : _save,
                    label: 'Save',
                    isLoading: _isSaving,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTypography.labelSmall);
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.controller, required this.hint, this.maxLines = 1});

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingMedium,
        ),
      ),
    );
  }
}
