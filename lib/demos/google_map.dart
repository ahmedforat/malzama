import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapDemo extends StatefulWidget {
  @override
  _GoogleMapDemoState createState() => _GoogleMapDemoState();
}

class _GoogleMapDemoState extends State<GoogleMapDemo> {
  GoogleMapController googleMapController;

  CameraPosition position = CameraPosition(
    target: new LatLng(33.383769, 44.422346),
    zoom: 12,
  );

  List<Map<String, double>> pharmacies;
  List<double> meters = [];

  @override
  void initState() {
    pharmacies = List.generate(11000, (i) => coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: position,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  googleMapController = controller;
                });
              },
              onTap: (LatLng position) async {
                print('Started');
                print(DateTime.now());
                var start = DateTime.now().millisecondsSinceEpoch;
                for (var pharmacy in pharmacies) {
                  meters.add(
                    await Geolocator().distanceBetween(position.latitude,
                        position.longitude, pharmacy['lat'], pharmacy['long']),
                  );
                }
                meters.sort();
                print(
                    'distance for 3000 pharmacy has been calculated in ${DateTime.now().millisecondsSinceEpoch - start} ms');
                print(DateTime.now());
                print(meters.length);
                print(meters.sublist(0, 11));
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text('5 Responses'),
          )
        ]),
      ),
    );
  }
}

Map<String, double> coordinates = {
  'lat': 35.35117284664009,
  'long': 44.43645313382149
};
