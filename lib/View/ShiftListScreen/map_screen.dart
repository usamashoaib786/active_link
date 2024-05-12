import 'package:active_link/Constants/app_logger.dart';
import 'package:active_link/Utils/resources/res/app_theme.dart';
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/Utils/widgets/others/app_button.dart';
import 'package:active_link/Utils/widgets/others/app_field.dart';
import 'package:active_link/View/Authentication/login_screen.dart';
import 'package:active_link/View/ShiftListScreen/shift_screen.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_plugin;
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final id;
  final breakIn;
  const MapScreen({super.key, this.id, this.breakIn});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  location_plugin.Location location = location_plugin.Location();
  Set<Marker> markers = {};
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool _isLoading = false;
  var finalResponse;
  var currentLocation;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    _getCurrentLocation();

    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    try {
      var status = await location.hasPermission();
      if (status == PermissionStatus.granted) {
        currentLocation = await location.getLocation();
        print("Location: $currentLocation");

        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  currentLocation.latitude ?? 0.0,
                  currentLocation.longitude ?? 0.0,
                ),
                zoom: 15.0,
              ),
            ),
          );

          // Clear previous markers
          markers.clear();

          // Add a marker for the current location
          markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(
                currentLocation.latitude ?? 0.0,
                currentLocation.longitude ?? 0.0,
              ),
              infoWindow: const InfoWindow(title: 'Your Location'),
            ),
          );
          setState(() {}); // Update the widget to show the marker
        } else {
          print('Location data is not available.');
        }
      } else {
        print('Location permission denied.');
      }
    } catch (e) {
      // Handle location access error
      print('Error getting location: $e');
    }
  }

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding:  widget.breakIn== true? const EdgeInsets.only(bottom: 100.0):const EdgeInsets.only(bottom: 200.0),
        child: FloatingActionButton(
          onPressed: () {
            _getCurrentLocation();
          },
          backgroundColor: AppTheme.appColor,
          child: const Icon(Icons.location_searching),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: markers,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: widget.breakIn == true ? 100 : 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.breakIn == true
                      ? const SizedBox.shrink()
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20.0),
                        child: AppField(
                          borderRadius: BorderRadius.circular(20),
                            textEditingController: _controller,
                            hintText: "Notes",
                          ),
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton.appButton("Confirm", onTap: () {
                        if (widget.breakIn == true) {
                          clockIn(id: widget.id);
                        } else {
                          completeApi(id: widget.id);
                        }
                      },
                          textColor: AppTheme.whiteColor,
                          backgroundColor: const Color(0xff65A0E4),
                          height: 30,
                          width: 110),
                      const SizedBox(
                        width: 15,
                      ),
                      AppButton.appButton("Cancel", onTap: () {
                        Navigator.pop(context);
                      },
                          textColor: AppTheme.whiteColor,
                          backgroundColor: const Color(0xffFF0D0D),
                          height: 30,
                          width: 110),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void completeApi({id}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "shift_id": id,
      "employee_note": _controller.text,
      "lat1": currentLocation.latitude,
      "lng1": currentLocation.longitude,
    };
    try {
      response = await dio.post(path: AppUrls.shiftComplete, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "User logged in somewhere else..");
        setState(() {
          _isLoading = false;
          pushUntil(context, LogInScreen());

        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          setState(() {
            _isLoading = false;
          });

          return;
        } else {
          setState(() {
            _isLoading = false;
            pushReplacement(context, const ShiftListScreen());
          });
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void clockIn({id}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": id,
      "lat": currentLocation.latitude,
      "lng": currentLocation.longitude,
    };
    try {
      response = await dio.post(path: AppUrls.shiftClockIn, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "User logged in somewhere else..");
        setState(() {
          _isLoading = false;
          pushUntil(context, LogInScreen());

        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          setState(() {
            _isLoading = false;
          });

          return;
        } else {
          setState(() {
            _isLoading = false;
            pushReplacement(context, const ShiftListScreen());
          });
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
