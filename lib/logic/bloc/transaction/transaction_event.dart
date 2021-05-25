import 'package:money_manage_project/models/transaction.dart';

class TransactionEvent {}

class AddTransaction extends TransactionEvent {
  Transaction transaction;
  AddTransaction({required this.transaction});
}

class DataReceived extends TransactionEvent {
  List<Transaction> transactionList;
  List<String> categoryList;
  DataReceived({required this.transactionList, required this.categoryList});
}

class DeleteSingleTransaction extends TransactionEvent {
  int index;
  DeleteSingleTransaction({required this.index});
}

class DeleteAllTransactions extends TransactionEvent {}

class AddCategory extends TransactionEvent {
  String category;
  AddCategory({required this.category});
}

class SelectCategory extends TransactionEvent {
  String category;
  SelectCategory({required this.category});
}
