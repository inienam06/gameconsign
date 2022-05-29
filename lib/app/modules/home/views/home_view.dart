import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) => Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        width: double.infinity,
                        child: DropdownButton<String>(
                          value: controller.selected.value,
                          icon: null,
                          items: <String>['Restaurant', 'Hospital']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) => controller.onChangeType(value!),
                        )),
                    controller.kGooglePlex == null
                        ? Container()
                        : AspectRatio(
                            aspectRatio: 16 / 9,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: controller.kGooglePlex!,
                              markers:
                                  Set<Marker>.of(controller.markers.values),
                              onMapCreated:
                                  (GoogleMapController mapController) {
                                controller.mapController
                                    .complete(mapController);
                              },
                            ),
                          ),
                    Expanded(
                      child: ListView(
                        children: controller.markers.values
                            .map((marker) => Card(
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            marker.infoWindow.title ?? 'none',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            marker.infoWindow.snippet ?? 'none',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      )),
                                ))
                            .toList(),
                      ),
                    )
                  ],
                )),
      ),
    );
  }
}
