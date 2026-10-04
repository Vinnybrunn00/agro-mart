import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EquipamentosModel with ChangeNotifier {
  String? name;
  String? price;
  String? description;
  DateTimeRange? _period;

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
        decimalDigits: 2,
      );

  CurrencyTextInputFormatter get formatter => _formatter;

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  DateTimeRange? get period => _period;

  DateTime? get startDate => _period?.start;

  DateTime? get endDate => _period?.end;

  set period(DateTimeRange? period) {
    _period = period;
    notifyListeners();
  }

  /// Quantidade de dias do aluguel, contando o dia inicial e o final.
  int get periodDays {
    if (_period == null) return 0;

    return DateUtils.dateOnly(_period!.end)
            .difference(DateUtils.dateOnly(_period!.start))
            .inDays +
        1;
  }

  /// Ex.: 04/10/2026 - 10/10/2026 (7 dias)
  String? get periodLabel {
    if (_period == null) return null;

    final String days = periodDays == 1 ? '1 dia' : '$periodDays dias';

    return '${_dateFormat.format(_period!.start)} - '
        '${_dateFormat.format(_period!.end)} ($days)';
  }
}
