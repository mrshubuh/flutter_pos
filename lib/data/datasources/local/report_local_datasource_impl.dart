import '../../../core/database/app_database.dart';
import '../../../data/models/report_model.dart';
import '../interfaces/report_datasource.dart';

class ReportLocalDatasourceImpl extends ReportDatasource {
  final AppDatabase _appDatabase;

  ReportLocalDatasourceImpl(this._appDatabase);

  @override
  Future<List<DailyReportModel>> getDailyReport({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final query = '''
        SELECT
          DATE(createdAt) as date,
          COUNT(*) as total_transactions,
          SUM(totalAmount) as total_amount,
          SUM(CASE WHEN paymentMethod = 'Cash' THEN totalAmount ELSE 0 END) as cash_amount,
          SUM(CASE WHEN paymentMethod = 'QRIS' THEN totalAmount ELSE 0 END) as qris_amount
        FROM Transaction
        WHERE DATE(createdAt) BETWEEN ? AND ?
        GROUP BY DATE(createdAt)
        ORDER BY DATE(createdAt)
      ''';

      final result = await _appDatabase.database.rawQuery(query, [startDate, endDate]);

      return result.map((row) => DailyReportModel.fromJson(row)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<MonthlyReportModel>> getMonthlyReport({required int year}) async {
    try {
      final query = '''
        SELECT
          strftime('%Y-%m', createdAt) as month,
          COUNT(*) as total_transactions,
          SUM(totalAmount) as total_amount,
          SUM(CASE WHEN paymentMethod = 'Cash' THEN totalAmount ELSE 0 END) as cash_amount,
          SUM(CASE WHEN paymentMethod = 'QRIS' THEN totalAmount ELSE 0 END) as qris_amount
        FROM Transaction
        WHERE strftime('%Y', createdAt) = ?
        GROUP BY strftime('%Y-%m', createdAt)
        ORDER BY strftime('%Y-%m', createdAt)
      ''';

      final result = await _appDatabase.database.rawQuery(query, [year.toString()]);

      return result.map((row) => MonthlyReportModel.fromJson(row)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TopProductModel>> getTopProducts({
    required String startDate,
    required String endDate,
    int limit = 10,
  }) async {
    try {
      final query = '''
        SELECT
          p.id as product_id,
          p.name as product_name,
          SUM(op.quantity) as total_quantity,
          SUM(op.quantity * op.price) as total_revenue
        FROM OrderedProduct op
        JOIN Transaction t ON op.transactionId = t.id
        JOIN Product p ON op.productId = p.id
        WHERE DATE(t.createdAt) BETWEEN ? AND ?
        GROUP BY p.id, p.name
        ORDER BY total_revenue DESC
        LIMIT ?
      ''';

      final result = await _appDatabase.database.rawQuery(query, [startDate, endDate, limit]);

      return result.map((row) => TopProductModel.fromJson(row)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<PaymentSummaryModel> getPaymentSummary({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final query = '''
        SELECT
          COUNT(*) as total_transactions,
          SUM(totalAmount) as total_amount,
          SUM(CASE WHEN paymentMethod = 'Cash' THEN totalAmount ELSE 0 END) as cash_amount,
          SUM(CASE WHEN paymentMethod = 'QRIS' THEN totalAmount ELSE 0 END) as qris_amount,
          COUNT(CASE WHEN paymentMethod = 'Cash' THEN 1 END) as cash_transactions,
          COUNT(CASE WHEN paymentMethod = 'QRIS' THEN 1 END) as qris_transactions
        FROM Transaction
        WHERE DATE(createdAt) BETWEEN ? AND ?
      ''';

      final result = await _appDatabase.database.rawQuery(query, [startDate, endDate]);

      if (result.isNotEmpty) {
        final row = result.first;
        return PaymentSummaryModel.fromJson(row);
      } else {
        return PaymentSummaryModel(
          totalTransactions: 0,
          totalAmount: 0,
          cashAmount: 0,
          qrisAmount: 0,
          cashTransactions: 0,
          qrisTransactions: 0,
        );
      }
    } catch (e) {
      return PaymentSummaryModel(
        totalTransactions: 0,
        totalAmount: 0,
        cashAmount: 0,
        qrisAmount: 0,
        cashTransactions: 0,
        qrisTransactions: 0,
      );
    }
  }
}