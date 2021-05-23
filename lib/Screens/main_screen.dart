import 'dart:convert';

import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:plants_doc/Screens/chat_lobby.dart';
import 'package:plants_doc/Screens/feritlizer_calculator.dart';
import 'package:plants_doc/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plants_doc/Services/Pick_Image.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'pridict_image.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

const String plant = 'images/plant.jpg';

String longitude,
    latitude,
    temp,
    sunrise,
    humidity,
    sunset,
    cloudsDescription,
    clouds,
    iconNumber,
    cityName,
    sunsetTime;
bool is12HoursFormat;
var login;

class _MainScreenState extends State<MainScreen> {
  int currentPage = 1;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    is12HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

    return Scaffold(
      backgroundColor: Color(0xff00686F),
      body: SafeArea(
        child: getPage(currentPage, context, bottomNavigationKey),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        barBackgroundColor: Colors.white,
        inactiveIconColor: Colors.lightGreen,
        circleColor: Colors.lightGreen,
        tabs: [
          TabData(iconData: Icons.chat, title: "Chat"),
          TabData(
            iconData: Icons.home,
            title: "Home",
          ),
          TabData(
            iconData: Icons.book,
            title: "Book",
          ),
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }
}

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
final String formatted = formatter.format(now);

getPage(int page, context, bottomNavigationKey) {
  switch (page) {
    case 0:
      return ChatLobby();
    case 1:
      return ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xffECF4F3)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(90.0, 30.0, 90.0, 30.0),
                child: Column(
                  children: [
                    Text(
                      temp + "°C",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text("Today " + formatted),
                    Text("Sunset " + sunsetTime + " pm")
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: 200,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Column(
                      children: [
                        Image.asset(
                          "images/fertilizer.jpg",
                          width: 150,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FertilizerCalculator(),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffFE7E67),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Fertilizer Calculator",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: 200,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          "images/community.jpg",
                          width: 150,
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatLobby(),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffFE7E67),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Community Chat",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      "images/scan.jpg",
                      width: 100,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PredictImage(),
                                ));
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Scan for disease',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffFE7E67),
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );

    /*Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: null,
              ),
              IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: null)
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  width: 100,
                  height: 100,
                  child: Center(
                      child: Text(
                    'Fertilizer Calculator',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  width: 100,
                  height: 100,
                  child: Center(
                      child: Text(
                    'Pests and Disease',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  width: 100,
                  height: 100,
                  child: Center(
                      child: Text(
                    'Cultivation Tips',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                ),
              ),
            ],
          )),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              height: 60,
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.camera),
                      onPressed: () {
                        captureImage();
                      }),
                  VerticalDivider(
                    color: Colors.black,
                  ),
                  IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: () {
                        pickImage();
                      }),
                ],
              ),
            ),
          ),
          SizedBox(height: 150),
          /* Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      //  Text(cityName),
                      Text(
                        '$temp°C',
                        style: TextStyle(fontSize: 30),
                      ),
                      (is12HoursFormat == true)
                          ? Text('Sunset $sunsetTime')
                          : Text('Sunset $sunsetTime pm'),
                    ],
                  ),
                ),
                Image.network(
                    'http://openweathermap.org/img/w/$iconNumber.png'),
                Text(humidity)
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          ),*/
        ],
      );*/
    default:
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("This is the home page"),
          RaisedButton(
            child: Text(
              "logout",
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('login');
              print(prefs.getString('login'));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => LoginScreen()));
            },
          )
        ],
      );
  }
}

Future getClimate() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
  latitude = _locationData.latitude.toString();
  longitude = _locationData.longitude.toString();

  var url =
      'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=';

  var response = await http.get(url);

  //print('Response status: ${response.statusCode}');
  //print('Response body: ${response.body}');
  var data = response.body.toString();
  cityName = jsonDecode(data)['name'];
  temp = jsonDecode(data)['main']['temp'].toString();
  humidity = jsonDecode(data)['main']['humidity']
      .toString(); // javascript object notation
  if ((65 <= (int.parse(humidity))) && ((int.parse(humidity)) <= 70)) {
    humidity = "Good day for Seeding";
  } else if ((50 <= (int.parse(humidity))) && ((int.parse(humidity)) <= 65)) {
    humidity = "Great day for Plants";
  } else if ((int.parse(humidity)) <= 45) {
    humidity = "Your plants need more water";
  } else {
    humidity = "Nice day";
  }
  sunrise = jsonDecode(data)['sys']['sunrise'].toString();
  sunset = jsonDecode(data)['sys']['sunset'].toString();

  clouds = jsonDecode(data)['weather'][0]['main'].toString();
  cloudsDescription = jsonDecode(data)['weather'][0]['description'].toString();
  iconNumber = jsonDecode(data)['weather'][0]['icon'].toString();
  int convert = int.parse(sunset);
  sunsetTime = DateTime.fromMillisecondsSinceEpoch(convert * 1000)
      .toString()
      .substring(11, 16);
  print(longitude);
  print(latitude);
  print(humidity);
}
