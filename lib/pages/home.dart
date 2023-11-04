import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final Widget chevron = Transform.rotate(
  angle: pi / 180 * -90, //convert to radians
  child: SvgPicture.asset(
    "assets/chevron-down.svg",
    semanticsLabel: 'Chevron Right',
    color: Colors.white.withOpacity(0.25),
    width: 20,
    height: 20,
  ),
);

final PanelController _panelController = PanelController();

class _HomeState extends State<Home> {
  String location = "Montreal";
  int temperature = 20;
  String tempUnit = "°C";
  String weather = "Mostly Clear";
  int tempHighest = 22;
  int tempLowest = 18;

  int _selectedIndex = 0;

  final ValueNotifier<double> currentPanelHeight = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        onPanelSlide: _updatePosition,
        minHeight: 360,
        maxHeight: 615,
        color: Colors.transparent,
        backdropEnabled: false,
        backdropColor: const Color.fromRGBO(46, 51, 90, 1),
        backdropOpacity: 1.00,
        body: _body(),
        panelBuilder: (ScrollController sc) => _buildPanelContent(sc),
      ),
    );
  }

  void _updatePosition(double percent) {
    currentPanelHeight.value = percent * 615;
  }

  Widget _body() {
    return ValueListenableBuilder(
      valueListenable: currentPanelHeight,
      builder: (context, value, widget) {
        return Stack(
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
            // Backdrop
            Container(
              color: Color.fromRGBO(
                  31, 29, 71, (currentPanelHeight.value / 615) / 1.3),
              height: double.infinity,
            ),
            ListView(
              // Weather Info
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Transform.translate(
                      offset: Offset(
                          0,
                          currentPanelHeight.value > 350
                              ? -(currentPanelHeight.value - 350) / 16
                              : 0),
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: "SF Pro Display",
                          fontSize: 34,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                          currentPanelHeight.value > 370
                              ? -(currentPanelHeight.value - 370) / 4.42
                              : 0,
                          currentPanelHeight.value > 355
                              ? -(currentPanelHeight.value - 355) / 5.5
                              : 0),
                      child: Opacity(
                        opacity: currentPanelHeight.value > 590
                            ? (1.0 -
                                    (1.0 / 8) *
                                        (currentPanelHeight.value - 590))
                                .clamp(0.0, 1.0)
                            : 1.0,
                        child: Transform.scale(
                          scale: currentPanelHeight.value > 370
                              ? 1.0 - (currentPanelHeight.value - 370) / 280
                              : 1.0,
                          child: Text(
                            "$temperature$tempUnit",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontFamily: "SF Pro Display",
                              fontSize: 76,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                          currentPanelHeight.value > 370
                              ? (currentPanelHeight.value - 370) / 9.5
                              : 0,
                          currentPanelHeight.value > 355
                              ? -(currentPanelHeight.value - 355) / 2.45
                              : 0),
                      child: Opacity(
                        opacity: currentPanelHeight.value > 590
                            ? (1.0 -
                                    (1.0 / 24) *
                                        (currentPanelHeight.value - 590))
                                .clamp(0.0, 1.0)
                            : 1.0,
                        child: Text(
                          weather,
                          style: const TextStyle(
                            color: Color(0x99EBEBF5),
                            fontWeight: FontWeight.w600,
                            fontFamily: "SF Pro Display",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                          0,
                          currentPanelHeight.value > 350
                              ? -(currentPanelHeight.value - 350) / 1.75
                              : 0),
                      child: Opacity(
                        opacity: currentPanelHeight.value > 350
                            ? (1.0 -
                                    (1.0 / 50) *
                                        (currentPanelHeight.value - 350))
                                .clamp(0.0, 1.0)
                            : 1.0,
                        child: Text(
                          "H: $tempHighest$tempUnit L: $tempLowest$tempUnit",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SF Pro Display",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                          0,
                          currentPanelHeight.value > 200
                              ? -(currentPanelHeight.value - 200) / 2.9
                              : 0), //-142
                      child: Opacity(
                        opacity: currentPanelHeight.value > 590
                            ? (0.0 +
                                    (1.0 / 24) *
                                        (currentPanelHeight.value - 590))
                                .clamp(0.0, 1.0)
                            : 0.0,
                        child: Text(
                          "$temperature$tempUnit | $weather",
                          style: const TextStyle(
                            color: Color(0x99EBEBF5),
                            fontWeight: FontWeight.w600,
                            fontFamily: "SF Pro Display",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
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
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(44.0),
                  topLeft: Radius.circular(44.0),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          const Color.fromRGBO(46, 51, 90, 1).withOpacity(0.26),
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
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: ListView(
                  controller: sc,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: Column(
                        children: [
                          Container(
                            height: 166,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              //controller: sc,
                              shrinkWrap: true,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    weatherCard(
                                        20, 30, "overcast-night-rain", "3AM"),
                                    const SizedBox(width: 10),
                                    weatherCard(20, 10,
                                        "overcast-night-drizzle", "Now"),
                                    const SizedBox(width: 10),
                                    weatherCard(
                                        19, 0, "overcast-day-haze", "5AM"),
                                    const SizedBox(width: 10),
                                    weatherCard(
                                        18, 30, "overcast-day-drizzle", "6AM"),
                                    const SizedBox(width: 10),
                                    weatherCard(
                                        19, 50, "overcast-day-drizzle", "7AM"),
                                    const SizedBox(width: 10),
                                    weatherCard(
                                        19, 45, "overcast-day-drizzle", "8AM"),
                                    const SizedBox(width: 10),
                                    weatherCard(
                                        20, 30, "overcast-day-drizzle", "9AM"),
                                    const SizedBox(width: 10),
                                    weatherCard(20, 20, "overcast", "10AM"),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(12, 24, 0, 0),
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         "Weather data provided by: ",
                          //         style: TextStyle(
                          //           color: Colors.white.withOpacity(0.8),
                          //           fontWeight: FontWeight.w300,
                          //           fontFamily: "SF Pro Text",
                          //           fontSize: 14,
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           _launchUrl(
                          //               'https://www.accuweather.com/', 'browser');
                          //         },
                          //         child: SizedBox(
                          //           height: 14,
                          //           child: Image.asset('assets/aw-logo.png'),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                            child: infoCard(
                              "assets/icons/lottie/smoke.json",
                              "AIR QUALITY",
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                    child: Text(
                                      "3 - Low Health Risk",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SF Pro Display",
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 25, 25, 0),
                                    child: CustomPaint(
                                      size: const Size(275, 1),
                                      painter: LineChartPainter(
                                          dotPosition: 1 / 11 * 3),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Divider(
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                    color: Colors.white.withOpacity(0.075),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _launchUrl('https://www.accuweather.com/',
                                          'browser');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 3, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "See more",
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SF Pro Text",
                                              fontSize: 14,
                                            ),
                                          ),
                                          chevron
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 5, 0),
                                  child: infoCard(
                                    "assets/icons/lottie/uv-index.json",
                                    "UV INDEX",
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 15, 0, 0),
                                          child: Text(
                                            '4',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: Text(
                                            'Moderate',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 25, 20, 0),
                                          child: CustomPaint(
                                            size: const Size(275, 1),
                                            painter: LineChartPainter(
                                                dotPosition: 1 / 11 * 4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 10, 15, 0),
                                  child: infoCard(
                                    "assets/icons/lottie/sunrise.json",
                                    "SUNRISE",
                                    Container(),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 5, 0),
                                  child: infoCard(
                                    "assets/icons/lottie/wind.json",
                                    "WIND",
                                    const WindWidget(
                                        windSpeed: 9.2, direction: 90),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 10, 15, 0),
                                  child: infoCard(
                                    "assets/icons/lottie/raindrop.json",
                                    "RAINFALL",
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 10, 0),
                                          child: Text(
                                            '1.8 mm in the last hour',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              15, 20, 10, 0),
                                          child: Text(
                                            '1.2 mm expected in the next 24h.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 5, 0),
                                  child: infoCard(
                                    "assets/icons/lottie/thermometer.json",
                                    "FEELS LIKE",
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 10, 0),
                                          child: Text(
                                            '19°C',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              15, 45, 10, 0),
                                          child: Text(
                                            'Similar to the actual temperature.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 10, 15, 0),
                                  child: infoCard(
                                    "assets/icons/lottie/humidity.json",
                                    "HUMIDITY",
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 10, 0),
                                          child: Text(
                                            '90%',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              15, 45, 10, 0),
                                          child: Text(
                                            'The dew point is 17°C right now.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 5, 0),
                                  child: infoCard(
                                    "assets/icons/lottie/compass.json",
                                    "VISIBILITY",
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 10, 0),
                                          child: Text(
                                            '8 km',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              15, 45, 10, 0),
                                          child: Text(
                                            'Reduced visibility due to the rain.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SF Pro Display",
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 10, 15, 0),
                                  child: infoCard(
                                    "assets/icons/lottie/barometer.json",
                                    "PRESSURE",
                                    Container(), //CircleWithLines(linesCount: 80),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget infoCard(String icon, String text, Widget content) {
    return Container(
      height: 168,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(64, 203, 216, 0.15)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Row(
              children: [
                SizedBox(
                  height: 32,
                  child: ClipPath(
                    child:
                        // ColorFiltered(
                        //   colorFilter: ColorFilter.mode(
                        //       const Color(0x99EBEBF5).withOpacity(0.4),
                        //       BlendMode.srcIn),
                        Lottie.asset(
                      icon,
                      width: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                //const SizedBox(width: 1.5),
                Text(
                  text,
                  style: TextStyle(
                      color: const Color(0x99EBEBF5).withOpacity(0.4),
                      fontWeight: FontWeight.normal,
                      fontFamily: "SF Pro Display",
                      fontSize: 16),
                ),
              ],
            ),
          ),
          content,
        ],
      ),
    );
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

class LineChartPainter extends CustomPainter {
  final double dotPosition;

  LineChartPainter({required this.dotPosition});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Path path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2);

    // Create a linear gradient for the line
    final Shader linearGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color.fromRGBO(54, 88, 177, 1), Color.fromRGBO(231, 67, 149, 1)],
    ).createShader(Rect.fromPoints(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2)));

    paint.shader = linearGradient;

    canvas.drawPath(path, paint);

    final double dotX = dotPosition * size.width;
    final double dotY = size.height / 2;
    const double dotRadius = 4.0;
    final Paint dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class WindWidget extends StatelessWidget {
  final double windSpeed;
  final int direction;

  const WindWidget(
      {super.key, required this.windSpeed, required this.direction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 125,
        height: 125,
        child: CustomPaint(
          painter: WindWidgetPainter(windSpeed, direction),
          child: const Center(),
        ),
      ),
    );
  }
}

class WindWidgetPainter extends CustomPainter {
  final double windSpeed;
  final int direction;

  WindWidgetPainter(this.windSpeed, this.direction);

  final int linesCount = 180;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 - 10;

    // Calculate the angle between each line based on the total number of lines
    final double angleBetweenLines = 360 / linesCount;

    for (int i = 0; i < linesCount; i++) {
      final double radians = i * angleBetweenLines * pi / 180;

      final double startX = centerX + radius * cos(radians);
      final double startY = centerY + radius * sin(radians);

      final double endX = centerX +
          (radius + 6.0) * cos(radians); // Adjust the length of the lines
      final double endY = centerY + (radius + 6.0) * sin(radians);

      // Calculate the opacity based on line index
      double opacity;
      if (i % 45 == 0) {
        opacity = 1.0; // 100% opacity for every 45 lines
      } else if (i % 45 == 15 || i % 45 == 30) {
        opacity = 0.75; // 75% opacity for every 15 lines
      } else {
        opacity = 0.25; // 25% opacity for other lines
      }

      final Paint linePaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      // Draw lines
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), linePaint);

      if (i == 0) {
        // Draw the arrow's body using the fully opaque top line
        final Paint arrowBodyPaint = Paint()
          ..color = Colors.white
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

        final double arrowBodyStartX = centerX;
        final double arrowBodyStartY = centerY - radius;
        final double arrowBodyEndX = centerX;
        final double arrowBodyEndY = centerY - radius - 10;

        canvas.drawLine(Offset(arrowBodyStartX, arrowBodyStartY),
            Offset(arrowBodyEndX, arrowBodyEndY), arrowBodyPaint);

        // Draw the arrow's head
        const double arrowHeadSize = 4.0;
        final Paint arrowHeadPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        final Path arrowHeadPath = Path()
          ..moveTo(centerX - arrowHeadSize, centerY - radius - 5)
          ..lineTo(centerX + arrowHeadSize, centerY - radius - 5)
          ..lineTo(centerX, arrowBodyEndY)
          ..close();

        canvas.drawPath(arrowHeadPath, arrowHeadPaint);
      }

      const String unit = "km/h";

      final TextPainter topTextPainter = TextPainter(
        text: TextSpan(
          text: windSpeed.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      final TextPainter bottomTextPainter = TextPainter(
        text: const TextSpan(
          text: unit,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      topTextPainter.layout();
      bottomTextPainter.layout();

      final double topTextX = centerX - topTextPainter.width / 2;
      final double topTextY =
          centerY - 7 - topTextPainter.height / 2; //Vertical spacing
      final double bottomTextX = centerX - bottomTextPainter.width / 2;
      final double bottomTextY = centerY + 8 - bottomTextPainter.height / 2;

      topTextPainter.paint(canvas, Offset(topTextX, topTextY));
      bottomTextPainter.paint(canvas, Offset(bottomTextX, bottomTextY));

      if (i == 135) {
        drawLabel(canvas, centerX, centerY - radius + 10, "N", Colors.red);
      }

      if (i == 0) {
        drawLabel(canvas, centerX + radius - 10, centerY, "E", Colors.white);
      } else if (i == 45) {
        drawLabel(canvas, centerX, centerY + radius - 10, "S", Colors.white);
      } else if (i == 90) {
        drawLabel(canvas, centerX - radius + 10, centerY, "W", Colors.white);
      }
    }
  }

  void drawLabel(Canvas canvas, double x, double y, String text, Color color) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    final double textX = x - painter.width / 2;
    final double textY = y - painter.height / 2;

    painter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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
