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
import 'package:agroshare/features/auth/ui/widgets/auth_background.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_card.dart';
import 'package:agroshare/features/auth/ui/widgets/auth_button.dart';
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
      floatingActionButton: Padding(
        padding: .only(left: 5, top: 20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(BoxIcons.bx_arrow_back, color: AppColors.whiteColor),
        ),
      ),
      body: AuthBackground(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              AuthCard(
                children: [
                  Text(
                    'Informações do Sítio',
                    style: TextStyle(
                      color: Color(0xFF111540),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    'Informe o nome do sítio e o município para continuar',
                    style: TextStyle(color: AppColors.greyColor, fontSize: 13),
                  ),

                  SizedBox(height: 15),

                  AppTextField(
                    prefixIcon: Icons.location_city,
                    hintText: 'Nome da propriedade / Sítio',
                    keyboardType: .text,
                    onChanged: (name) => userModelProvider.nameProperty = name,
                    errorText: nameProperty.msgError,
                  ),

                  SizedBox(height: 10),

                  AppTextField(
                    prefixIcon: Icons.location_city,
                    hintText: 'Município - Estado',
                    keyboardType: .text,
                    onChanged: ( location) =>
                        userModelProvider.locationProperty = location,
                    errorText: location.msgError,
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Selecionar a localização do sítio (opcional)',
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 8),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: locServices.isLoading
                          ? null
                          : () async => await locServices.determinePosition(),
                      borderRadius: BorderRadius.circular(10),
                      child: locServices.latLongIsNotEmpty
                          ? _showGoogleMaps(locServices)
                          : Ink(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor.withAlpha(80),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  BoxIcons.bx_map,
                                  color: AppColors.mainColor,
                                  size: 50,
                                ),
                              ),
                            ),
                    ),
                  ),

                  if (locServices.latLongIsNotEmpty)
                    Text('${locServices.latitude}, ${locServices.longitude}'),

                  if (latitude.msgError != null)
                    Text('Clique no mapa acima para obter as coordenadas.'),

                  SizedBox(height: 12),

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
    padding: .all(12),
    width: 200,
    decoration: BoxDecoration(
      color: AppColors.greyColor,
      borderRadius: .circular(6),
    ),
    alignment: .center,
    child: Column(
      spacing: 7,
      children: [
        CircularProgressIndicator(color: AppColors.mainColor),
        Text('Obtendo Coordenadas...'),
      ],
    ),
  );
}

Widget _showGoogleMaps(LocationProvider locServices) {
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  return Container(
    height: 130,
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.mainColor.withAlpha(80),
      borderRadius: BorderRadius.circular(10),
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
