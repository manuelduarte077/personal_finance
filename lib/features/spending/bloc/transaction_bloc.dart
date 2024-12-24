import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/transaction.dart';

// Events
abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;
  AddTransaction(this.transaction);
}

// States
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  TransactionLoaded(this.transactions);
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}

// Bloc
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;

  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());
      try {
        final snapshot = await _firestore.collection('transactions').get();
        final transactions = snapshot.docs
            .map((doc) => Transaction.fromMap(doc.data()))
            .toList();
        emit(TransactionLoaded(transactions));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<AddTransaction>((event, emit) async {
      try {
        await _firestore
            .collection('transactions')
            .doc(event.transaction.id)
            .set(event.transaction.toMap());
        add(LoadTransactions());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });
  }
}
