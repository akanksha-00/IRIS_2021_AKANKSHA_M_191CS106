import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  String category;
  @HiveField(3)
  bool expense;
  @HiveField(4)
  double amount;

  Transaction(
      {required this.title,
      required this.description,
      required this.category,
      required this.amount,
      required this.expense});
}

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  String name;
  Category({required this.name});
}
