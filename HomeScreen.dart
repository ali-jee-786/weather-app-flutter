import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_2/Models/WeatherApiModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // http://api.weatherapi.com/v1/forecast.json?key=ce0c412a493248d3b7150637231008&q=islamabad&days=7

  final TextEditingController _searchController = TextEditingController();

  Future<WeatherApiModel> getWeatherApi() async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=ce0c412a493248d3b7150637231008&q=' +
            _searchController.text.toLowerCase() +
            '&aqi=no'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return WeatherApiModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('lib/assets/bg.jpg')),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Image(
                height: 130,
                image: AssetImage('lib/assets/sun.png'),
              ),
              const Row(children: [
                Text(
                  '   World Weather',
                  style: TextStyle(color: Colors.white, fontSize: 26),
                )
              ]),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by city name',
                      prefixIcon: const Icon(Icons.search_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.cancel_outlined, color: Colors.grey,),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color: Colors.white70),
                      )),
                ),
              ),
              FutureBuilder(
                  future: getWeatherApi(),
                  builder: (context, AsyncSnapshot<WeatherApiModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      String cityname = snapshot.data!.location!.name.toString();
                      if (_searchController.text.isEmpty) {
                        return Container();
                      }
                      else if (cityname.toLowerCase().contains(_searchController.text.toLowerCase())) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            FutureBuilder(
                                future: getWeatherApi(),
                                builder: (context,
                                    AsyncSnapshot<WeatherApiModel> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SpinKitCircle(
                                      color: Colors.white,
                                      size: 50,
                                    );
                                  } else {
                                    return Center(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.22,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.89,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color(0xff4e54c8),
                                            Color(0xff8f94fb),
                                          ]),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(13),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    snapshot.data!.current!
                                                            .tempC
                                                            .toString() +
                                                        '°C',
                                                    style: const TextStyle(
                                                        fontSize: 45,
                                                        color: Colors.white),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Humidity: ' +
                                                            snapshot
                                                                .data!
                                                                .current!
                                                                .humidity
                                                                .toString() +
                                                            '%',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white70),
                                                      ),
                                                      Text(
                                                          'Wind: ' +
                                                              snapshot
                                                                  .data!
                                                                  .current!
                                                                  .windKph
                                                                  .toString() +
                                                              'kph',
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              ListTile(
                                                title: Text(
                                                  snapshot.data!.location!.name
                                                          .toString() +
                                                      ', ' +
                                                      snapshot.data!.location!
                                                          .country
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                subtitle: Text(
                                                  snapshot.data!.current!
                                                      .condition!.text
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white54),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
