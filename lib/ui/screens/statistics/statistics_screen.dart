import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manage_project/models/transaction.dart';

class StatisticsScreen extends StatefulWidget {
  final List<Transaction> transactionList;
  final List<String> categoryList;
  StatisticsScreen({required this.transactionList, required this.categoryList});
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<double> expenseList = List.filled(12, 0.0);
  List<double> incomeList = List.filled(12, 0.0);
  List<BarChartGroupData> rawBarGroups = <BarChartGroupData>[];
  List<PieChartSectionData> piedataIncome = <PieChartSectionData>[];
  List<PieChartSectionData> piedataExpense = <PieChartSectionData>[];
  late List<double> pieIncomeList;
  late List<double> pieExpenseList;
  Map<String, List<double>> pieMap = <String, List<double>>{};
  double maxYvalue = 0.0;
  int divisions = 20;

  @override
  void initState() {
    super.initState();

    pieIncomeList = List.filled(widget.categoryList.length, 0.0);
    pieExpenseList = List.filled(widget.categoryList.length, 0.0);

    widget.categoryList.forEach((category) {
      pieMap.putIfAbsent(category, () => [0.0, 0.0]);
    });

    widget.transactionList.forEach((transaction) {
      if (transaction.amount >= maxYvalue) {
        maxYvalue = transaction.amount + 1000;
      }
      if (transaction.expense == true) {
        expenseList[transaction.dateTime.month] +=
            transaction.amount.toDouble();
      } else {
        incomeList[transaction.dateTime.month] += transaction.amount.toDouble();
      }

      if (transaction.expense) {
        pieMap[transaction.category]![0] =
            pieMap[transaction.category]![0] + transaction.amount;
      } else {
        pieMap[transaction.category]![1] =
            pieMap[transaction.category]![1] + transaction.amount;
      }
    });

    for (int i = 0; i < 12; i++) {
      rawBarGroups.add(makeGroupData(i + 1, expenseList[i], incomeList[i]));
    }

    divisions = 20;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    void getSections(Map<String, List<double>> pieMap) {
      piedataIncome = <PieChartSectionData>[];
      piedataExpense = <PieChartSectionData>[];
      pieMap.forEach((key, value) {
        piedataIncome.add(PieChartSectionData(
          value: value[1],
          title: key,
          radius: width * 0.43,
          badgeWidget: Text(value[1].toString()),
          badgePositionPercentageOffset: 0.9,
          color: Colors.green,
        ));
      });
      pieMap.forEach((key, value) {
        piedataExpense.add(PieChartSectionData(
          value: value[0],
          title: key,
          radius: width * 0.43,
          badgeWidget: Text(value[0].toString()),
          badgePositionPercentageOffset: 0.8,
          color: Colors.red,
        ));
      });
    }

    getSections(pieMap);

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
          backgroundColor: Colors.teal[600],
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.bar_chart),
              text: 'BarGraph',
            ),
            Tab(
              icon: Icon(Icons.pie_chart),
              text: 'Income',
            ),
            Tab(
              icon: Icon(Icons.pie_chart),
              text: 'Expense',
            )
          ]),
        ),
        body: TabBarView(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Center(
                    child: Text(
                      'Monthly Statistics',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    height: height * 0.7,
                    child: BarChart(BarChartData(
                      maxY: maxYvalue,
                      groupsSpace: maxYvalue / divisions,
                      barGroups: rawBarGroups,
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            reservedSize: 14.0,
                            getTitles: (value) {
                              if (value == 0) {
                                return '0';
                              } else if (value == 1000) {
                                return '1K';
                              } else if (value == 2000) {
                                return '2K';
                              } else if (value == 3000) {
                                return '3K';
                              } else if (value == 4000) {
                                return '4k';
                              } else if (value == 5000) {
                                return '5k';
                              } else if (value == 6000) {
                                return '6K';
                              } else if (value == 7000) {
                                return '7K';
                              } else if (value == 8000) {
                                return '8K';
                              } else if (value == 9000) {
                                return '9K';
                              } else if (value == 10000) {
                                return '10K';
                              } else {
                                return '';
                              }
                            }),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 2:
                                return 'Jan';
                              case 2:
                                return 'Feb';
                              case 3:
                                return 'Mar';
                              case 4:
                                return 'Apr';
                              case 5:
                                return 'May';
                              case 6:
                                return 'Jun';
                              case 7:
                                return 'Jul';
                              case 8:
                                return 'Aug';
                              case 9:
                                return 'Sep';
                              case 10:
                                return 'Oct';
                              case 11:
                                return 'Nov';
                              case 12:
                                return 'Dec';
                              default:
                                return '';
                            }
                          },
                        ),
                      ),
                    )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 2.0,
                    ),
                    Text('Income'),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(
                      Icons.circle,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 2.0,
                    ),
                    Text('Expense'),
                  ],
                )
              ],
            ),
            Container(
              child: PieChart(
                PieChartData(
                  sections: piedataIncome,
                  centerSpaceRadius: 0.0,
                ),
              ),
            ),
            Container(
              child: PieChart(
                PieChartData(
                  sections: piedataExpense,
                  centerSpaceRadius: 0.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 0, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [Colors.red],
        width: 5.0,
      ),
      BarChartRodData(
        y: y2,
        colors: [Colors.green],
        width: 5.0,
      ),
    ]);
  }
}
