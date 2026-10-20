/// Stylized front/back human figure as SVG source, one path per muscle region.
///
/// Coordinates live in a 200×420 viewBox. Regions are authored for the
/// left half of the figure and mirrored around x=100, which keeps the body
/// perfectly symmetric.
library;

enum BodyView { front, back }

/// One drawable region; [muscle] is a canonical muscle id (see `kMuscles`),
/// [region] a finer anatomical name (e.g. obliques → abdominals).
class MuscleRegion {
  final String muscle;
  final String region;
  final String d;
  final bool mirror;
  const MuscleRegion(this.muscle, this.region, this.d, {this.mirror = true});
}

const double kBodyViewBoxWidth = 200;
const double kBodyViewBoxHeight = 420;

/// Left half of the silhouette (closed through the body's centre line).
const String _silhouetteOpen = 'M100,50 C95,50 92,51 91,53 L90,62 C86,66 78,68 68,70 C58,72 50,74 46,80 '
    'C40,86 38,96 39,106 C38,120 38,134 40,148 C36,160 32,178 31,196 C30,204 29,210 28,216 '
    'C26,224 27,234 31,240 C34,243 38,242 40,236 C41,230 41,222 42,216 C46,200 52,180 56,162 '
    'C59,150 60,136 60,122 L62,112 C64,128 66,146 70,166 C71,176 69,186 67,196 C64,206 63,216 64,228 '
    'C64,250 66,272 70,294 C69,302 68,310 68,318 C67,336 68,352 71,370 C72,380 72,390 70,398 '
    'C68,404 72,410 82,410 C90,410 92,404 90,396 C90,388 92,380 93,370 C96,350 96,330 94,316 '
    'C94,308 95,302 96,296 C98,272 99,244 99,222 L100,214';

/// Closed version for filling (the closing edge runs along the centre line).
const String _silhouetteHalf = '$_silhouetteOpen Z';

const List<MuscleRegion> kFrontRegions = [
  MuscleRegion('neck', 'sternocleidomastoid', 'M92,53 C93,58 94,62 96,66 L100,67 L100,53 Z'),
  MuscleRegion('traps', 'upper traps', 'M90,61 C86,65 78,67 70,69 L80,73 C85,71 89,68 92,64 Z'),
  MuscleRegion('shoulders', 'front delts',
      'M68,71 C58,72 50,75 46,81 C41,88 40,97 41,106 C43,110 46,112 48,110 C50,100 55,92 62,87 C66,84 70,80 72,76 C72,73 70,71 68,71 Z'),
  MuscleRegion('chest', 'pectorals',
      'M99,76 L99,112 C92,117 82,118 74,113 C69,110 65,104 64,97 C65,91 68,86 73,80 C79,77 88,76 99,76 Z'),
  MuscleRegion('biceps', 'biceps', 'M48,114 C44,121 42,132 43,144 C45,150 50,152 54,150 C58,142 59,130 58,119 C56,114 52,112 48,114 Z'),
  MuscleRegion('forearms', 'forearm flexors',
      'M44,157 C40,168 36,182 34,196 C34,202 36,206 40,206 C44,196 50,180 54,165 C54,158 50,155 44,157 Z'),
  MuscleRegion('abdominals', 'rectus abdominis', 'M99,119 L99,186 C95,188 91,186 89,182 C87,162 86,140 87,121 C91,119 95,119 99,119 Z'),
  MuscleRegion('abdominals', 'obliques',
      'M85,121 C80,122 74,125 70,129 C70,146 71,164 74,180 C78,186 83,188 86,184 C84,164 83,142 85,121 Z'),
  MuscleRegion('abductors', 'tensor fasciae latae', 'M67,199 C64,207 63,216 64,226 C66,222 68,214 72,207 C72,203 70,200 67,199 Z'),
  MuscleRegion('quadriceps', 'quadriceps',
      'M72,208 C67,222 66,242 68,262 C70,276 72,286 76,292 C82,296 90,294 93,288 C95,276 95,262 93,250 C91,238 88,224 82,212 C78,206 75,205 72,208 Z'),
  MuscleRegion('adductors', 'adductors', 'M85,211 C91,213 96,217 99,223 C99,240 98,256 96,268 C94,256 92,244 89,232 C87,224 86,217 85,211 Z'),
  MuscleRegion('calves', 'gastrocnemius lateral', 'M69,316 C65,330 65,348 69,364 C71,368 76,368 78,364 C79,348 79,330 77,316 C75,311 71,311 69,316 Z'),
  MuscleRegion('calves', 'gastrocnemius medial', 'M93,316 C95,330 95,348 92,366 C90,369 86,368 85,364 C84,348 84,330 86,316 C88,311 91,311 93,316 Z'),
];

const List<MuscleRegion> kBackRegions = [
  MuscleRegion('neck', 'neck extensors', 'M91,53 L91,59 C94,60 97,60 100,60 L100,53 Z'),
  MuscleRegion('traps', 'trapezius',
      'M100,58 C96,59 93,60 90,62 C86,66 78,68 69,71 C77,76 86,84 93,96 C96,104 99,112 100,121 Z'),
  MuscleRegion('shoulders', 'rear delts',
      'M68,72 C58,73 50,76 46,82 C41,89 40,98 41,106 C43,110 46,112 48,110 C50,100 55,92 62,88 C66,85 69,81 70,76 Z'),
  MuscleRegion('middle back', 'rhomboids / infraspinatus',
      'M71,78 C78,83 86,89 91,99 C94,106 95,113 95,119 C88,117 80,111 75,104 C71,98 69,89 71,78 Z'),
  MuscleRegion('lats', 'latissimus dorsi',
      'M65,106 C65,119 66,134 70,150 C74,162 80,171 88,177 C88,167 90,158 95,150 C92,137 86,126 78,118 C73,114 69,110 65,106 Z'),
  MuscleRegion('lower back', 'erector spinae', 'M99,146 L99,203 C95,204 92,203 90,201 C88,191 88,179 89,167 C91,158 94,151 99,146 Z'),
  MuscleRegion('triceps', 'triceps', 'M47,113 C43,121 42,132 43,144 C45,150 50,152 54,150 C58,142 59,130 58,118 C56,113 51,111 47,113 Z'),
  MuscleRegion('forearms', 'forearm extensors',
      'M44,157 C40,168 36,182 34,196 C34,202 36,206 40,206 C44,196 50,180 54,165 C54,158 50,155 44,157 Z'),
  MuscleRegion('abductors', 'gluteus medius', 'M70,198 C67,202 65,208 66,214 C70,210 76,207 84,205 C80,201 74,198 70,198 Z'),
  MuscleRegion('glutes', 'gluteus maximus',
      'M99,207 C92,206 82,206 75,210 C69,216 67,225 69,234 C73,242 82,246 92,244 C96,243 99,240 99,236 Z'),
  MuscleRegion('hamstrings', 'hamstrings',
      'M70,250 C68,264 69,279 72,292 C78,298 88,298 93,292 C95,279 96,264 95,251 C87,247 78,247 70,250 Z'),
  MuscleRegion('adductors', 'adductor magnus', 'M97,248 C98,258 98,268 97,278 C96,269 95,258 95,248 Z'),
  MuscleRegion('calves', 'gastrocnemius lateral', 'M71,313 C67,325 67,340 71,354 C74,358 79,358 82,354 C83,340 82,325 80,315 C77,310 73,310 71,313 Z'),
  MuscleRegion('calves', 'gastrocnemius medial', 'M84,315 C83,327 83,341 85,356 C88,360 92,358 93,354 C95,341 95,325 92,315 C90,310 86,310 84,315 Z'),
];

/// Decorative definition lines (abs, linea alba, spine) drawn on top.
const String _frontDetail = 'M100,119 L100,186 M88,138 L112,138 M88,155 L112,155 M89,171 L111,171';
const String _backDetail = 'M100,121 L100,204';

/// Distinct canonical muscles drawn in [view].
Set<String> musclesIn(BodyView view) => (view == BodyView.front ? kFrontRegions : kBackRegions).map((r) => r.muscle).toSet();

String _hex(int argb) => '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// Builds the SVG for one view. [fillFor] returns an ARGB colour per muscle id.
String buildBodySvg(
  BodyView view, {
  required int Function(String muscle) fillFor,
  int bodyFill = 0xFF1C1C1C,
  int outline = 0xFF3C3C3C,
  int separator = 0xFF0A0A0A,
}) {
  const mirror = 'matrix(-1,0,0,1,200,0)';
  final regions = view == BodyView.front ? kFrontRegions : kBackRegions;
  final b = StringBuffer()
    ..write('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $kBodyViewBoxWidth $kBodyViewBoxHeight">')
    // silhouette
    ..write('<g fill="${_hex(bodyFill)}">')
    ..write('<path d="$_silhouetteHalf"/>')
    ..write('<path d="$_silhouetteHalf" transform="$mirror"/>')
    ..write('</g>')
    // outline drawn on open halves so no seam appears on the centre line
    ..write('<g fill="none" stroke="${_hex(outline)}" stroke-width="1.4" stroke-linejoin="round">')
    ..write('<path d="$_silhouetteOpen"/>')
    ..write('<path d="$_silhouetteOpen" transform="$mirror"/>')
    ..write('</g>')
    ..write('<ellipse cx="100" cy="30" rx="16" ry="20" fill="${_hex(bodyFill)}" stroke="${_hex(outline)}" stroke-width="1.4"/>')
    ..write('<g stroke="${_hex(separator)}" stroke-width="0.9" stroke-linejoin="round">');
  for (final r in regions) {
    final fill = _hex(fillFor(r.muscle));
    b.write('<path d="${r.d}" fill="$fill"/>');
    if (r.mirror) b.write('<path d="${r.d}" fill="$fill" transform="$mirror"/>');
  }
  b
    ..write('</g>')
    ..write('<path d="${view == BodyView.front ? _frontDetail : _backDetail}" fill="none" '
        'stroke="${_hex(separator)}" stroke-width="1.1" stroke-linecap="round" opacity="0.8"/>')
    ..write('</svg>');
  return b.toString();
}
