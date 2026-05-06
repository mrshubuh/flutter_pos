import 'package:equatable/equatable.dart';

import '../../../domain/entities/report_entity.dart';

enum ReportTab { daily, monthly, topProducts, payment }

class ReportState extends Equatable {
  final ReportTab activeTab;

  // Filter
  final DateTime startDate;
  final DateTime endDate;
  final int selectedYear;

  // Data
  final List<DailyReportEntity> dailyReports;
  final List<MonthlyReportEntity> monthlyReports;
  final List<TopProductEntity> topProducts;
  final PaymentSummaryEntity? paymentSummary;

  // Status
  final bool isLoading;
  final String? errorMessage;

  const ReportState({
    this.activeTab = ReportTab.daily,
    required this.startDate,
    required this.endDate,
    required this.selectedYear,
    this.dailyReports = const [],
    this.monthlyReports = const [],
    this.topProducts = const [],
    this.paymentSummary,
    this.isLoading = false,
    this.errorMessage,
  });

  factory ReportState.initial() {
    final now = DateTime.now();
    return ReportState(
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
      selectedYear: now.year,
    );
  }

  ReportState copyWith({
    ReportTab? activeTab,
    DateTime? startDate,
    DateTime? endDate,
    int? selectedYear,
    List<DailyReportEntity>? dailyReports,
    List<MonthlyReportEntity>? monthlyReports,
    List<TopProductEntity>? topProducts,
    PaymentSummaryEntity? paymentSummary,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReportState(
      activeTab: activeTab ?? this.activeTab,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedYear: selectedYear ?? this.selectedYear,
      dailyReports: dailyReports ?? this.dailyReports,
      monthlyReports: monthlyReports ?? this.monthlyReports,
      topProducts: topProducts ?? this.topProducts,
      paymentSummary: paymentSummary ?? this.paymentSummary,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    activeTab,
    startDate,
    endDate,
    selectedYear,
    dailyReports,
    monthlyReports,
    topProducts,
    paymentSummary,
    isLoading,
    errorMessage,
  ];
}
