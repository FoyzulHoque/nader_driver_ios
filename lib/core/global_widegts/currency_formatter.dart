import 'package:intl/intl.dart';

class CurrencyFormatter {
  static const String lebanesePoundSymbol = 'ل.ل';

  static String format(num amount) {
    return "${NumberFormat("#,##0", "en_US").format(amount)} $lebanesePoundSymbol";
  }
}
