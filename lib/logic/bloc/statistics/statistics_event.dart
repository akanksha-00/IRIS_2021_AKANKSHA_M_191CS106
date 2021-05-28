class StatisticsEvent {}

class SelectYear extends StatisticsEvent {
  final int year;
  SelectYear({required this.year});
}
