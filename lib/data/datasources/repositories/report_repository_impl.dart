import '../../../core/common/result.dart';
import '../../../domain/entities/report_entity.dart';
import '../../../domain/repositories/report_repository.dart';
import '../interfaces/report_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDatasource _datasource;

  ReportRepositoryImpl(this._datasource);

  @override
  Future<Result<List<DailyReportEntity>>> getDailyReport({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final models = await _datasource.getDailyReport(startDate: startDate, endDate: endDate);
      return Result.success(data: models.map((m) => m.toEntity()).toList());
    } catch (e, s) {
      return Result.failure(error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<List<MonthlyReportEntity>>> getMonthlyReport({required int year}) async {
    try {
      final models = await _datasource.getMonthlyReport(year: year);
      return Result.success(data: models.map((m) => m.toEntity()).toList());
    } catch (e, s) {
      return Result.failure(error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<List<TopProductEntity>>> getTopProducts({
    required String startDate,
    required String endDate,
    int limit = 10,
  }) async {
    try {
      final models = await _datasource.getTopProducts(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );
      return Result.success(data: models.map((m) => m.toEntity()).toList());
    } catch (e, s) {
      return Result.failure(error: e, stackTrace: s);
    }
  }

  @override
  Future<Result<PaymentSummaryEntity>> getPaymentSummary({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final model = await _datasource.getPaymentSummary(startDate: startDate, endDate: endDate);
      return Result.success(data: model.toEntity());
    } catch (e, s) {
      return Result.failure(error: e, stackTrace: s);
    }
  }
}
