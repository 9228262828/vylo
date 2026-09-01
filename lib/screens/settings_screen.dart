import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class SettingsScreen extends StatelessWidget {
  final ProgressService progress;
  const SettingsScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (_, __) => Scaffold(
        backgroundColor: Color(progress.selectedTheme.background),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          children: [
            SwitchListTile(
              value: progress.soundEnabled,
              onChanged: progress.setSound,
              title: const Text('Sound'),
              subtitle: const Text('Use lightweight system sound feedback.'),
            ),
            SwitchListTile(
              value: progress.hapticsEnabled,
              onChanged: progress.setHaptics,
              title: const Text('Haptics'),
              subtitle: const Text('Vibration feedback for turns and matches.'),
            ),
            const Divider(height: 32),
            const ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy Policy'),
              subtitle: Text('Connect your published policy URL before release.'),
            ),
            const ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Terms & Conditions'),
              subtitle: Text('Connect your published terms URL before release.'),
            ),
            const ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('VYLO'),
              subtitle: Text('Version 1.0.0'),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0x55FF4D6D)),
                borderRadius: BorderRadius.circular(18),
              ),
              leading: const Icon(
                Icons.delete_forever_outlined,
                color: Color(0xFFFF4D6D),
              ),
              title: const Text(
                'Reset all progress',
                style: TextStyle(
                  color: Color(0xFFFF4D6D),
                  fontWeight: FontWeight.w900,
                ),
              ),
              subtitle: const Text(
                'Deletes scores, Bolts, unlocks and achievements.',
              ),
              onTap: () async {
                final yes = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Reset all progress?'),
                        content: const Text(
                          'This cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ) ??
                    false;
                if (yes) await progress.resetProgress();
              },
            ),
          ],
        ),
      ),
    );
  }
}
