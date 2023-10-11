import 'package:intl/intl.dart';

String formatNumber(double number) {
  final formatter = NumberFormat('#,###.00');
  return formatter.format(number);
}

// String formatAsCurrency(double number) {
//   return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(number);
// }

String formatAsCurrency(double numberInCents) {
  // double numberInDollars = numberInCents / 100;
  return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(numberInCents);
}