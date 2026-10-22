import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
// package_info_plus comes with share_plus/workmanager; it only reads the app version.
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/context_ext.dart';
import '../../core/widgets/common.dart';

final _packageInfo = PackageInfo.fromPlatform();

/// Settings → About: version, data sources and licenses.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.setAbout)),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
        children: [
          SectionCard(
            child: Column(
              children: [
                const Icon(Symbols.fitness_center_rounded, fill: 1, size: 48, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(l.appName, style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                FutureBuilder<PackageInfo>(
                  future: _packageInfo,
                  builder: (context, snap) {
                    final v = snap.data;
                    final text = v == null ? '…' : '${v.version}${v.buildNumber.isEmpty ? '' : ' (${v.buildNumber})'}';
                    return Text(l.setAboutVersion(text), style: const TextStyle(color: AppColors.textMuted));
                  },
                ),
                const SizedBox(height: 8),
                Text(l.setAboutTagline, textAlign: TextAlign.center),
              ],
            ),
          ),
          SectionCard(
            title: l.setAboutSources,
            child: Column(
              children: [
                _LicenseRow(name: 'free-exercise-db', detail: l.setAboutExerciseDb, license: 'Unlicense (public domain)'),
                _LicenseRow(name: 'Cairo', detail: l.setAboutFontAr, license: 'SIL Open Font License 1.1'),
                _LicenseRow(name: 'Inter', detail: l.setAboutFontEn, license: 'SIL Open Font License 1.1'),
                _LicenseRow(name: 'Claude API', detail: l.setAboutClaude, license: 'Anthropic'),
              ],
            ),
          ),
          SectionCard(
            title: l.setAboutPrivacy,
            child: Text(l.setAboutPrivacyBody, style: const TextStyle(color: AppColors.textMuted)),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final info = await _packageInfo;
              if (!context.mounted) return;
              showLicensePage(context: context, applicationName: l.appName, applicationVersion: info.version);
            },
            icon: const Icon(Symbols.description_rounded),
            label: Text(l.setAboutLicenses),
          ),
        ],
      ),
    );
  }
}

class _LicenseRow extends StatelessWidget {
  final String name;
  final String detail;
  final String license;
  const _LicenseRow({required this.name, required this.detail, required this.license});

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$detail\n$license', style: const TextStyle(color: AppColors.textMuted)),
        isThreeLine: true,
      );
}
