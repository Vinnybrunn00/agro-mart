import 'package:agroshare/features/equipment/form/equipment_edit_form.dart';
import 'package:agroshare/features/equipment/form/equipment_form.dart';
import 'package:agroshare/features/equipment/providers/manage_equipment_provider.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/features/equipment/models/equipment_model.dart';
import 'package:agroshare/features/rental_requests/models/rental_request_model.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/chat/ui/chat_page.dart';
import 'package:agroshare/core/utils/app_messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class ManageEquipmentPage extends StatelessWidget {
  final EquipmentModel equipamentos;

  const new({super.key, required this.equipamentos});

  @override
  Widget build(BuildContext context) {
    final EquipmentEditForm editEquip = Provider.of<EquipmentEditForm>(context);
    final ManageEquipmentProvider anuncioProvider =
        Provider.of<ManageEquipmentProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        title: Text(equipamentos.nomeEquipamento),
      ),
      body: SingleChildScrollView(
        padding: .all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            _FieldLabel('Nome do equipamento'),
            AppTextField(
              enabled: false,
              initialValue: equipamentos.nomeEquipamento,
              autoFocus: false,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(12),
              ),
              prefixIcon: BoxIcons.bx_edit_alt,
              hintText: 'Nome do Equipamento',
            ),

            _FieldLabel('Preço'),
            AppTextField(
              onChanged: (newPrice) => editEquip.newPrice = newPrice,
              initialValue: equipamentos.price,
              autoFocus: false,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(12),
              ),
              prefixIcon: BoxIcons.bx_purchase_tag,
              hintText: 'Preço (R\$)',
              keyboardType: .number,
              inputFormatters: [context.read<EquipmentForm>().formatter],
            ),

            _FieldLabel('Período de aluguel'),
            AppTextField(
              onChanged: (newPeriodic) => editEquip.newPeriodic = newPeriodic,
              initialValue: equipamentos.periodDias,
              autoFocus: false,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(12),
              ),
              prefixIcon: BoxIcons.bx_calendar,
              hintText: 'Período de aluguel em dias. (ex: 30)',
              keyboardType: .number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            _FieldLabel('Status do anúncio'),
            _StatusSwitch(
              value: editEquip.newStatus ?? equipamentos.status,
              onChanged: (status) async {
                editEquip.change(status);

                // update status do equipamento
                await anuncioProvider.updateStatus(equipamentos, editEquip);
              },
            ),

            SizedBox(height: equipamentos.accept ? 0 : 8),

            if (equipamentos.accept)
              _SaveEquipmentButton(
                onTap: () async {
                  if (editEquip.isNotEmpty) {
                    // update price
                    if (editEquip.newPrice != null) {
                      await anuncioProvider.updatePrice(
                        equipamentos,
                        editEquip,
                      );
                    }

                    // update período do aluguel
                    if (editEquip.newPeriodic != null) {
                      await anuncioProvider.updatePeriodic(
                        equipamentos,
                        editEquip,
                      );
                    }

                    editEquip.clearData();

                    if (!context.mounted) return;
                    await Navigator.of(context).maybePop();
                  }
                },
              ),

            _RentalRequestsSection(
              equipamentos: equipamentos,
              anuncioProvider: anuncioProvider,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.greyColor,
        fontSize: 13,
        fontWeight: .w600,
      ),
    );
  }
}

class _StatusSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;

  const _StatusSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: .circular(12),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: .circular(12),
        child: Ink(
          padding: .symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: .circular(12),
            border: Border.all(color: AppColors.blackColorAlpha55),
          ),
          child: Row(
            spacing: 10,
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: value ? Color(0xFF69F0AE) : Color(0xFFFF5252),
                  shape: .circle,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      value ? 'Ativo' : 'Desativado',
                      style: TextStyle(fontSize: 14, fontWeight: .w600),
                    ),
                    Text(
                      value
                          ? 'O anúncio está visível para aluguel.'
                          : 'O anúncio está oculto para aluguel.',
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: AppColors.mainColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveEquipmentButton extends StatelessWidget {
  final void Function()? onTap;

  const _SaveEquipmentButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mainColor,
      borderRadius: .circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(12),
        child: SizedBox(
          height: 46,
          width: double.infinity,
          child: Center(
            child: Text(
              'Salvar alterações',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 15,
                fontWeight: .w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RentalRequestsSection extends StatelessWidget {
  final EquipmentModel equipamentos;
  final ManageEquipmentProvider anuncioProvider;

  const new({required this.equipamentos, required this.anuncioProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        _FieldLabel('Solicitações de aluguel'),
        StreamBuilder(
          stream: equipamentos.requestCollection?.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) return Text('Error');

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) return _EmptyRentalRequests();

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: .zero,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final RentalRequestModel requestsRepository =
                    RentalRequestModel.fromQueryDocument(docs[index]);

                return _RentalRequestTile(
                  onCancell: () async => await requestsRepository.delete(),
                  onAccept: () async {
                    // este metodo altera o "accept" na Requests Collections
                    await requestsRepository.updateAccept();

                    // este metodo altera o "accept" no Equipamento Collections
                    await equipamentos.updateAccept();

                    if (!context.mounted) return;
                    await Navigator.of(context).maybePop();

                    if (!context.mounted) return;
                    AppMessenger.showMessage(context, message: 'Aceito com sucesso!');
                  },
                  onChat: () async {
                    final ChatPage chatPage = ChatPage(
                      equipamentoId: equipamentos.referenceId,
                      ownerId: equipamentos.uid,
                      requesterId: requestsRepository.uid,
                      nomeEquipamento: equipamentos.nomeEquipamento,
                      contactName: requestsRepository.name,
                      contactPhoto: requestsRepository.photo,
                    );
                    await AppNavigator.push(context, chatPage);
                  },
                  requestId: requestsRepository.uid,
                  photoUrl: requestsRepository.photo,
                  name: requestsRepository.name,
                  nameProperty: requestsRepository.nameProperty,
                  accept: equipamentos.accept,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _RentalRequestTile extends StatelessWidget {
  final String requestId;
  final bool accept;
  final String name;
  final String nameProperty;
  final String photoUrl;
  final void Function()? onCancell;
  final void Function()? onAccept;
  final void Function()? onChat;

  const _RentalRequestTile({
    required this.name,
    required this.nameProperty,
    required this.photoUrl,
    this.onCancell,
    this.onAccept,
    this.onChat,
    required this.accept,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: .all(12),
      margin: .only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: .circular(12),
      ),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.mainColor.withAlpha(30),
            backgroundImage: NetworkImage(photoUrl),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  name,
                  overflow: .ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: .w600),
                ),
                Text(
                  nameProperty,
                  overflow: .ellipsis,
                  style: TextStyle(color: AppColors.greyColor, fontSize: 12.5),
                ),
              ],
            ),
          ),

          if (!accept) ...[
            _RentalRequestActionButton(
              onTap: onCancell,
              icon: BoxIcons.bx_x,
              color: Colors.redAccent,
            ),
            _RentalRequestActionButton(
              onTap: onAccept,
              icon: BoxIcons.bx_check,
              color: AppColors.mainColor,
            ),
          ],

          _RentalRequestActionButton(
            onTap: onChat,
            icon: BoxIcons.bx_chat,
            color: AppColors.mainColor,
          ),
        ],
      ),
    );
  }
}

class _RentalRequestActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final void Function()? onTap;

  const _RentalRequestActionButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withAlpha(30),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 36,
          width: 36,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

class _EmptyRentalRequests extends StatelessWidget {
  const _EmptyRentalRequests();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: .symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: .circular(12),
      ),
      child: Column(
        spacing: 6,
        children: [
          Icon(BoxIcons.bx_user, color: AppColors.blackColorAlpha120, size: 26),
          Text(
            'Nenhuma solicitação por enquanto.',
            style: TextStyle(color: AppColors.greyColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
