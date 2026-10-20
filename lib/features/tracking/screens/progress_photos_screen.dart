import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/context_ext.dart';
import '../../../core/widgets/common.dart';
import '../progress_photo_storage.dart';
import '../tracking_providers.dart';
import '../widgets/tracking_widgets.dart';

String angleLabel(BuildContext context, String angle) => switch (angle) {
      'front' => context.l10n.trkAngleFront,
      'side' => context.l10n.trkAngleSide,
      _ => context.l10n.trkAngleBack,
    };

/// Photos grouped by day (newest first): day → angle → photo.
List<(DateTime, Map<String, ProgressPhoto>)> groupPhotos(List<ProgressPhoto> photos) {
  final map = <DateTime, Map<String, ProgressPhoto>>{};
  for (final ph in photos) {
    map.putIfAbsent(dayOf(ph.date), () => {})[ph.angle] = ph;
  }
  final out = map.entries.map((e) => (e.key, e.value)).toList()..sort((a, b) => b.$1.compareTo(a.$1));
  return out;
}

/// Asks for the biometric / device lock every time it is shown.
class _BiometricGate extends StatefulWidget {
  final Widget child;
  const _BiometricGate({required this.child});

  @override
  State<_BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<_BiometricGate> {
  bool _unlocked = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _auth());
  }

  Future<void> _auth() async {
    if (_busy) return;
    setState(() => _busy = true);
    final ok = await authenticateForPhotos(context.l10n.trkPhotosAuthReason);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _unlocked = ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked) return widget.child;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.trkPhotosTitle)),
      body: Center(
        child: _busy
            ? const CircularProgressIndicator()
            : EmptyState(
                icon: Icons.lock_outline,
                text: l.trkPhotosLocked,
                action: FilledButton.icon(
                  onPressed: _auth,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(l.trkPhotosUnlock),
                ),
              ),
      ),
    );
  }
}

class ProgressPhotosScreen extends StatelessWidget {
  const ProgressPhotosScreen({super.key});

  @override
  Widget build(BuildContext context) => const _BiometricGate(child: _ProgressPhotosBody());
}

class _ProgressPhotosBody extends ConsumerWidget {
  const _ProgressPhotosBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final photos = ref.watch(progressPhotosProvider);
    final docs = ref.watch(appDocsDirProvider).value;
    final groups = groupPhotos(photos.value ?? const []);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.trkPhotosTitle),
        actions: [
          IconButton(
            tooltip: l.trkPhotosCompare,
            icon: const Icon(Icons.compare),
            onPressed: groups.length < 2 ? null : () => push(context, const ProgressPhotoCompareScreen(unlocked: true)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddPhotosSheet(context, today()),
        icon: const Icon(Icons.add_a_photo),
        label: Text(l.trkPhotosAdd),
      ),
      body: photos.isLoading || docs == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                InfoBanner(icon: Icons.lock, text: l.trkPhotosPrivate, color: AppColors.primary),
                if (groups.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: EmptyState(icon: Icons.photo_camera_front_outlined, text: l.trkPhotosEmpty),
                  ),
                for (final (day, byAngle) in groups)
                  SectionCard(
                    title: fmtDayLong(context, day),
                    trailing: IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.add_a_photo_outlined, size: 20),
                      onPressed: () => showAddPhotosSheet(context, day),
                    ),
                    child: Row(
                      children: [
                        for (final a in ProgressPhotoStorage.angles) ...[
                          Expanded(
                            child: _PhotoSlot(
                              docs: docs,
                              photo: byAngle[a],
                              label: angleLabel(context, a),
                              onTap: () => byAngle[a] == null
                                  ? showAddPhotosSheet(context, day)
                                  : push(context, _PhotoViewer(photo: byAngle[a]!, docs: docs)),
                            ),
                          ),
                          if (a != ProgressPhotoStorage.angles.last) const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  final Directory docs;
  final ProgressPhoto? photo;
  final String label;
  final VoidCallback onTap;
  const _PhotoSlot({required this.docs, required this.photo, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Material(
            color: AppColors.cardHigh,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: photo == null
                  ? const Icon(Icons.add, color: AppColors.textMuted)
                  : PhotoImage(docs: docs, relPath: photo!.path, cacheWidth: 360),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}

/// Image from the private folder (with a placeholder when the file is gone).
class PhotoImage extends StatelessWidget {
  final Directory docs;
  final String relPath;
  final int? cacheWidth;
  final BoxFit fit;
  const PhotoImage({super.key, required this.docs, required this.relPath, this.cacheWidth, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      ProgressPhotoStorage.resolve(docs, relPath),
      fit: fit,
      cacheWidth: cacheWidth,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.broken_image_outlined, color: AppColors.textMuted),
          Text(context.l10n.trkPhotoMissing, style: context.text.bodySmall, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

/// Sheet to take / pick front, side and back photos for [day].
Future<void> showAddPhotosSheet(BuildContext context, DateTime day) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => _AddPhotosSheet(day: day),
  );
}

class _AddPhotosSheet extends ConsumerStatefulWidget {
  final DateTime day;
  const _AddPhotosSheet({required this.day});

  @override
  ConsumerState<_AddPhotosSheet> createState() => _AddPhotosSheetState();
}

class _AddPhotosSheetState extends ConsumerState<_AddPhotosSheet> {
  String? _busyAngle;

  Future<void> _capture(String angle, bool camera) async {
    setState(() => _busyAngle = angle);
    final l = context.l10n;
    try {
      final ok = await ProgressPhotoStorage.capture(ref.read(databaseProvider),
          date: widget.day, angle: angle, camera: camera);
      if (ok && mounted) context.snack(l.trkPhotoSaved);
    } catch (e) {
      if (mounted) context.snack(l.trkPhotoFailed);
    } finally {
      if (mounted) setState(() => _busyAngle = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final docs = ref.watch(appDocsDirProvider).value;
    final photos = ref.watch(progressPhotosProvider).value ?? const [];
    final byAngle = {
      for (final ph in photos.where((p) => dayOf(p.date) == widget.day)) ph.angle: ph,
    };
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.trkPhotosForDate(fmtDayLong(context, widget.day)), style: context.text.titleMedium),
            const SizedBox(height: 8),
            for (final a in ProgressPhotoStorage.angles)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 44,
                  height: 58,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: byAngle[a] != null && docs != null
                        ? PhotoImage(docs: docs, relPath: byAngle[a]!.path, cacheWidth: 120)
                        : const ColoredBox(
                            color: AppColors.cardHigh, child: Icon(Icons.person_outline, color: AppColors.textMuted)),
                  ),
                ),
                title: Text(angleLabel(context, a)),
                trailing: _busyAngle == a
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton.filledTonal(
                            tooltip: l.trkCamera,
                            onPressed: _busyAngle == null ? () => _capture(a, true) : null,
                            icon: const Icon(Icons.photo_camera),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                            tooltip: l.trkGallery,
                            onPressed: _busyAngle == null ? () => _capture(a, false) : null,
                            icon: const Icon(Icons.photo_library),
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

class _PhotoViewer extends ConsumerWidget {
  final ProgressPhoto photo;
  final Directory docs;
  const _PhotoViewer({required this.photo, required this.docs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${angleLabel(context, photo.angle)} · ${fmtDay(context, photo.date)}'),
        actions: [
          IconButton(
            tooltip: l.delete,
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              if (!await confirmDelete(context, l.trkPhotoDeleteConfirm)) return;
              await ProgressPhotoStorage.delete(ref.read(databaseProvider), photo);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        maxScale: 5,
        child: Center(child: PhotoImage(docs: docs, relPath: photo.path, fit: BoxFit.contain)),
      ),
    );
  }
}

/// Before/after comparison: two dates side by side per angle, or a drag slider overlay.
class ProgressPhotoCompareScreen extends StatelessWidget {
  /// True when opened from the already unlocked photos screen (skips a second prompt).
  final bool unlocked;
  const ProgressPhotoCompareScreen({super.key, this.unlocked = false});

  @override
  Widget build(BuildContext context) =>
      unlocked ? const _CompareBody() : const _BiometricGate(child: _CompareBody());
}

class _CompareBody extends ConsumerStatefulWidget {
  const _CompareBody();

  @override
  ConsumerState<_CompareBody> createState() => _CompareBodyState();
}

class _CompareBodyState extends ConsumerState<_CompareBody> {
  DateTime? _before;
  DateTime? _after;
  String _angle = 'front';
  bool _slider = false;
  double _split = 0.5;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final docs = ref.watch(appDocsDirProvider).value;
    final groups = groupPhotos(ref.watch(progressPhotosProvider).value ?? const []);
    final dates = groups.map((g) => g.$1).toList(); // newest first

    if (dates.length < 2 || docs == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.trkPhotosCompare)),
        body: EmptyState(icon: Icons.compare, text: l.trkComparePickTwo),
      );
    }
    final before = dates.contains(_before) ? _before! : dates.last;
    final after = dates.contains(_after) ? _after! : dates.first;
    final map = {for (final g in groups) g.$1: g.$2};
    final a = map[before]?[_angle];
    final b = map[after]?[_angle];

    Widget datePicker(String label, DateTime value, ValueChanged<DateTime> onChanged) => Expanded(
          child: DropdownButtonFormField<DateTime>(
            initialValue: value,
            isExpanded: true,
            decoration: InputDecoration(labelText: label, contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
            items: [
              for (final d in dates) DropdownMenuItem(value: d, child: Text(fmtDay(context, d))),
            ],
            onChanged: (d) {
              if (d != null) onChanged(d);
            },
          ),
        );

    Widget photoOrEmpty(ProgressPhoto? ph) => ph == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(l.trkNoPhotoForAngle,
                  textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
            ),
          )
        : PhotoImage(docs: docs, relPath: ph.path);

    return Scaffold(
      appBar: AppBar(title: Text(l.trkPhotosCompare)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(children: [
            datePicker(l.trkBefore, before, (d) => setState(() => _before = d)),
            const SizedBox(width: 10),
            datePicker(l.trkAfter, after, (d) => setState(() => _after = d)),
          ]),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              for (final ang in ProgressPhotoStorage.angles)
                ButtonSegment(value: ang, label: Text(angleLabel(context, ang))),
            ],
            selected: {_angle},
            onSelectionChanged: (s) => setState(() => _angle = s.first),
          ),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: false, icon: const Icon(Icons.view_column), label: Text(l.trkSideBySide)),
              ButtonSegment(value: true, icon: const Icon(Icons.swap_horiz), label: Text(l.trkSlider)),
            ],
            selected: {_slider},
            onSelectionChanged: (s) => setState(() => _slider = s.first),
          ),
          const SizedBox(height: 16),
          if (!_slider)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (label, ph, d) in [(l.trkBefore, a, before), (l.trkAfter, b, after)]) ...[
                  Expanded(
                    child: Column(children: [
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ColoredBox(color: AppColors.cardHigh, child: photoOrEmpty(ph)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('$label · ${fmtDay(context, d)}', style: context.text.bodySmall),
                    ]),
                  ),
                  if (label == l.trkBefore) const SizedBox(width: 8),
                ],
              ],
            )
          else
            _BeforeAfterSlider(
              before: photoOrEmpty(a),
              after: photoOrEmpty(b),
              split: _split,
              beforeLabel: '${l.trkBefore} · ${fmtDay(context, before)}',
              afterLabel: '${l.trkAfter} · ${fmtDay(context, after)}',
              onChanged: (v) => setState(() => _split = v),
            ),
          if (_slider)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l.trkDragToCompare,
                  textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(color: AppColors.textMuted)),
            ),
        ],
      ),
    );
  }
}

/// "After" fills the frame; "before" is revealed from the left up to [split] (0–1).
class _BeforeAfterSlider extends StatelessWidget {
  final Widget before;
  final Widget after;
  final double split;
  final String beforeLabel;
  final String afterLabel;
  final ValueChanged<double> onChanged;
  const _BeforeAfterSlider({
    required this.before,
    required this.after,
    required this.split,
    required this.beforeLabel,
    required this.afterLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget label(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
          child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
        );
    // Fixed LTR so "drag right = more before" in both languages.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LayoutBuilder(builder: (context, c) {
            final w = c.maxWidth;
            void update(Offset local) => onChanged((local.dx / w).clamp(0.0, 1.0));
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: (d) => update(d.localPosition),
              onHorizontalDragUpdate: (d) => update(d.localPosition),
              onTapDown: (d) => update(d.localPosition),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: AppColors.cardHigh, child: after),
                  ClipRect(
                    clipper: _LeftClipper(split),
                    child: ColoredBox(color: AppColors.cardHigh, child: before),
                  ),
                  Positioned(
                    left: (w * split - 1.5).clamp(0.0, w - 3),
                    top: 0,
                    bottom: 0,
                    child: Container(width: 3, color: AppColors.primary),
                  ),
                  Positioned(
                    left: (w * split - 20).clamp(0.0, w - 40),
                    top: c.maxHeight / 2 - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.compare_arrows, color: AppColors.onPrimary),
                    ),
                  ),
                  Positioned(left: 8, top: 8, child: label(beforeLabel)),
                  Positioned(right: 8, top: 8, child: label(afterLabel)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _LeftClipper extends CustomClipper<Rect> {
  final double split;
  _LeftClipper(this.split);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * split, size.height);

  @override
  bool shouldReclip(_LeftClipper old) => old.split != split;
}
