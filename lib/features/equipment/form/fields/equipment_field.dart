/*
 * lib/features/equipment/form/fields/equipment_field.dart
 *
 * Interface comum aos campos do formulário de equipamento.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 25/09/2026
 */

abstract class EquipmentField {
  String? get msgError;
  String? get getValue;

  void validate(String? value);
}
