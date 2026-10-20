/// Built-in table of common Egyptian, locally-available foods (macros per 100 g,
/// cooked/ready-to-eat weight unless noted). Used for manual logging, the
/// offline template meal plan and for nice units in the shopping list.
library;

enum FoodCategory { protein, carb, dairy, fat, fruit, veg, dish, supplement }

class EgyptianFood {
  final String id;
  final String nameAr;
  final String nameEn;
  final FoodCategory category;

  /// Per 100 g.
  final double kcal, protein, carbs, fat;

  /// Weight of one natural unit (egg, loaf, banana, cup…) in grams; null = sold by weight.
  final double? unitGrams;
  final String? unitAr, unitEn;

  /// Shopping list shows a count of units instead of kg (eggs, loaves, bananas…).
  final bool countable;

  /// 1 = cheap, 2 = mid, 3 = pricey (used for the low-budget template plan).
  final int priceTier;

  /// Extra lowercase name fragments (ar/en) used to match AI items to this food.
  final List<String> aliases;

  /// Shown in litres in the shopping list (milk, oil).
  final bool liquid;

  const EgyptianFood({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.category,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.unitGrams,
    this.unitAr,
    this.unitEn,
    this.countable = false,
    this.priceTier = 1,
    this.aliases = const [],
    this.liquid = false,
  });

  String name(String lang) => lang == 'ar' ? nameAr : nameEn;
  String? unit(String lang) => lang == 'ar' ? unitAr : unitEn;

  /// Macros for [grams] of this food.
  FoodMacros macrosFor(double grams) {
    final f = grams / 100.0;
    return FoodMacros(calories: kcal * f, protein: protein * f, carbs: carbs * f, fat: fat * f);
  }
}

class FoodMacros {
  final double calories, protein, carbs, fat;
  const FoodMacros({this.calories = 0, this.protein = 0, this.carbs = 0, this.fat = 0});

  FoodMacros operator +(FoodMacros o) => FoodMacros(
        calories: calories + o.calories,
        protein: protein + o.protein,
        carbs: carbs + o.carbs,
        fat: fat + o.fat,
      );

  FoodMacros scale(double f) =>
      FoodMacros(calories: calories * f, protein: protein * f, carbs: carbs * f, fat: fat * f);

  @override
  String toString() =>
      'FoodMacros(kcal ${calories.toStringAsFixed(0)}, P ${protein.toStringAsFixed(1)}, '
      'C ${carbs.toStringAsFixed(1)}, F ${fat.toStringAsFixed(1)})';
}

const List<EgyptianFood> egyptianFoods = [
  // ---- Protein
  EgyptianFood(
      id: 'egg', nameAr: 'بيض', nameEn: 'Eggs', category: FoodCategory.protein,
      kcal: 143, protein: 12.6, carbs: 0.7, fat: 9.5,
      unitGrams: 50, unitAr: 'بيضة', unitEn: 'egg', countable: true, priceTier: 1,
      aliases: ['بيض', 'بيضة', 'بيضتين', 'egg', 'omelet', 'اومليت', 'أومليت']),
  EgyptianFood(
      id: 'egg_white', nameAr: 'بياض بيض', nameEn: 'Egg whites', category: FoodCategory.protein,
      kcal: 52, protein: 10.9, carbs: 0.7, fat: 0.2,
      unitGrams: 33, unitAr: 'بياض بيضة', unitEn: 'egg white', priceTier: 1,
      aliases: ['بياض', 'egg white']),
  EgyptianFood(
      id: 'chicken_breast', nameAr: 'صدور فراخ مشوية', nameEn: 'Grilled chicken breast',
      category: FoodCategory.protein, kcal: 165, protein: 31, carbs: 0, fat: 3.6, priceTier: 2,
      aliases: ['صدور', 'صدر فراخ', 'فراخ', 'دجاج', 'chicken breast', 'chicken']),
  EgyptianFood(
      id: 'chicken_leg', nameAr: 'ورك فراخ', nameEn: 'Chicken leg', category: FoodCategory.protein,
      kcal: 185, protein: 25, carbs: 0, fat: 9.5, priceTier: 1,
      aliases: ['ورك فراخ', 'وراك', 'chicken leg', 'chicken thigh']),
  EgyptianFood(
      id: 'tuna_water', nameAr: 'تونة مصفاة', nameEn: 'Tuna (drained)', category: FoodCategory.protein,
      kcal: 116, protein: 26, carbs: 0, fat: 0.8,
      unitGrams: 100, unitAr: 'علبة', unitEn: 'can', countable: true, priceTier: 2,
      aliases: ['تونة', 'تونه', 'tuna']),
  EgyptianFood(
      id: 'ground_beef', nameAr: 'لحمة مفرومة', nameEn: 'Ground beef', category: FoodCategory.protein,
      kcal: 250, protein: 26, carbs: 0, fat: 15, priceTier: 3,
      aliases: ['مفروم', 'مفرومة', 'ground beef', 'minced']),
  EgyptianFood(
      id: 'beef', nameAr: 'لحمة بقري', nameEn: 'Lean beef', category: FoodCategory.protein,
      kcal: 217, protein: 26, carbs: 0, fat: 12, priceTier: 3,
      aliases: ['لحمة', 'لحم', 'بقري', 'beef', 'steak', 'meat']),
  EgyptianFood(
      id: 'kofta', nameAr: 'كفتة مشوية', nameEn: 'Grilled kofta', category: FoodCategory.protein,
      kcal: 250, protein: 18, carbs: 4, fat: 18, priceTier: 3, aliases: ['كفتة', 'كفته', 'kofta']),
  EgyptianFood(
      id: 'liver', nameAr: 'كبدة', nameEn: 'Beef liver', category: FoodCategory.protein,
      kcal: 175, protein: 27, carbs: 5, fat: 4.7, priceTier: 2, aliases: ['كبدة', 'كبده', 'liver']),
  EgyptianFood(
      id: 'tilapia', nameAr: 'سمك بلطي مشوي', nameEn: 'Grilled tilapia', category: FoodCategory.protein,
      kcal: 128, protein: 26, carbs: 0, fat: 2.7, priceTier: 2,
      aliases: ['سمك', 'بلطي', 'fish', 'tilapia']),
  EgyptianFood(
      id: 'chicken_shawarma', nameAr: 'شاورما فراخ', nameEn: 'Chicken shawarma', category: FoodCategory.dish,
      kcal: 220, protein: 20, carbs: 8, fat: 12, priceTier: 2, aliases: ['شاورما', 'shawarma']),
  // ---- Legumes & carbs
  EgyptianFood(
      id: 'foul', nameAr: 'فول مدمس', nameEn: 'Foul (fava beans)', category: FoodCategory.carb,
      kcal: 110, protein: 7.6, carbs: 19.6, fat: 0.4, priceTier: 1,
      aliases: ['فول', 'foul', 'ful', 'fava']),
  EgyptianFood(
      id: 'lentils', nameAr: 'عدس', nameEn: 'Lentils (cooked)', category: FoodCategory.carb,
      kcal: 116, protein: 9, carbs: 20, fat: 0.4, priceTier: 1, aliases: ['عدس', 'lentil']),
  EgyptianFood(
      id: 'taameya', nameAr: 'طعمية', nameEn: 'Taameya (falafel)', category: FoodCategory.dish,
      kcal: 333, protein: 13.3, carbs: 31.8, fat: 17.8,
      unitGrams: 20, unitAr: 'قرص', unitEn: 'piece', countable: true, priceTier: 1,
      aliases: ['طعمية', 'طعميه', 'فلافل', 'falafel', 'taameya']),
  EgyptianFood(
      id: 'koshary', nameAr: 'كشري', nameEn: 'Koshary', category: FoodCategory.dish,
      kcal: 155, protein: 5, carbs: 28, fat: 3,
      unitGrams: 400, unitAr: 'طبق وسط', unitEn: 'medium plate', priceTier: 1,
      aliases: ['كشري', 'كشرى', 'koshary', 'koshari']),
  EgyptianFood(
      id: 'rice', nameAr: 'أرز أبيض مطبوخ', nameEn: 'White rice (cooked)', category: FoodCategory.carb,
      kcal: 130, protein: 2.7, carbs: 28, fat: 0.3, priceTier: 1, aliases: ['أرز', 'ارز', 'رز', 'rice']),
  EgyptianFood(
      id: 'pasta', nameAr: 'مكرونة مسلوقة', nameEn: 'Pasta (cooked)', category: FoodCategory.carb,
      kcal: 158, protein: 5.8, carbs: 31, fat: 0.9, priceTier: 1,
      aliases: ['مكرونة', 'مكرونه', 'pasta', 'macaroni']),
  EgyptianFood(
      id: 'baladi_bread', nameAr: 'عيش بلدي', nameEn: 'Baladi bread', category: FoodCategory.carb,
      kcal: 255, protein: 9, carbs: 52, fat: 1.5,
      unitGrams: 90, unitAr: 'رغيف', unitEn: 'loaf', countable: true, priceTier: 1,
      aliases: ['عيش بلدي', 'بلدي', 'عيش', 'رغيف', 'baladi', 'bread', 'pita']),
  EgyptianFood(
      id: 'shami_bread', nameAr: 'عيش شامي', nameEn: 'White pita (shami)', category: FoodCategory.carb,
      kcal: 275, protein: 9, carbs: 56, fat: 1.2,
      unitGrams: 60, unitAr: 'رغيف', unitEn: 'loaf', countable: true, priceTier: 1,
      aliases: ['شامي', 'shami']),
  EgyptianFood(
      id: 'toast', nameAr: 'عيش توست', nameEn: 'Toast bread', category: FoodCategory.carb,
      kcal: 265, protein: 9, carbs: 49, fat: 3.2,
      unitGrams: 25, unitAr: 'شريحة', unitEn: 'slice', countable: true, priceTier: 1,
      aliases: ['توست', 'toast']),
  EgyptianFood(
      id: 'potato', nameAr: 'بطاطس مسلوقة', nameEn: 'Boiled potatoes', category: FoodCategory.carb,
      kcal: 87, protein: 1.9, carbs: 20, fat: 0.1, priceTier: 1, aliases: ['بطاطس', 'potato']),
  EgyptianFood(
      id: 'sweet_potato', nameAr: 'بطاطا', nameEn: 'Sweet potato', category: FoodCategory.carb,
      kcal: 90, protein: 2, carbs: 20.7, fat: 0.2, priceTier: 1, aliases: ['بطاطا', 'sweet potato']),
  EgyptianFood(
      id: 'oats', nameAr: 'شوفان', nameEn: 'Oats (dry)', category: FoodCategory.carb,
      kcal: 389, protein: 16.9, carbs: 66, fat: 6.9, priceTier: 2, aliases: ['شوفان', 'oat']),
  EgyptianFood(
      id: 'mahshi', nameAr: 'محشي', nameEn: 'Mahshi', category: FoodCategory.dish,
      kcal: 150, protein: 3, carbs: 25, fat: 4.5, priceTier: 2, aliases: ['محشي', 'mahshi', 'stuffed']),
  EgyptianFood(
      id: 'hawawshi', nameAr: 'حواوشي', nameEn: 'Hawawshi', category: FoodCategory.dish,
      kcal: 260, protein: 12, carbs: 23, fat: 13, priceTier: 2, aliases: ['حواوشي', 'hawawshi']),
  // ---- Fruit
  EgyptianFood(
      id: 'banana', nameAr: 'موز', nameEn: 'Banana', category: FoodCategory.fruit,
      kcal: 89, protein: 1.1, carbs: 22.8, fat: 0.3,
      unitGrams: 120, unitAr: 'موزة', unitEn: 'banana', countable: true, priceTier: 1,
      aliases: ['موز', 'موزة', 'banana']),
  EgyptianFood(
      id: 'apple', nameAr: 'تفاح', nameEn: 'Apple', category: FoodCategory.fruit,
      kcal: 52, protein: 0.3, carbs: 13.8, fat: 0.2,
      unitGrams: 150, unitAr: 'تفاحة', unitEn: 'apple', countable: true, priceTier: 2,
      aliases: ['تفاح', 'apple']),
  EgyptianFood(
      id: 'orange', nameAr: 'برتقال', nameEn: 'Orange', category: FoodCategory.fruit,
      kcal: 47, protein: 0.9, carbs: 11.8, fat: 0.1,
      unitGrams: 150, unitAr: 'برتقانة', unitEn: 'orange', countable: true, priceTier: 1,
      aliases: ['برتقال', 'orange']),
  EgyptianFood(
      id: 'dates', nameAr: 'بلح', nameEn: 'Dates', category: FoodCategory.fruit,
      kcal: 282, protein: 2.5, carbs: 75, fat: 0.4,
      unitGrams: 8, unitAr: 'بلحة', unitEn: 'date', priceTier: 1, aliases: ['بلح', 'تمر', 'date']),
  // ---- Dairy
  EgyptianFood(
      id: 'yogurt', nameAr: 'زبادي', nameEn: 'Yogurt', category: FoodCategory.dairy,
      kcal: 61, protein: 3.5, carbs: 4.7, fat: 3.3,
      unitGrams: 105, unitAr: 'علبة', unitEn: 'cup', countable: true, priceTier: 1,
      aliases: ['زبادي', 'زبادى', 'yogurt', 'yoghurt']),
  EgyptianFood(
      id: 'greek_yogurt', nameAr: 'زبادي يوناني لايت', nameEn: 'Greek yogurt (light)',
      category: FoodCategory.dairy, kcal: 59, protein: 10, carbs: 3.6, fat: 0.4,
      unitGrams: 150, unitAr: 'علبة', unitEn: 'cup', countable: true, priceTier: 2,
      aliases: ['يوناني', 'greek']),
  EgyptianFood(
      id: 'areesh', nameAr: 'جبنة قريش', nameEn: 'Areesh (cottage) cheese', category: FoodCategory.dairy,
      kcal: 98, protein: 14, carbs: 3.4, fat: 3, priceTier: 1,
      aliases: ['قريش', 'cottage', 'areesh']),
  EgyptianFood(
      id: 'white_cheese', nameAr: 'جبنة بيضاء', nameEn: 'White cheese (domiati)', category: FoodCategory.dairy,
      kcal: 264, protein: 14, carbs: 4, fat: 21, priceTier: 2,
      aliases: ['جبنة بيضا', 'جبنة بيضاء', 'دمياطي', 'feta', 'white cheese']),
  EgyptianFood(
      id: 'rumi_cheese', nameAr: 'جبنة رومي', nameEn: 'Rumi cheese', category: FoodCategory.dairy,
      kcal: 380, protein: 26, carbs: 2, fat: 30, priceTier: 3, aliases: ['رومي', 'rumi']),
  EgyptianFood(
      id: 'milk', nameAr: 'لبن كامل الدسم', nameEn: 'Whole milk', category: FoodCategory.dairy,
      kcal: 61, protein: 3.2, carbs: 4.8, fat: 3.3,
      unitGrams: 250, unitAr: 'كوباية', unitEn: 'cup', priceTier: 1, aliases: ['لبن', 'حليب', 'milk'], liquid: true),
  EgyptianFood(
      id: 'skim_milk', nameAr: 'لبن خالي الدسم', nameEn: 'Skim milk', category: FoodCategory.dairy,
      kcal: 35, protein: 3.4, carbs: 5, fat: 0.1,
      unitGrams: 250, unitAr: 'كوباية', unitEn: 'cup', priceTier: 1, aliases: ['خالي', 'skim'], liquid: true),
  // ---- Fats
  EgyptianFood(
      id: 'olive_oil', nameAr: 'زيت زيتون', nameEn: 'Olive oil', category: FoodCategory.fat,
      kcal: 884, protein: 0, carbs: 0, fat: 100,
      unitGrams: 10, unitAr: 'معلقة', unitEn: 'tbsp', priceTier: 3, aliases: ['زيت زيتون', 'olive'], liquid: true),
  EgyptianFood(
      id: 'veg_oil', nameAr: 'زيت', nameEn: 'Cooking oil', category: FoodCategory.fat,
      kcal: 884, protein: 0, carbs: 0, fat: 100,
      unitGrams: 10, unitAr: 'معلقة', unitEn: 'tbsp', priceTier: 1, aliases: ['زيت', 'oil'], liquid: true),
  EgyptianFood(
      id: 'tahini', nameAr: 'طحينة', nameEn: 'Tahini', category: FoodCategory.fat,
      kcal: 595, protein: 17, carbs: 21, fat: 54,
      unitGrams: 15, unitAr: 'معلقة', unitEn: 'tbsp', priceTier: 2, aliases: ['طحينة', 'طحينه', 'tahini']),
  EgyptianFood(
      id: 'peanut_butter', nameAr: 'زبدة فول سوداني', nameEn: 'Peanut butter', category: FoodCategory.fat,
      kcal: 588, protein: 25, carbs: 20, fat: 50,
      unitGrams: 16, unitAr: 'معلقة', unitEn: 'tbsp', priceTier: 2,
      aliases: ['زبدة فول', 'peanut butter']),
  EgyptianFood(
      id: 'peanuts', nameAr: 'سوداني', nameEn: 'Peanuts', category: FoodCategory.fat,
      kcal: 567, protein: 26, carbs: 16, fat: 49, priceTier: 1, aliases: ['سوداني', 'peanut']),
  EgyptianFood(
      id: 'almonds', nameAr: 'لوز', nameEn: 'Almonds', category: FoodCategory.fat,
      kcal: 579, protein: 21, carbs: 22, fat: 50, priceTier: 3, aliases: ['لوز', 'almond']),
  EgyptianFood(
      id: 'honey', nameAr: 'عسل', nameEn: 'Honey', category: FoodCategory.carb,
      kcal: 304, protein: 0.3, carbs: 82, fat: 0,
      unitGrams: 20, unitAr: 'معلقة', unitEn: 'tbsp', priceTier: 2, aliases: ['عسل', 'honey']),
  // ---- Veg
  EgyptianFood(
      id: 'salad', nameAr: 'سلطة خضرا', nameEn: 'Green salad', category: FoodCategory.veg,
      kcal: 20, protein: 1, carbs: 4, fat: 0.2, priceTier: 1,
      aliases: ['سلطة', 'سلطه', 'خيار', 'طماطم', 'salad', 'cucumber', 'tomato']),
  EgyptianFood(
      id: 'veg_saute', nameAr: 'خضار سوتيه', nameEn: 'Sautéed vegetables', category: FoodCategory.veg,
      kcal: 65, protein: 2.5, carbs: 10, fat: 2, priceTier: 1,
      aliases: ['خضار', 'سوتيه', 'vegetable']),
  EgyptianFood(
      id: 'molokhia', nameAr: 'ملوخية', nameEn: 'Molokhia', category: FoodCategory.veg,
      kcal: 60, protein: 3, carbs: 7, fat: 2.5, priceTier: 1, aliases: ['ملوخية', 'ملوخيه', 'molokhia']),
  // ---- Supplement
  EgyptianFood(
      id: 'whey', nameAr: 'واي بروتين', nameEn: 'Whey protein', category: FoodCategory.supplement,
      kcal: 400, protein: 80, carbs: 8, fat: 6,
      unitGrams: 30, unitAr: 'سكوب', unitEn: 'scoop', priceTier: 3, aliases: ['واي', 'whey']),
];

final Map<String, EgyptianFood> egyptianFoodsById = {for (final f in egyptianFoods) f.id: f};

EgyptianFood food(String id) => egyptianFoodsById[id]!;

/// Lowercases and strips Arabic diacritics / letter variants so names compare loosely.
String normalizeFoodName(String s) {
  var t = s.toLowerCase().trim();
  t = t.replaceAll(RegExp('[ً-ْـ]'), ''); // tashkeel + tatweel
  t = t.replaceAll(RegExp('[أإآ]'), 'ا').replaceAll('ة', 'ه').replaceAll('ى', 'ي');
  return t.replaceAll(RegExp(r'\s+'), ' ');
}

/// Best built-in food for an AI/free-text item name (ar or en), or null.
/// Exact names win; otherwise the longest matching alias wins.
EgyptianFood? matchEgyptianFood(String? nameAr, String? nameEn) {
  final names = [nameAr, nameEn].whereType<String>().map(normalizeFoodName).where((s) => s.isNotEmpty);
  if (names.isEmpty) return null;
  for (final f in egyptianFoods) {
    final a = normalizeFoodName(f.nameAr), e = normalizeFoodName(f.nameEn);
    if (names.any((n) => n == a || n == e)) return f;
  }
  EgyptianFood? best;
  var bestLen = 0;
  for (final f in egyptianFoods) {
    for (final alias in f.aliases) {
      final al = normalizeFoodName(alias);
      if (al.length > bestLen && names.any((n) => n.contains(al))) {
        best = f;
        bestLen = al.length;
      }
    }
  }
  return best;
}

/// Simple text search for the manual picker.
List<EgyptianFood> searchEgyptianFoods(String query) {
  final q = normalizeFoodName(query);
  if (q.isEmpty) return egyptianFoods;
  return egyptianFoods.where((f) {
    if (normalizeFoodName(f.nameAr).contains(q) || normalizeFoodName(f.nameEn).contains(q)) return true;
    return f.aliases.any((a) => normalizeFoodName(a).contains(q));
  }).toList();
}
