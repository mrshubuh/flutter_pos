import '../../../core/common/result.dart';
import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class GetDailyReportUsecase {
  final ReportRepository _repository;

  GetDailyReportUsecase(this._repository);

  Future<Result<List<DailyReportEntity>>> call({
    required String startDate,
    required String endDate,
  }) {
    return _repository.getDailyReport(startDate: startDate, endDate: endDate);
  }
}

class GetMonthlyReportUsecase {
  final ReportRepository _repository;

  GetMonthlyReportUsecase(this._repository);

  Future<Result<List<MonthlyReportEntity>>> call({required int year}) {
    return _repository.getMonthlyReport(year: year);
  }
}

class GetTopProductsUsecase {
  final ReportRepository _repository;

  GetTopProductsUsecase(this._repository);

  Future<Result<List<TopProductEntity>>> call({
    required String startDate,
    required String endDate,
    int limit = 10,
  }) {
    return _repository.getTopProducts(startDate: startDate, endDate: endDate, limit: limit);
  }
}

class GetPaymentSummaryUsecase {
  final ReportRepository _repository;

  GetPaymentSummaryUsecase(this._repository);

  Future<Result<PaymentSummaryEntity>> call({
    required String startDate,
    required String endDate,
  }) {
    return _repository.getPaymentSummary(startDate: startDate, endDate: endDate);
  }
}
