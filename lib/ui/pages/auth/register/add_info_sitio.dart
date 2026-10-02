import 'dart:async';
import 'dart:developer';

import 'package:agroshare/models/auth/credentials/property/location.dart';
import 'package:agroshare/models/auth/credentials/property/name.dart';
import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/services/location/location_services.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/input/input.dart';
import 'package:agroshare/ui/pages/auth/components/background_auth.dart';
import 'package:agroshare/ui/pages/auth/components/card_auth.dart';
import 'package:agroshare/ui/pages/auth/components/event_button.dart';
import 'package:agroshare/ui/pages/auth/register/add_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddInfoSitioPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModelProvider = Provider.of<UserModel>(context);
    final LocationProperty location = Provider.of<LocationProperty>(context);
    final NameProperty nameProperty = Provider.of<NameProperty>(context);
    final LocationServices locServices = Provider.of<LocationServices>(context);

    return Scaffold(
      floatingActionButtonLocation: .startTop,
      floatingActionButton: Padding(
        padding: .only(left: 5, top: 20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(BoxIcons.bx_arrow_back, color: AppColors.whiteColor),
        ),
      ),
      body: BackgroundAuth(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CardAuth(
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

                  InputText(
                    prefixIcon: Icons.location_city,
                    hintText: 'Nome da propriedade / Sítio',
                    keyboardType: .text,
                    onChanged: (name) => userModelProvider.nameProperty = name,
                    errorText: nameProperty.msgError,
                  ),

                  SizedBox(height: 10),

                  InputText(
                    prefixIcon: Icons.location_city,
                    hintText: 'Município - Estado',
                    keyboardType: .text,
                    onChanged: (location) =>
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

                  SizedBox(height: 12),

                  EventButton(
                    key: ValueKey('password'),
                    userModelProvider: userModelProvider,
                    onTap: () async {
                      nameProperty.validate(userModelProvider.nameProperty);
                      location.validate(userModelProvider.locationProperty);

                      userModelProvider.latitude = locServices.latitude;
                      userModelProvider.longitude = locServices.longitude;

                      if (nameProperty.getValue != null &&
                          location.getValue != null) {
                        await NavigatorsApp.push(context, AddPhotoPage());
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

Widget _showGoogleMaps(LocationServices locServices) {
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
