import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manage_project/logic/bloc/transaction/transaction_event.dart';
import 'package:money_manage_project/logic/bloc/transaction/transaction_state.dart';
import 'package:money_manage_project/logic/repository/transaction_repository.dart';
import 'package:money_manage_project/models/transaction.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  List<Transaction> transactionList;
  List<String> categoryList;
  String selectedCategory = "All Categories";
  TransactionRepository transactionRepository;

  TransactionBloc(
      {required this.transactionList,
      required this.categoryList,
      required this.transactionRepository})
      : super(LoadingState());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is AddTransaction) {
      print(transactionList.length);
      transactionList.add(event.transaction);
      transactionRepository.transactionListModifies(transactionList);
      print(transactionList.length);
      yield TransactionState();
    } else if (event is DeleteAllTransactions) {
      transactionList.clear();
      transactionRepository.transactionListModifies(<Transaction>[]);
      yield TransactionState();
    } else if (event is DeleteSingleTransaction) {
      transactionList.removeAt(event.index);
      transactionRepository.transactionListModifies(transactionList);
      yield TransactionState();
    } else if (event is AddCategory) {
      categoryList.add(event.category);
      transactionRepository.categoryListModified(categoryList);
      yield TransactionState();
    } else if (event is DataReceived) {
      transactionList = event.transactionList;
      categoryList = event.categoryList;
      yield TransactionState();
    } else if (event is SelectCategory) {
      selectedCategory = event.category;
      yield TransactionState();
    }
  }
}
