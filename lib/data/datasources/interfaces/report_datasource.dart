import '../../models/report_model.dart';

abstract class ReportDatasource {
  Future<List<DailyReportModel>> getDailyReport({
    required String startDate,
    required String endDate,
  });

  Future<List<MonthlyReportModel>> getMonthlyReport({required int year});

  Future<List<TopProductModel>> getTopProducts({
    required String startDate,
    required String endDate,
    int limit = 10,
  });

  Future<PaymentSummaryModel> getPaymentSummary({
    required String startDate,
    required String endDate,
  });
}
