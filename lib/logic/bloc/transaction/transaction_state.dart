class TransactionState{}

class LoadingState extends TransactionState{}

class ErrorState extends TransactionState{
  String error;
  ErrorState({
    required this.error,
  });
}
