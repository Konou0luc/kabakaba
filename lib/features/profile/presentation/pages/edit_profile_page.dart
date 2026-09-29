import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/session_providers.dart';
import '../../../../core/utils/api_error.dart';
import '../../../../core/utils/kaba_snack.dart';
import '../../../../core/utils/phone_e164.dart';
import '../../../../features/auth/data/auth_provider.dart';
import '../../../../features/profile/data/user_repository.dart';
import '../../../../shared/widgets/kaba_button.dart';
import '../../../../shared/widgets/kaba_card.dart';
import '../../../../shared/widgets/light_page_scaffold.dart';
import '../../../../shared/widgets/remote_photo.dart';
import '../../../../core/theme/app_text_styles.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _loaded = false;
  bool _saving = false;
  bool _uploadingPhoto = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _hydrate() {
    if (_loaded) return;
    final user =
        ref.read(meProvider).valueOrNull ?? ref.read(currentUserProvider);
    if (user == null) return;
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email ?? '';
    _loaded = true;
  }

  Future<void> _pickAvatar() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (photo == null) return;
    setState(() => _uploadingPhoto = true);
    try {
      final url = await ref.read(userRepositoryProvider).uploadAvatar(photo.path);
      final user =
          ref.read(meProvider).valueOrNull ?? ref.read(currentUserProvider);
      if (url.isNotEmpty && user != null) {
        ref.read(authProvider.notifier).updateCurrentUser(
          user.copyWith(avatarUrl: url),
        );
      }
      ref.invalidate(meProvider);
      if (mounted) showKabaSnack(context, 'Photo mise à jour');
    } catch (error) {
      if (mounted) showKabaSnack(context, apiErrorMessage(error), error: true);
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _save() async {
    final user =
        ref.read(meProvider).valueOrNull ?? ref.read(currentUserProvider);
    if (user == null) return;
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    if (first.isEmpty || last.isEmpty) {
      showKabaSnack(context, 'Indique ton prénom et ton nom', error: true);
      return;
    }
    setState(() => _saving = true);
    try {
      final updated = await ref.read(userRepositoryProvider).updateUser(
        id: user.id,
        firstName: first,
        lastName: last,
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
      );
      ref.read(authProvider.notifier).updateCurrentUser(updated);
      ref.invalidate(meProvider);
      if (!mounted) return;
      showKabaSnack(context, 'Profil mis à jour');
      context.pop();
    } catch (error) {
      if (mounted) showKabaSnack(context, apiErrorMessage(error), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _hydrate();
    final user =
        ref.watch(meProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final phone = user?.phone;
    final phoneLabel = (phone == null || phone.isEmpty)
        ? '—'
        : '+228 ${formatTogoDisplay(phone)}';

    return LightPageScaffold(
      title: 'Modifier le profil',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          children: [
            KabaCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _uploadingPhoto ? null : _pickAvatar,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        RemotePhoto(
                          url: user?.avatarUrl,
                          width: 88,
                          height: 88,
                          radius: 44,
                          fallback: CircleAvatar(
                            radius: 44,
                            backgroundColor: LightPageColors.orangeLight,
                            child: _uploadingPhoto
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    user?.initials ?? '?',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: LightPageColors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _uploadingPhoto ? 'Envoi…' : 'Changer la photo',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: LightPageColors.orange,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _field(
                    controller: _firstNameController,
                    label: 'Prénom(s)',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 18),
                  _field(
                    controller: _lastNameController,
                    label: 'Nom',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 18),
                  _field(
                    controller: _emailController,
                    label: 'Email (optionnel)',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Téléphone', style: AppTextStyles.bodyMedium),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phoneLabel,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: LightPageColors.muted,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),
            KabaButton(
              text: _saving ? 'Enregistrement…' : 'Enregistrer',
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: LightPageColors.text),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: LightPageColors.orange, size: 20),
            filled: true,
            fillColor: LightPageColors.bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
