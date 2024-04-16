// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:clima_app/src/components/weather_item.dart';
import 'package:clima_app/src/ui/detail_page.dart';
import 'package:clima_app/src/utils/app_colors.dart';
import 'package:clima_app/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

//Paste Your API Here
  static String API_KEY = '3de47ff79e7d46a8911164113241604';
//Default location
  String location = 'Piura';
  String weatherIcon = 'soleado.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

  String searchWeatherAPI =
      "https://api.weatherapi.com/v1/forecast.json?key=$API_KEY&days=7&lang=es&q=";

  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData["location"];

      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);

        var parsedDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        //updateWeather
        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon =
            "${currentWeatherStatus.replaceAll(' ', '').toLowerCase()}.png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        //Forecast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        // print(dailyWeatherForecast);
      });
    } catch (e) {
      //debugPrint(e);
    }
  }

  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return "${wordList[0]} ${wordList[1]}";
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        //padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: AppColors.primaryColor.withOpacity(.1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTopContainer(size, context),
              const SizedBox(height: 5),
              buildBottomContainer(size, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomContainer(Size size, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: size.height * .20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hoy',
                  style: TextStyle(
                    fontFamily: "MonB",
                    fontSize: 20.0,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailPage(
                                dailyForecastWeather: dailyWeatherForecast,
                              ))), //this will open forecast screen
                  child: const Text(
                    '+ Previsiones',
                    style: TextStyle(
                      fontFamily: "MonB",
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: ListView.builder(
              itemCount: hourlyWeatherForecast.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                String currentTime =
                    DateFormat('HH:mm:ss').format(DateTime.now());
                String currentHour = currentTime.substring(0, 2);

                String forecastTime =
                    hourlyWeatherForecast[index]["time"].substring(11, 16);
                String forecastHour =
                    hourlyWeatherForecast[index]["time"].substring(11, 13);

                String forecastWeatherName =
                    hourlyWeatherForecast[index]["condition"]["text"];
                String forecastWeatherIcon =
                    "${forecastWeatherName.replaceAll(' ', '').toLowerCase()}.png";

                String forecastTemperature =
                    hourlyWeatherForecast[index]["temp_c"].round().toString();
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  //margin: const EdgeInsets.only(right: 21),
                  width: 65,
                  decoration: BoxDecoration(
                      color: currentHour == forecastHour
                          ? Colors.white
                          : AppColors.primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: AppColors.primaryColor.withOpacity(.2),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          forecastTime,
                          style: const TextStyle(
                            fontSize: 17,
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset(
                          'assets/$forecastWeatherIcon',
                          width: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              forecastTemperature,
                              style: const TextStyle(
                                color: AppColors.greyColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'o',
                              style: TextStyle(
                                color: AppColors.greyColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                fontFeatures: [
                                  FontFeature.enable('sups'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopContainer(Size size, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: size.height * .7,
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildHeaderRow(context),
          SizedBox(height: 160, child: Image.asset("assets/$weatherIcon")),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  temperature.toString(),
                  style: TextStyle(
                    fontSize: 80,
                    fontFamily: "MonB",
                    foreground: Paint()..shader = AppColors().shader,
                  ),
                ),
              ),
              Text(
                'o',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "MonB",
                  foreground: Paint()..shader = AppColors().shader,
                ),
              ),
            ],
          ),
          Text(
            currentWeatherStatus,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 20.0,
              fontFamily: "MonB",
            ),
          ),
          Text(
            currentDate,
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: "MonM",
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(
              color: Colors.white70,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WeatherItem(
                  value: windSpeed.toInt(),
                  unit: 'km/h',
                  imageUrl: 'assets/windspeed.png',
                  title: "Velocidad\ndel viento",
                ),
                WeatherItem(
                  value: humidity.toInt(),
                  unit: '%',
                  imageUrl: 'assets/humidity.png',
                  title: "Humedad",
                ),
                WeatherItem(
                  value: cloud.toInt(),
                  unit: '%',
                  imageUrl: 'assets/cloud.png',
                  title: "Nubosidad",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/menu.png",
          width: 40,
          height: 40,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/pin.png",
              width: 20,
            ),
            const SizedBox(width: 5),
            Text(
              location,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            buscadorWidget(context),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            "assets/avatar.png",
            width: 40,
            height: 40,
          ),
        ),
      ],
    );
  }

  Widget buscadorWidget(BuildContext context) {
    return IconButton(
      onPressed: () {
        _cityController.clear();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 1,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 70,
                        child: Divider(
                          thickness: 3.5,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: _cityController,
                        onChanged: (searchText) {
                          fetchWeatherData(searchText);
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Al escribir tu ciudad, el clima se cambia automaticamente",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: "MonM",
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
