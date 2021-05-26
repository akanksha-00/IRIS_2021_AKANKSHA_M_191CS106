import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manage_project/logic/bloc/transaction/transaction_bloc.dart';
import 'package:money_manage_project/logic/bloc/transaction/transaction_event.dart';
import 'package:money_manage_project/logic/bloc/transaction/transaction_state.dart';
import 'package:money_manage_project/logic/cubit/user_cubit.dart';
import 'package:money_manage_project/logic/repository/transaction_repository.dart';
import 'package:money_manage_project/logic/repository/user_repository.dart';
import 'package:money_manage_project/models/transaction.dart';
import 'home_widget.dart';

class HomeScreen extends StatelessWidget {
  final UserRepository userRepository;
  final TransactionRepository transactionRepository;
  late List<Transaction> transactionList;
  late List<String> categoryList;

  HomeScreen(
      {Key? key,
      required this.userRepository,
      required this.transactionRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    transactionRepository.getBox(userCubit.state.uid!).then((val) {
      transactionBloc.add(DataReceived(
          transactionList: transactionRepository.getTransaction(),
          categoryList: transactionRepository.getCategory()));
      transactionList = transactionRepository.getTransaction();
      categoryList = transactionRepository.getCategory();
    });

    void addTransaction(Transaction transaction) {
      print(transaction);
      transactionBloc.add(AddTransaction(transaction: transaction));
    }

    void addCategory(String category) {
      transactionBloc.add(AddCategory(category: category));
    }

    void selectCategory(String category) {
      transactionBloc.add(SelectCategory(category: category));
    }

    return WillPopScope(
      onWillPop: () {
        transactionRepository.closeBox();
        return Future.delayed(Duration(seconds: 0), () => true);
      },
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            color: Colors.teal[600],
            child: ListView(
              children: [
                Container(
                  color: Colors.redAccent,
                  padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.money,
                        size: 90.0,
                        color: Colors.teal[600],
                      ),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Add Transaction',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.add,
                          color: Colors.grey[300],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (
                                BuildContext _,
                              ) {
                                //print(categoryList);
                                return addTransactionWidget(
                                    context, addTransaction, categoryList, _);
                              });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.add, color: Colors.grey[300]),
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (
                                BuildContext _,
                              ) {
                                return addCategoryWidget(
                                    context, addCategory, _);
                              });
                        },
                        title: Text(
                          'Add Category',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.select_all, color: Colors.grey[300]),
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (
                                BuildContext _,
                              ) {
                                return selectCategoryWidget(
                                    context,
                                    categoryList,
                                    transactionBloc.selectedCategory,
                                    height,
                                    width,
                                    selectCategory);
                              });
                        },
                        title: Text(
                          'Select Category',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.delete_sharp, color: Colors.grey[300]),
                        onTap: () {
                          Navigator.of(context).pop();
                          transactionBloc.add(DeleteAllTransactions());
                        },
                        title: Text(
                          'Delete All',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.login_rounded, color: Colors.grey[300]),
                        title: Text(
                          'SignOut',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          userRepository.signOut().then((value) {
                            userCubit.changeUID(null);
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.teal[300],
          title: Text('Home'),
          actions: [
            IconButton(
              onPressed: () {
                userRepository.signOut().then((value) {
                  userCubit.changeUID(null);
                });
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
            double netExpense = 0.0;
            double netIncome = 0.0;
            if (transactionBloc.transactionList.length == 0) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/startapp.png'),
                    Text(
                      'Start Adding Transactions!',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }
            if (transactionBloc.transactionList.length != 0) {
              transactionBloc.transactionList.forEach((element) {
                if (element.expense) {
                  netExpense = netExpense + element.amount;
                } else
                  netIncome = netIncome + element.amount;
              });
            }
            if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TransactionState) {
              return Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: transactionBloc.selectedCategory ==
                              "All Categories"
                          ? Text(
                              'All Transactions',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Category: ' + transactionBloc.selectedCategory,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                  Container(
                    height: height * 0.73,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        print(
                            "printing state ${transactionBloc.transactionList[index].title}");
                        if (transactionBloc.transactionList[index].category ==
                                transactionBloc.selectedCategory ||
                            transactionBloc.selectedCategory ==
                                "All Categories") {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 5.0),
                            child: Container(
                              height: height * 0.2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: width * 0.1,
                                    child: Icon(
                                      Icons.account_balance,
                                    ),
                                  ),
                                  Container(
                                      width: width * 0.5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Title: " +
                                                transactionBloc
                                                    .transactionList[index]
                                                    .title,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(
                                              "Description: " +
                                                  transactionBloc
                                                      .transactionList[index]
                                                      .description,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[700])),
                                          SizedBox(
                                            height: height * 0.006,
                                          ),
                                          Text(
                                            "Category: " +
                                                transactionBloc
                                                    .transactionList[index]
                                                    .category,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: width * 0.3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: height * 0.03,
                                        ),
                                        Text(
                                          "\u20B9 " +
                                              transactionBloc
                                                  .transactionList[index].amount
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                            color: transactionBloc
                                                        .transactionList[index]
                                                        .amount ==
                                                    0.0
                                                ? Colors.blue
                                                : transactionBloc
                                                        .transactionList[index]
                                                        .expense
                                                    ? Colors.red
                                                    : Colors.green,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            transactionBloc.add(
                                                DeleteSingleTransaction(
                                                    index: index));
                                          },
                                          icon: Icon(Icons.delete),
                                        ),
                                        Text('Date: ' +
                                            transactionBloc
                                                .transactionList[index]
                                                .dateTime
                                                .day
                                                .toString() +
                                            '-' +
                                            transactionBloc
                                                .transactionList[index]
                                                .dateTime
                                                .month
                                                .toString() +
                                            '-' +
                                            transactionBloc
                                                .transactionList[index]
                                                .dateTime
                                                .year
                                                .toString())
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else
                          return Container();
                      },
                      itemCount: transactionBloc.transactionList.length,
                    ),
                  ),
                  Container(
                    height: height * 0.1,
                    padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 17.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Net Expense: \u20B9 $netExpense",
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Net Income: \u20B9 $netIncome",
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }

  void dispose() {
    transactionRepository.closeBox();
  }
}
