import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../utils/custom_colors.dart';
import '../controller/global_controller.dart';
import '../widgets/comfort_level.dart';
import '../widgets/current_weather_widget.dart';
import '../widgets/daily_data_forecast.dart';
import '../widgets/header_widget.dart';
import '../widgets/hourly_data_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //call the GetProvider method
  final GlobalController globalController =
  Get.put(GlobalController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // need a type of value which will check for each and every state to have been updated
        child: Obx((() => globalController.checkLoading().isTrue
            ? Center(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Image.asset(
                "assets/icons/default_icon.png",
                height: 180,
                width: 180,
              ),
              SizedBox(
                height: 70,
              ),
              const CircularProgressIndicator(
                color: customColors.firstGradientColor,
              ),
              Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "assets/icons/Ahmad.jpg",
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "Ahmad Younis",
                style: const TextStyle(
                    fontSize: 10,
                    color: customColors.textColorBlack,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        )
            : Container(
          child: Center(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                const SizedBox(height: 20),
                const HeaderWidget(),
                // for our current temperature ('current')
                CurrentWeatherWidget(
                  weatherDataCurrent:
                  globalController.getData().getCurrentWeather(),
                ),
                const SizedBox(height: 20),
                HourlyDataWidget(
                    weatherDataHourly:
                    globalController.getData().getHourlyWeather()),
                DailyDataForecast(
                  weatherDataDaily:
                  globalController.getData().getDailyWeather(),
                ),
                Container(
                  height: 1,
                  color: customColors.dividerLine,
                ),
                const SizedBox(
                  height: 10,
                ),
                comfortLevel(
                    weatherDataCurrent:
                    globalController.getData().getCurrentWeather()),
                SizedBox(
                  height: 7.5,
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    " Created By AHMAD YOUNIS",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 8,
                        color: Colors.tealAccent.shade400,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ))),
      ),
    );
  }
}
