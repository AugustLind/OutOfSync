import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _nameController = TextEditingController();
  PlayerColor _selectedColor = PlayerColor.blue;
  String? _selectedAvatar;

  final List<String> _avatarOptions = [
    '😀', '😎', '🤔', '😊', '🙂', '😃', '😄', '😁', '😆', '😂',
    '🤣', '😇', '😍', '🤩', '😋', '😜', '🤪', '😏', '🤨', '🧐'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserPreferences.getPlayerProfile();
    if (profile != null && mounted) {
      setState(() {
        _nameController.text = profile.name;
        _selectedColor = profile.color;
        _selectedAvatar = profile.avatarEmoji;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rediger profil'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            CupertinoIcons.back,
            color: AppTheme.primaryColor,
          ),
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _saveProfile,
            child: Text(
              'Lagre',
              style: AppTheme.bodyTextStyle.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedCard(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: _selectedColor.color,
                      child: Text(
                        _selectedAvatar ?? (_nameController.text.isNotEmpty
                            ? _nameController.text[0].toUpperCase()
                            : '?'),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _nameController.text.isNotEmpty ? _nameController.text : 'Ditt navn',
                      style: AppTheme.headlineTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Navn',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 12),
                    IOSTextField(
                      label: 'Skriv inn ditt navn',
                      controller: _nameController,
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
                animationDuration: const Duration(milliseconds: 800),
              ),
              const SizedBox(height: 20),
              AnimatedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Velg farge',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: PlayerColor.values.map((color) {
                        final isSelected = color == _selectedColor;
                        return GestureDetector(
                          onTap: () {
                            VibrationManager.light();
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color.color,
                              borderRadius: BorderRadius.circular(25),
                              border: isSelected
                                  ? Border.all(color: AppTheme.textPrimary, width: 3)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.color.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedColor.displayName,
                      style: AppTheme.captionTextStyle,
                    ),
                  ],
                ),
                animationDuration: const Duration(milliseconds: 1000),
              ),
              const SizedBox(height: 20),
              AnimatedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Velg avatar',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Option to use no avatar (just name initial)
                        GestureDetector(
                          onTap: () {
                            VibrationManager.light();
                            setState(() {
                              _selectedAvatar = null;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _selectedAvatar == null
                                  ? AppTheme.primaryColor
                                  : AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _selectedAvatar == null
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'A',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedAvatar == null
                                      ? Colors.white
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Emoji options
                        ..._avatarOptions.map((emoji) {
                          final isSelected = emoji == _selectedAvatar;
                          return GestureDetector(
                            onTap: () {
                              VibrationManager.light();
                              setState(() {
                                _selectedAvatar = emoji;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryColor.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: isSelected
                                    ? Border.all(color: AppTheme.primaryColor, width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                animationDuration: const Duration(milliseconds: 1200),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vennligst skriv inn et navn')),
      );
      return;
    }

    final profile = PlayerProfile(
      name: name,
      color: _selectedColor,
      avatarEmoji: _selectedAvatar,
    );

    await UserPreferences.savePlayerProfile(profile);
    VibrationManager.success();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil lagret!')),
      );
      Navigator.of(context).pop();
    }
  }
}