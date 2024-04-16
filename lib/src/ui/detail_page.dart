// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:clima_app/src/components/weather_item.dart';
import 'package:clima_app/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final dynamic dailyForecastWeather;

  const DetailPage({super.key, this.dailyForecastWeather});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  //function to get weather
  Map getForecastWeather(int index) {
    final weatherData = widget.dailyForecastWeather;
    int maxWindSpeed = weatherData[index]["day"]["maxwind_kph"].toInt();
    int avgHumidity = weatherData[index]["day"]["avghumidity"].toInt();
    int chanceOfRain =
        weatherData[index]["day"]["daily_chance_of_rain"].toInt();

    var parsedDate = DateTime.parse(weatherData[index]["date"]);
    var forecastDate = DateFormat('EEEE, d MMMM').format(parsedDate);

    String weatherName = weatherData[index]["day"]["condition"]["text"];
    String weatherIcon = "${weatherName.replaceAll(' ', '').toLowerCase()}.png";

    int minTemperature = weatherData[index]["day"]["mintemp_c"].toInt();
    int maxTemperature = weatherData[index]["day"]["maxtemp_c"].toInt();

    var forecastData = {
      'maxWindSpeed': maxWindSpeed,
      'avgHumidity': avgHumidity,
      'chanceOfRain': chanceOfRain,
      'forecastDate': forecastDate,
      'weatherName': weatherName,
      'weatherIcon': weatherIcon,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature
    };
    return forecastData;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.text),
        title: const Text(
          'Previsiones',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "MonB",
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  print("Settings Tapped!");
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
      body: Column(
        //alignment: Alignment.center,
        //clipBehavior: Clip.none,
        children: [
          const SizedBox(height: 20),
          containerDayClima(size),
          const SizedBox(height: 20),
          const Text(
            "Previsiones para una semana",
            style: TextStyle(
              color: AppColors.blueColors,
              fontSize: 20,
              fontFamily: "MonB",
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SizedBox(
              width: size.width * .9,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, index) => forecastCard(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget containerDayClima(Size size) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.center,
                colors: [
                  Color(0xffa9c1f5),
                  Color(0xff6696f5),
                ]),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(.1),
                offset: const Offset(0, 25),
                blurRadius: 3,
                spreadRadius: -10,
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/" + getForecastWeather(0)["weatherIcon"],
                      height: 150,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    getForecastWeather(0)["maxTemperature"].toString(),
                    style: TextStyle(
                      fontSize: 80,
                      fontFamily: "MonB",
                      foreground: Paint()..shader = AppColors().shader,
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
                  const SizedBox(width: 10),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getForecastWeather(0)["weatherName"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: "MonB",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: size.width * .8,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeatherItem(
                      value: getForecastWeather(0)["maxWindSpeed"],
                      unit: "km/h",
                      imageUrl: "assets/windspeed.png",
                      title: "Velocidad\ndel viento",
                    ),
                    WeatherItem(
                      value: getForecastWeather(0)["avgHumidity"],
                      unit: "%",
                      imageUrl: "assets/humidity.png",
                      title: "Humedad\npromedio",
                    ),
                    WeatherItem(
                      value: getForecastWeather(0)["chanceOfRain"],
                      unit: "%",
                      imageUrl: "assets/lightrain.png",
                      title: "Probabilidad\nde lluvia",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget forecastCard(int index) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  getForecastWeather(index)["forecastDate"],
                  style: const TextStyle(
                    color: Color(0xff6696f5),
                    fontFamily: "MonB",
                  ),
                ),
                Row(
                  children: [
                    temperatureRow(index, "minTemperature", Colors.grey),
                    const Text(
                      ' / ',
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 30,
                        fontFamily: "MonB",
                      ),
                    ),
                    temperatureRow(
                        index, "maxTemperature", AppColors.blackColor),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                weatherRow(index),
                chanceOfRainRow(index),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget temperatureRow(int index, String temperatureKey, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getForecastWeather(index)[temperatureKey].toString(),
          style: TextStyle(
            color: color,
            fontSize: 30,
            fontFamily: "MonB",
          ),
        ),
        Text(
          'o',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontFamily: "MonM",
            fontFeatures: const [
              FontFeature.enable('sups'),
            ],
          ),
        ),
      ],
    );
  }

  Widget weatherRow(int index) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/' + getForecastWeather(index)["weatherIcon"],
            width: 30,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              getForecastWeather(index)["weatherName"],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: "MonB",
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget chanceOfRainRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${getForecastWeather(index)["chanceOfRain"]}%",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Image.asset(
          'assets/lightrain.png',
          width: 30,
        ),
      ],
    );
  }
}
