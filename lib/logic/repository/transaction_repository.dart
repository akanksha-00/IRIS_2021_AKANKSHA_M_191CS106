import 'package:hive/hive.dart';
import 'package:money_manage_project/models/transaction.dart';

class TransactionRepository {
  late Box transactionBox;

  List<Transaction> getTransaction() {
    return transactionBox.get('transactionList',
        defaultValue: <Transaction>[]).cast<Transaction>();
  }

  List<String> getCategory() {
    return transactionBox
        .get('categoryList', defaultValue: <String>[]).cast<String>();
  }

  Future<void> getBox(String uid) async {
    await Hive.openBox<List>(uid).then((box) {
      transactionBox = box;
    });
  }

  void categoryListModified(List<String> categoryList) {
    transactionBox.put('categoryList', categoryList);
  }

  void transactionListModifies(List<Transaction> transactionList) {
    transactionBox.put('transactionList', transactionList);
  }

  void closeBox() {
    Hive.close();
  }
}
