import '../../../core/common/result.dart';
import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<Result<List<DailyReportEntity>>> getDailyReport({
    required String startDate,
    required String endDate,
  });

  Future<Result<List<MonthlyReportEntity>>> getMonthlyReport({
    required int year,
  });

  Future<Result<List<TopProductEntity>>> getTopProducts({
    required String startDate,
    required String endDate,
    int limit = 10,
  });

  Future<Result<PaymentSummaryEntity>> getPaymentSummary({
    required String startDate,
    required String endDate,
  });
}
