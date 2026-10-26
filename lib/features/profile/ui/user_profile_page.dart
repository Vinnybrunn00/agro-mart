import 'dart:math' as math;

import 'package:agroshare/features/equipment/models/equipment_model.dart';
import 'package:agroshare/features/profile/models/user_model.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserProfilePage extends StatelessWidget {
  final EquipmentModel equipamentos;
  final UserModel? currentUser;
  final double? distanceKm;

  const new({
    super.key,
    required this.equipamentos,
    this.currentUser,
    this.distanceKm,
  });

  /// Até essa distância o produtor é considerado próximo e o trajeto não é
  /// traçado no mapa.
  static const double _nearKm = 5;

  String? get _distanceLabel {
    if (distanceKm == null) return null;

    return distanceKm! <= _nearKm
        ? 'Próximo de você'
        : '${distanceKm!.toStringAsFixed(1)} km de você';
  }

  /// Localização do usuário atual, apenas quando o produtor não está próximo.
  LatLng? get _userPosition {
    if (currentUser == null || distanceKm == null) return null;
    if (distanceKm! <= _nearKm) return null;

    return LatLng(currentUser!.latitude, currentUser!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CAPA, FOTO E NOME
            _Cover(
              photo: equipamentos.urlPhotoUser,
              onBack: () async => await Navigator.of(context).maybePop(),
            ),

            Padding(
              padding: .fromLTRB(16, 12, 16, 30),
              child: Column(
                spacing: 20,
                children: [
                  Column(
                    spacing: 4,
                    children: [
                      Text(
                        equipamentos.name,
                        textAlign: .center,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 21,
                          fontWeight: .w700,
                        ),
                      ),
                      Text(
                        'Produtor agrícola',
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  Wrap(
                    alignment: .center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_distanceLabel != null)
                        _Pill(
                          icon: Icons.near_me_outlined,
                          label: _distanceLabel!,
                        ),
                      _EquipmentCountPill(uid: equipamentos.uid),
                    ],
                  ),

                  // PROPRIEDADE E MUNICÍPIO
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: .stretch,
                      spacing: 12,
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.agriculture_outlined,
                            label: 'Propriedade',
                            value: equipamentos.nameProperty,
                          ),
                        ),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.location_city_outlined,
                            label: 'Município',
                            value: equipamentos.locationProperty,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // MAPA
                  _LocationCard(
                    latitude: equipamentos.lat,
                    longitude: equipamentos.long,
                    title: equipamentos.nameProperty,
                    subtitle: equipamentos.locationProperty,
                    userPosition: _userPosition,
                    distanceKm: distanceKm,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String photo;
  final void Function()? onBack;

  const _Cover({required this.photo, this.onBack});

  static const double _coverHeight = 170;
  static const double _avatarRadius = 52;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _coverHeight + _avatarRadius,
      child: Stack(
        alignment: .topCenter,
        children: [
          Container(
            height: _coverHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: .topLeft,
                end: .bottomRight,
                colors: [AppColors.mainColor, Color(0xff4B9068)],
              ),
              borderRadius: .vertical(bottom: .circular(28)),
            ),
            child: Align(
              alignment: .centerRight,
              child: Padding(
                padding: .only(right: 12),
                child: Icon(
                  Icons.agriculture_outlined,
                  color: AppColors.whiteColor.withAlpha(30),
                  size: 130,
                ),
              ),
            ),
          ),

          Positioned(
            top: 12,
            left: 16,
            child: SafeArea(
              bottom: false,
              child: Material(
                color: AppColors.whiteColor,
                borderRadius: .circular(10),
                child: InkWell(
                  onTap: onBack,
                  borderRadius: .circular(10),
                  child: SizedBox(
                    height: 38,
                    width: 38,
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.textColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            child: Container(
              padding: .all(4),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                shape: .circle,
              ),
              child: CircleAvatar(
                radius: _avatarRadius - 4,
                backgroundColor: Color(0xffDDE9DC),
                backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
                child: photo.isEmpty
                    ? Icon(
                        Icons.person_outline,
                        color: AppColors.mainColor,
                        size: 44,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.mainColor.withAlpha(28),
        borderRadius: .circular(20),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 6,
        children: [
          Icon(icon, color: AppColors.mainColor, size: 15),
          Text(
            label,
            style: TextStyle(
              color: AppColors.mainColor,
              fontSize: 12.5,
              fontWeight: .w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentCountPill extends StatefulWidget {
  final String uid;

  const _EquipmentCountPill({required this.uid});

  @override
  State<_EquipmentCountPill> createState() => _EquipmentCountPillState();
}

class _EquipmentCountPillState extends State<_EquipmentCountPill> {
  late final Future<AggregateQuerySnapshot> _count = FirebaseFirestore.instance
      .collection('users')
      .doc(widget.uid)
      .collection('equipamentos')
      .count()
      .get();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _count,
      builder: (context, snapshot) {
        final int? count = snapshot.data?.count;

        if (count == null) return SizedBox.shrink();

        return _Pill(
          icon: Icons.campaign_outlined,
          label: count == 1 ? '1 anúncio' : '$count anúncios',
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorCard,
        borderRadius: .circular(16),
        border: Border.all(color: AppColors.blackColorAlpha55.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Icon(icon, color: AppColors.mainColor, size: 24),
          Column(
            crossAxisAlignment: .start,
            spacing: 2,
            children: [
              Text(
                label,
                style: TextStyle(color: AppColors.greyColor, fontSize: 11.5),
              ),
              Text(
                value,
                maxLines: 2,
                overflow: .ellipsis,
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: .w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String subtitle;
  final LatLng? userPosition;
  final double? distanceKm;

  const _LocationCard({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.subtitle,
    this.userPosition,
    this.distanceKm,
  });

  static const double _mapHeight = 240;

  /// Enquadra o produtor e o usuário quando há trajeto; senão foca no produtor.
  CameraPosition _cameraPosition(LatLng position) {
    if (userPosition == null || distanceKm == null) {
      return CameraPosition(target: position, zoom: 14);
    }

    final LatLng center = LatLng(
      (position.latitude + userPosition!.latitude) / 2,
      (position.longitude + userPosition!.longitude) / 2,
    );

    // Metros por pixel no zoom 0, corrigido pela latitude.
    final double metersPerPixel =
        156543.03392 * math.cos(center.latitude * math.pi / 180);

    final double zoom =
        math.log(metersPerPixel * (_mapHeight * 0.65) / (distanceKm! * 1000)) /
        math.ln2;

    return CameraPosition(target: center, zoom: zoom.clamp(3, 14).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final LatLng position = LatLng(latitude, longitude);

    return Container(
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        color: AppColors.backgroundColorCard,
        borderRadius: .circular(20),
        border: Border.all(color: AppColors.blackColorAlpha55.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            height: _mapHeight,
            width: double.infinity,
            margin: .fromLTRB(10, 10, 10, 0),
            clipBehavior: .antiAlias,
            foregroundDecoration: BoxDecoration(
              borderRadius: .circular(14),
              border: Border.all(color: AppColors.mainColor, width: 2),
            ),
            decoration: BoxDecoration(borderRadius: .circular(14)),
            child: GoogleMap(
              initialCameraPosition: _cameraPosition(position),
              markers: {
                Marker(
                  markerId: MarkerId('propertyLocation'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  ),
                  position: position,
                  infoWindow: InfoWindow(title: title, snippet: subtitle),
                ),
                if (userPosition != null)
                  Marker(
                    markerId: MarkerId('userLocation'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                    position: userPosition!,
                    infoWindow: InfoWindow(title: 'Você'),
                  ),
              },
              polylines: {
                if (userPosition != null)
                  Polyline(
                    polylineId: PolylineId('userToProperty'),
                    points: [userPosition!, position],
                    color: AppColors.mainColor,
                    width: 4,
                    geodesic: true,
                    patterns: [PatternItem.dash(20), PatternItem.gap(10)],
                  ),
              },
              // Permite arrastar o mapa mesmo dentro do scroll da página.
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              mapType: .normal,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),

          Padding(
            padding: .all(14),
            child: Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.mainColor,
                  size: 22,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 2,
                    children: [
                      Text(
                        'Localização da propriedade',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                          fontWeight: .w700,
                        ),
                      ),
                      Text(
                        '$title · $subtitle',
                        overflow: .ellipsis,
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
