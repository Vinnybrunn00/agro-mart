import 'dart:async';

import 'package:agroshare/features/auth/form/fields/latitude_field.dart';
import 'package:agroshare/features/auth/form/fields/farm_location_field.dart';
import 'package:agroshare/features/auth/form/fields/longitude_field.dart';
import 'package:agroshare/features/auth/form/fields/farm_name_field.dart';
import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:agroshare/core/navigation/app_navigator.dart';
import 'package:agroshare/features/auth/providers/location_provider.dart';
import 'package:agroshare/core/theme/app_colors.dart';
import 'package:agroshare/core/widgets/app_text_field.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_back_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_header.dart';
import 'package:agroshare/features/auth/ui/register/register_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterFarmPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthForm userModelProvider = Provider.of<AuthForm>(context);
    final FarmLocationField location = Provider.of<FarmLocationField>(context);
    final FarmNameField nameProperty = Provider.of<FarmNameField>(context);
    final LocationProvider locServices = Provider.of<LocationProvider>(context);
    final LatitudeField latitude = Provider.of<LatitudeField>(context);
    final LongitudeField longitude = Provider.of<LongitudeField>(context);

    return Scaffold(
      floatingActionButtonLocation: .startTop,
      floatingActionButton: AuthBackButton(),
      body: AuthBackground(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              AuthCard(
                children: [
                  AuthHeader(
                    step: 5,
                    icon: BoxIcons.bx_leaf,
                    title: 'Informações do sítio',
                    subtitle:
                        'Informe o nome do sítio e o município para continuar.',
                  ),

                  AppTextField(
                    prefixIcon: Icons.home_work_outlined,
                    hintText: 'Nome da propriedade / Sítio',
                    keyboardType: .text,
                    onChanged: (name) => userModelProvider.nameProperty = name,
                    errorText: nameProperty.msgError,
                  ),

                  SizedBox(height: 12),

                  AppTextField(
                    prefixIcon: Icons.place_outlined,
                    hintText: 'Município - Estado',
                    keyboardType: .text,
                    onChanged: (location) =>
                        userModelProvider.locationProperty = location,
                    errorText: location.msgError,
                  ),

                  SizedBox(height: 18),

                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        'Localização do sítio',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 13,
                          fontWeight: .w600,
                        ),
                      ),
                      Text(
                        '(opcional)',
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: locServices.isLoading
                          ? null
                          : () async => await locServices.determinePosition(),
                      borderRadius: BorderRadius.circular(16),
                      child: locServices.latLongIsNotEmpty
                          ? _showGoogleMaps(locServices)
                          : Ink(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor.withAlpha(18),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.mainColor.withAlpha(70),
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: .center,
                                spacing: 8,
                                children: [
                                  Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor.withAlpha(30),
                                      shape: .circle,
                                    ),
                                    child: Icon(
                                      BoxIcons.bx_map,
                                      color: AppColors.mainColor,
                                      size: 28,
                                    ),
                                  ),
                                  Text(
                                    'Toque para usar sua localização atual',
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 12.5,
                                      fontWeight: .w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),

                  if (locServices.latLongIsNotEmpty)
                    Padding(
                      padding: .only(top: 8),
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 15,
                            color: AppColors.mainColor,
                          ),
                          Text(
                            '${locServices.latitude}, ${locServices.longitude}',
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (latitude.msgError != null)
                    Padding(
                      padding: .only(top: 8),
                      child: Text(
                        'Clique no mapa acima para obter as coordenadas.',
                        style: TextStyle(
                          color: Color(0xFFFF9500),
                          fontSize: 12,
                          fontWeight: .w600,
                        ),
                      ),
                    ),

                  SizedBox(height: 22),

                  AuthButton(
                    key: ValueKey('password'),
                    userModelProvider: userModelProvider,
                    onTap: () async {
                      nameProperty.validate(userModelProvider.nameProperty);
                      location.validate(userModelProvider.locationProperty);

                      latitude.validate(locServices.latitude);
                      longitude.validate(locServices.longitude);

                      userModelProvider.latitude = latitude.latitude;
                      userModelProvider.longitude = longitude.longitude;

                      if (nameProperty.getValue != null &&
                          location.getValue != null) {
                        await AppNavigator.push(context, RegisterPhotoPage());
                      }
                    },
                  ),
                ],
              ),

              if (locServices.isLoading) _showLoading(),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _showLoading() {
  return Container(
    padding: .symmetric(horizontal: 20, vertical: 22),
    width: 220,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: .circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(50),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ],
    ),
    alignment: .center,
    child: Column(
      spacing: 14,
      mainAxisSize: .min,
      children: [
        CircularProgressIndicator(color: AppColors.mainColor, strokeWidth: 3),
        Text(
          'Obtendo coordenadas...',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 13,
            fontWeight: .w600,
          ),
        ),
      ],
    ),
  );
}

Widget _showGoogleMaps(LocationProvider locServices) {
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  return Container(
    height: 140,
    width: double.infinity,
    clipBehavior: .antiAlias,
    decoration: BoxDecoration(
      color: AppColors.mainColor.withAlpha(80),
      borderRadius: BorderRadius.circular(16),
    ),
    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          locServices.latitude ?? 0.0,
          locServices.longitude ?? 0.0,
        ),
        zoom: 18,
      ),
      markers: {
        if (locServices.latLongIsNotEmpty)
          Marker(
            draggable: true,
            markerId: MarkerId('currentLocation'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            position: LatLng(locServices.latitude!, locServices.longitude!),
          ),
      },
      zoomControlsEnabled: false,
      mapType: .normal,
      onMapCreated: (GoogleMapController controllers) {
        controller.complete(controllers);
      },
    ),
  );
}
