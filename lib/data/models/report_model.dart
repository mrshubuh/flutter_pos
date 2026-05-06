import 'package:equatable/equatable.dart';

import '../../domain/entities/report_entity.dart';

class DailyReportModel extends Equatable {
  final String date;
  final int totalTransactions;
  final int totalAmount;
  final int cashAmount;
  final int qrisAmount;

  const DailyReportModel({
    required this.date,
    required this.totalTransactions,
    required this.totalAmount,
    required this.cashAmount,
    required this.qrisAmount,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    return DailyReportModel(
      date: json['date'] as String,
      totalTransactions: (json['total_transactions'] as num).toInt(),
      totalAmount: (json['total_amount'] as num).toInt(),
      cashAmount: (json['cash_amount'] as num).toInt(),
      qrisAmount: (json['qris_amount'] as num).toInt(),
    );
  }

  DailyReportEntity toEntity() {
    return DailyReportEntity(
      date: date,
      totalTransactions: totalTransactions,
      totalAmount: totalAmount,
      cashAmount: cashAmount,
      qrisAmount: qrisAmount,
    );
  }

  @override
  List<Object?> get props => [date, totalTransactions, totalAmount, cashAmount, qrisAmount];
}

class MonthlyReportModel extends Equatable {
  final String month;
  final int totalTransactions;
  final int totalAmount;
  final int cashAmount;
  final int qrisAmount;

  const MonthlyReportModel({
    required this.month,
    required this.totalTransactions,
    required this.totalAmount,
    required this.cashAmount,
    required this.qrisAmount,
  });

  factory MonthlyReportModel.fromJson(Map<String, dynamic> json) {
    return MonthlyReportModel(
      month: json['month'] as String,
      totalTransactions: (json['total_transactions'] as num).toInt(),
      totalAmount: (json['total_amount'] as num).toInt(),
      cashAmount: (json['cash_amount'] as num).toInt(),
      qrisAmount: (json['qris_amount'] as num).toInt(),
    );
  }

  MonthlyReportEntity toEntity() {
    return MonthlyReportEntity(
      month: month,
      totalTransactions: totalTransactions,
      totalAmount: totalAmount,
      cashAmount: cashAmount,
      qrisAmount: qrisAmount,
    );
  }

  @override
  List<Object?> get props => [month, totalTransactions, totalAmount, cashAmount, qrisAmount];
}

class TopProductModel extends Equatable {
  final int productId;
  final String productName;
  final int totalQuantity;
  final int totalRevenue;

  const TopProductModel({
    required this.productId,
    required this.productName,
    required this.totalQuantity,
    required this.totalRevenue,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      productId: (json['product_id'] as num).toInt(),
      productName: json['product_name'] as String,
      totalQuantity: (json['total_quantity'] as num).toInt(),
      totalRevenue: (json['total_revenue'] as num).toInt(),
    );
  }

  TopProductEntity toEntity() {
    return TopProductEntity(
      productId: productId,
      productName: productName,
      totalQuantity: totalQuantity,
      totalRevenue: totalRevenue,
    );
  }

  @override
  List<Object?> get props => [productId, productName, totalQuantity, totalRevenue];
}

class PaymentSummaryModel extends Equatable {
  final int cashAmount;
  final int cashTransactions;
  final int qrisAmount;
  final int qrisTransactions;
  final int totalAmount;
  final int totalTransactions;

  const PaymentSummaryModel({
    required this.cashAmount,
    required this.cashTransactions,
    required this.qrisAmount,
    required this.qrisTransactions,
    required this.totalAmount,
    required this.totalTransactions,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryModel(
      cashAmount: (json['cash_amount'] as num).toInt(),
      cashTransactions: (json['cash_transactions'] as num).toInt(),
      qrisAmount: (json['qris_amount'] as num).toInt(),
      qrisTransactions: (json['qris_transactions'] as num).toInt(),
      totalAmount: (json['total_amount'] as num).toInt(),
      totalTransactions: (json['total_transactions'] as num).toInt(),
    );
  }

  PaymentSummaryEntity toEntity() {
    return PaymentSummaryEntity(
      cashAmount: cashAmount,
      cashTransactions: cashTransactions,
      qrisAmount: qrisAmount,
      qrisTransactions: qrisTransactions,
      totalAmount: totalAmount,
      totalTransactions: totalTransactions,
    );
  }

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
