import 'package:hive_flutter/hive_flutter.dart';
part 'model_recipe.g.dart';

@HiveType(typeId: 1)
class Recipes {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final List<String> photo;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String procedure;

  @HiveField(5)
  final String incredients;

  @HiveField(6)
  final int time;

  @HiveField(7)
  String? timeKey;

  @HiveField(8)
  final List<String> favoritesUserIds;

  Recipes({
    this.timeKey,
    required this.title,
    required this.description,
    required this.photo,
    required this.category,
    required this.procedure,
    required this.incredients,
    required this.time,
    required this.favoritesUserIds,
  }); 
  factory Recipes.fromMap(Map<String, dynamic> map) {
  return Recipes(
    time: map['time'] ?? '', 
    description: map['description'] ?? '',
    incredients: map['incredients'] ?? '',
    procedure: map['procedure'] ?? '',
    favoritesUserIds: List<String>.from(map['favoritesUserIds'] ?? []),
    title: map['title'] ?? '',
    category: map['category'] ?? '',
    photo: List<String>.from(map['photo'] ?? []),
  );
  }
}
