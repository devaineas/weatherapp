import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String location = "Montreal";
  int temperature = 20;
  String tempUnit = "°C";
  String weather = "Mostly Clear";
  int tempHighest = 22;
  int tempLowest = 18;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 360,
        maxHeight: 615,
        color: Colors.transparent,
        backdropEnabled: true,
        backdropColor: const Color.fromRGBO(46, 51, 90, 1),
        backdropOpacity: 1.00,
        body: Stack(
          children: <Widget>[
            //Background
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 300,
              height: 300,
              margin: const EdgeInsets.fromLTRB(30, 215, 0, 100),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/house.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListView(
              //Weather Info
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: "SF Pro Display",
                        fontSize: 34,
                      ),
                    ),
                    Text(
                      "$temperature$tempUnit",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontFamily: "SF Pro Display",
                        fontSize: 76,
                      ),
                    ),
                    Text(
                      weather,
                      style: const TextStyle(
                        color: Color(0x99EBEBF5),
                        fontWeight: FontWeight.w600,
                        fontFamily: "SF Pro Display",
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "H: $tempHighest$tempUnit L: $tempLowest$tempUnit",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SF Pro Display",
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        panelBuilder: (ScrollController sc) => _buildPanelContent(sc),
      ),
    );
  }

  Widget _buildPanelContent(ScrollController sc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          height: 615,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          const Color.fromRGBO(46, 51, 90, 1).withOpacity(0.26),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(44.0),
                        topLeft: Radius.circular(44.0),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 100,
                thickness: 1,
                color: Colors.white.withOpacity(0.075),
              ),
              Divider(
                height: 101,
                thickness: 1,
                color: Colors.black.withOpacity(0.15),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 0, 0),
                child: Container(
                  width: 115,
                  height: 1,
                  color: _selectedIndex == 0
                      ? Colors.white.withOpacity(0.2)
                      : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(220, 48, 0, 0),
                child: Container(
                  width: 115,
                  height: 1,
                  color: _selectedIndex == 1
                      ? Colors.white.withOpacity(0.2)
                      : Colors.transparent,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Text(
                        "Hourly Forecast",
                        style: TextStyle(
                          color: const Color(0x99EBEBF5).withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                          fontFamily: "SF Pro Text",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: SizedBox(
                      width: 48.0,
                      height: 5.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: const Color(0xFF000000).withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 24, 0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Text(
                        "Weekly Forecast",
                        style: TextStyle(
                          color: const Color(0x99EBEBF5).withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                          fontFamily: "SF Pro Text",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 64, 0, 0),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        weatherCard(20, 30, "overcast-night-rain", "3AM"),
                        const SizedBox(width: 10),
                        weatherCard(19, 10, "overcast-night-drizzle", "Now"),
                        const SizedBox(width: 10),
                        weatherCard(18, 0, "overcast-day-haze", "5AM"),
                        const SizedBox(width: 10),
                        weatherCard(18, 30, "overcast-day-drizzle", "6AM"),
                        const SizedBox(width: 10),
                        weatherCard(19, 50, "overcast-day-rain", "7AM"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 24, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "Weather data provided by: ",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                            fontFamily: "SF Pro Text",
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchUrl(
                                'https://www.accuweather.com/', 'browser');
                          },
                          child: SizedBox(
                            height: 14,
                            child: Image.asset('assets/aw-logo.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  //   child: Container(
                  //     width: 320,
                  //     height: 160,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //           color: const Color.fromRGBO(72, 49, 157, 0.5)),
                  //       borderRadius: BorderRadius.circular(30),
                  //       color: const Color.fromRGBO(31, 29, 71, 0.2),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              infoCard(
                  "assets/icons/lottie/uv-index.json", "UV INDEX", Container()),
            ],
          ),
        ),
      ],
    );
  }

  Widget weatherCard(
      int temperature, int humidity, String iconName, String time) {
    return IntrinsicHeight(
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(64, 203, 216, 0.15)),
          borderRadius: BorderRadius.circular(30),
          color: time == "Now"
              ? const Color.fromRGBO(72, 49, 157, 1)
              : const Color.fromRGBO(72, 49, 157, 0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: "SF Pro Text",
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 32,
              child: ClipPath(
                child: Lottie.asset(
                  'assets/icons/lottie/$iconName.json',
                  width: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "$humidity%",
              style: const TextStyle(
                color: Color.fromRGBO(64, 203, 216, 1),
                fontWeight: FontWeight.w600,
                fontFamily: "SF Pro Text",
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "$temperature°C",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: "SF Pro Display",
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String icon, String text, Container content) {
    return (Container(
      height: 168,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(64, 203, 216, 0.15)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 32,
                child: ClipPath(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        const Color(0x99EBEBF5).withOpacity(0.4),
                        BlendMode.srcIn),
                    child: Lottie.asset(
                      icon,
                      width: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 3),
              Text(
                text,
                style: TextStyle(
                    color: const Color(0x99EBEBF5).withOpacity(0.4),
                    fontWeight: FontWeight.normal,
                    fontFamily: "SF Pro Display",
                    fontSize: 16),
              )
            ],
          ),
        ],
      ),
    ));
  }
}

Future<void> _launchUrl(String url, String m) async {
  Uri uri = Uri.parse(url);
  LaunchMode mode = LaunchMode.inAppWebView;
  if (m == 'browser') {
    mode = LaunchMode.externalApplication;
  }

  if (!await launchUrl(uri, mode: mode)) {
    throw Exception('Could not launch $uri');
  }
}



// Container(
        //   alignment: Alignment.bottomCenter,
        //   height: 370,
        //   width: double.infinity,
        //   child: Stack(
        //     children: <Widget>[
        //       ClipRRect(
        //         child: BackdropFilter(
        //           filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        //           child: Container(
        //             decoration: BoxDecoration(
        //               color:
        //                   const Color.fromRGBO(46, 51, 90, 1).withOpacity(0.26),
        //               borderRadius: const BorderRadius.only(
        //                 topRight: Radius.circular(44.0),
        //                 topLeft: Radius.circular(44.0),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       Divider(
        //         height: 100,
        //         thickness: 1,
        //         color: Colors.white.withOpacity(0.2),
        //       ),
        //       Divider(
        //         height: 101,
        //         thickness: 1,
        //         color: Colors.black.withOpacity(0.2),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.fromLTRB(24, 48, 0, 0),
        //         child: Container(
        //           width: 115,
        //           height: 1,
        //           color: _selectedIndex == 0
        //               ? Colors.white.withOpacity(0.2)
        //               : Colors.transparent,
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.fromLTRB(220, 48, 0, 0),
        //         child: Container(
        //           width: 115,
        //           height: 1,
        //           color: _selectedIndex == 1
        //               ? Colors.white.withOpacity(0.2)
        //               : Colors.transparent,
        //         ),
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.fromLTRB(24, 10, 0, 0),
        //             child: TextButton(
        //               onPressed: () {
        //                 setState(() {
        //                   _selectedIndex = 0;
        //                 });
        //               },
        //               child: Text(
        //                 "Hourly Forecast",
        //                 style: TextStyle(
        //                   color: const Color(0x99EBEBF5).withOpacity(0.4),
        //                   fontWeight: FontWeight.w600,
        //                   fontFamily: "SF Pro Text",
        //                   fontSize: 14,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        //             child: SizedBox(
        //               width: 48.0,
        //               height: 5.0,
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(10.0),
        //                 child: Container(
        //                   color: const Color(0xFF000000).withOpacity(0.3),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.fromLTRB(0, 10, 24, 0),
        //             child: TextButton(
        //               onPressed: () {
        //                 setState(() {
        //                   _selectedIndex = 1;
        //                 });
        //               },
        //               child: Text(
        //                 "Weekly Forecast",
        //                 style: TextStyle(
        //                   color: const Color(0x99EBEBF5).withOpacity(0.4),
        //                   fontWeight: FontWeight.w600,
        //                   fontFamily: "SF Pro Text",
        //                   fontSize: 14,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.fromLTRB(24, 64, 0, 0),
        //         child: IntrinsicHeight(
        //           child: Container(
        //             width: 60,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(30),
        //               color: const Color.fromRGBO(72, 49, 157, 0.2),
        //             ),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: <Widget>[
        //                 const SizedBox(height: 20),
        //                 const Text(
        //                   "12AM",
        //                   style: TextStyle(
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.w600,
        //                     fontFamily: "SF Pro Text",
        //                     fontSize: 14,
        //                   ),
        //                 ),
        //                 const SizedBox(height: 20),
        //                 SizedBox(
        //                   height: 32,
        //                   child: ClipPath(
        //                     child: Lottie.asset(
        //                       'assets/icons/lottie/partly-cloudy-night-rain.json',
        //                       width: 32,
        //                       fit: BoxFit.cover,
        //                     ),
        //                   ),
        //                 ),
        //                 const Text(
        //                   "30%",
        //                   style: TextStyle(
        //                     color: Color.fromRGBO(64, 203, 216, 1),
        //                     fontWeight: FontWeight.w600,
        //                     fontFamily: "SF Pro Text",
        //                     fontSize: 13,
        //                   ),
        //                 ),
        //                 const SizedBox(height: 20),
        //                 const Text(
        //                   "19°C",
        //                   style: TextStyle(
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.normal,
        //                     fontFamily: "SF Pro Display",
        //                     fontSize: 18,
        //                   ),
        //                 ),
        //                 const SizedBox(height: 20),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        // Positioned(
        //   left: 10,
        //   right: 10,
        //   bottom: 10,
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         Expanded(
        //           child: Padding(
        //             padding: const EdgeInsets.only(right: 8.0),
        //             child: Column(
        //               children: [
        //                 Row(
        //                   children: [
        //                     SizedBox(
        //                       height: 32,
        //                       width: 32,
        //                       child: ClipPath(
        //                         child: Lottie.asset(
        //                           'assets/icons/lottie/sunrise.json',
        //                           fit: BoxFit.cover,
        //                         ),
        //                       ),
        //                     ),
        //                     const SizedBox(width: 8),
        //                     const Text(
        //                       "Sunrise: ",
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.w300,
        //                         fontFamily: "SF Pro Text",
        //                         fontSize: 13,
        //                       ),
        //                     ),
        //                     const Text(
        //                       "5:13 AM",
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.normal,
        //                         fontFamily: "SF Pro Text",
        //                         fontSize: 13,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 const SizedBox(height: 8),
        //                 Row(
        //                   children: [
        //                     SizedBox(
        //                       height: 32,
        //                       width: 32,
        //                       child: ClipPath(
        //                         child: Lottie.asset(
        //                           'assets/icons/lottie/sunset.json',
        //                           fit: BoxFit.cover,
        //                         ),
        //                       ),
        //                     ),
        //                     const SizedBox(width: 8),
        //                     const Text(
        //                       "Sunset: ",
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.w300,
        //                         fontFamily: "SF Pro Text",
        //                         fontSize: 13,
        //                       ),
        //                     ),
        //                     const Text(
        //                       "8:12 PM",
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.normal,
        //                         fontFamily: "SF Pro Text",
        //                         fontSize: 13,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Expanded(
        //           child: Align(
        //             alignment: Alignment.centerRight,
        //             child: Padding(
        //               padding: const EdgeInsets.only(left: 8.0),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.end,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.end,
        //                     children: [
        //                       SizedBox(
        //                         height: 32,
        //                         width: 32,
        //                         child: ClipPath(
        //                           child: Lottie.asset(
        //                             'assets/icons/lottie/moonrise.json',
        //                             fit: BoxFit.cover,
        //                           ),
        //                         ),
        //                       ),
        //                       const SizedBox(width: 8),
        //                       const Text(
        //                         "Moonrise: ",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w300,
        //                           fontFamily: "SF Pro Text",
        //                           fontSize: 13,
        //                         ),
        //                       ),
        //                       const Text(
        //                         "2:56 PM",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.normal,
        //                           fontFamily: "SF Pro Text",
        //                           fontSize: 13,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   const SizedBox(height: 8),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.end,
        //                     children: [
        //                       SizedBox(
        //                         height: 32,
        //                         width: 32,
        //                         child: ClipPath(
        //                           child: Lottie.asset(
        //                             'assets/icons/lottie/moonset.json',
        //                             fit: BoxFit.cover,
        //                           ),
        //                         ),
        //                       ),
        //                       const SizedBox(width: 8),
        //                       const Text(
        //                         "Moonset: ",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w300,
        //                           fontFamily: "SF Pro Text",
        //                           fontSize: 13,
        //                         ),
        //                       ),
        //                       const Text(
        //                         "1:18 AM",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.normal,
        //                           fontFamily: "SF Pro Text",
        //                           fontSize: 13,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        //     ],
        //   ),
        // ),