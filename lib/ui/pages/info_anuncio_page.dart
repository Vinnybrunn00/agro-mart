import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/repository/equipamento/equipamento_repository.dart';
import 'package:agroshare/repository/users/users_repository.dart';
import 'package:agroshare/services/ferramentas/ferramentas_services.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/pages/chat_page.dart';
import 'package:agroshare/ui/pages/profile_user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoAnuncioPage extends StatelessWidget {
  final EquipamentoRepository equipamentos;
  final UsersRepository? currentUser;
  final double? distanceKm;

  const new({
    super.key,
    required this.equipamentos,
    this.distanceKm,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final FerramentasServices ferramentas = Provider.of<FerramentasServices>(
      context,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: .start,
              children: [
                _HeaderPhotos(
                  images: List<String>.from(equipamentos.images),
                  onBack: () async => await Navigator.of(context).maybePop(),
                  onShare: () {},
                  onFavorite: () {},
                ),
                Padding(
                  padding: .fromLTRB(16, 20, 16, 24),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      _ModalidadeBadge('Aluguel'),
                      SizedBox(height: 10),
                      Text(
                        equipamentos.nomeEquipamento,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 20,
                          fontWeight: .w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.greyColor,
                            size: 15,
                          ),
                          Expanded(
                            child: Text(
                              '${equipamentos.nameProperty} · ${distanceKm! <= 5 ? 'Proximo de você' : '${distanceKm!.toStringAsFixed(1)} km'}',
                              overflow: .ellipsis,
                              style: TextStyle(
                                color: AppColors.greyColor,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 14),

                      _OwnerTile(
                        photo: equipamentos.urlPhotoUser,
                        name: equipamentos.name,
                        subtitle: equipamentos.locationProperty,
                        onTap: () async => await NavigatorsApp.push(
                          context,
                          ProfileUserPage(
                            equipamentos: equipamentos,
                            currentUser: currentUser,
                            distanceKm: distanceKm,
                          ),
                        ),
                      ),
                      if (currentUser != null &&
                          currentUser!.id != equipamentos.uid) ...[
                        SizedBox(height: 12),
                        _ChatButton(
                          onTap: () async => await NavigatorsApp.push(
                            context,
                            ChatPage(
                              chatReference: equipamentos.equipamentoReference!
                                  .collection('chats')
                                  .doc(currentUser!.id),
                              currentUser: currentUser!,
                              peerName: equipamentos.name,
                              peerPhoto: equipamentos.urlPhotoUser,
                              subtitle: equipamentos.nomeEquipamento,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 14),
                      Text(
                        equipamentos.description,
                        style: TextStyle(
                          color: AppColors.textColor.withAlpha(200),
                          fontSize: 13.5,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (ferramentas.isLoading)
              Container(
                color: Colors.black.withAlpha(75),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    height: 82,
                    width: 82,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        price: equipamentos.price,
        onTap: () async {
          await ferramentas.sendRequestEquipamento(
            collection: equipamentos.requestCollection,
            user: currentUser,
          );
        },
      ),
    );
  }
}

class _HeaderPhotos extends StatefulWidget {
  final List<String> images;
  final void Function()? onBack;
  final void Function()? onShare;
  final void Function()? onFavorite;

  const _HeaderPhotos({
    required this.images,
    this.onBack,
    this.onShare,
    this.onFavorite,
  });

  @override
  State<_HeaderPhotos> createState() => _HeaderPhotosState();
}

class _HeaderPhotosState extends State<_HeaderPhotos> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [Color(0xffDDE9DC), Color(0xffC4DBC3)],
        ),
      ),
      child: Stack(
        children: [
          if (widget.images.isEmpty)
            const _PhotoPlaceholder()
          else
            Positioned.fill(
              child: PageView.builder(
                itemCount: widget.images.length,
                onPageChanged: (index) => setState(() => _current = index),
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.images[index],
                    fit: .cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const _PhotoPlaceholder();
                    },
                  );
                },
              ),
            ),
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: Row(
                spacing: 8,
                children: [
                  _HeaderBtn(icon: Icons.arrow_back, onTap: widget.onBack),
                  Spacer(),
                  _HeaderBtn(icon: Icons.share_outlined, onTap: widget.onShare),
                  _HeaderBtn(
                    icon: Icons.favorite_border,
                    onTap: widget.onFavorite,
                  ),
                ],
              ),
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: _PageDots(count: widget.images.length, current: _current),
            ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.agriculture_outlined,
        color: AppColors.mainColor.withAlpha(200),
        size: 64,
      ),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;

  const _HeaderBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: .circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(10),
        child: SizedBox(
          height: 38,
          width: 38,
          child: Icon(icon, color: AppColors.textColor, size: 20),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int current;

  const _PageDots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      spacing: 5,
      children: [
        for (int i = 0; i < count; i++)
          Container(
            height: 6,
            width: i == current ? 18 : 6,
            decoration: BoxDecoration(
              color: i == current
                  ? AppColors.mainColor
                  : AppColors.whiteColor.withAlpha(180),
              borderRadius: .circular(6),
            ),
          ),
      ],
    );
  }
}

class _ModalidadeBadge extends StatelessWidget {
  final String label;

  const _ModalidadeBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.mainColor.withAlpha(28),
        borderRadius: .circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.mainColor,
          fontSize: 12,
          fontWeight: .w700,
        ),
      ),
    );
  }
}

class _OwnerTile extends StatelessWidget {
  final String photo;
  final String name;
  final String subtitle;
  final void Function()? onTap;

  const _OwnerTile({
    required this.name,
    required this.subtitle,
    this.onTap,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: .symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: AppColors.blackColorAlpha55),
          ),
        ),
        child: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.mainColor.withAlpha(28),
              backgroundImage: NetworkImage(photo),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    name,
                    overflow: .ellipsis,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14.5,
                      fontWeight: .w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    overflow: .ellipsis,
                    style: TextStyle(color: AppColors.greyColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.greyColor, size: 24),
          ],
        ),
      ),
    );
  }
}

class _ChatButton extends StatelessWidget {
  final void Function()? onTap;

  const _ChatButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mainColor.withAlpha(28),
      borderRadius: .circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(12),
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: .center,
            spacing: 8,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: AppColors.mainColor,
                size: 18,
              ),
              Text(
                'Conversar com o agricultor',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 14,
                  fontWeight: .w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String price;
  final void Function()? onTap;

  const _BottomBar({required this.price, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(top: BorderSide(color: AppColors.blackColorAlpha55)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: .symmetric(horizontal: 16, vertical: 12),
          child: Row(
            spacing: 16,
            children: [
              Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'A partir de',
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 11.5,
                    ),
                  ),

                  Text(
                    price,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 18,
                      fontWeight: .w700,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Material(
                  color: AppColors.mainColor,
                  borderRadius: .circular(12),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: .circular(12),
                    child: SizedBox(
                      height: 46,
                      child: Row(
                        mainAxisAlignment: .center,
                        spacing: 8,
                        children: [
                          Text(
                            'Solicitar',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 15,
                              fontWeight: .w700,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.whiteColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
