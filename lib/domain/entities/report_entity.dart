import 'package:equatable/equatable.dart';

class DailyReportEntity extends Equatable {
  final String date;
  final int totalTransactions;
  final int totalAmount;
  final int cashAmount;
  final int qrisAmount;

  const DailyReportEntity({
    required this.date,
    required this.totalTransactions,
    required this.totalAmount,
    required this.cashAmount,
    required this.qrisAmount,
  });

  @override
  List<Object?> get props => [date, totalTransactions, totalAmount, cashAmount, qrisAmount];
}

class MonthlyReportEntity extends Equatable {
  final String month;
  final int totalTransactions;
  final int totalAmount;
  final int cashAmount;
  final int qrisAmount;

  const MonthlyReportEntity({
    required this.month,
    required this.totalTransactions,
    required this.totalAmount,
    required this.cashAmount,
    required this.qrisAmount,
  });

  @override
  List<Object?> get props => [month, totalTransactions, totalAmount, cashAmount, qrisAmount];
}

class TopProductEntity extends Equatable {
  final int productId;
  final String productName;
  final int totalQuantity;
  final int totalRevenue;

  const TopProductEntity({
    required this.productId,
    required this.productName,
    required this.totalQuantity,
    required this.totalRevenue,
  });

  @override
  List<Object?> get props => [productId, productName, totalQuantity, totalRevenue];
}

class PaymentSummaryEntity extends Equatable {
  final int cashAmount;
  final int cashTransactions;
  final int qrisAmount;
  final int qrisTransactions;
  final int totalAmount;
  final int totalTransactions;

  const PaymentSummaryEntity({
    required this.cashAmount,
    required this.cashTransactions,
    required this.qrisAmount,
    required this.qrisTransactions,
    required this.totalAmount,
    required this.totalTransactions,
  });

  @override
  List<Object?> get props => [
    cashAmount,
    cashTransactions,
    qrisAmount,
    qrisTransactions,
    totalAmount,
    totalTransactions,
  ];
}
