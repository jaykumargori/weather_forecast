
# Weather Forecast

Beautiful Weather App using OpeanWeatherApi with support for dark mode. Created Jaykumar Gori.



## Getting Started
Provide instructions for setting up the project on a local machine. Include any prerequisites, installation steps, and configuration required.

Prerequisites
List any software, tools, or dependencies that need to be installed before running the project. For example:

- Flutter
- Dart
- OpenWeatherApiKey (For Weather Data)


## Run Locally

Clone the project

```bash
  git clone https://github.com/jaykumargori/weather_forecast
```

Go to the project directory

```bash
  cd weather_forecast
```

Install dependencies

```bash
  flutter pub get
```

Add OpenWeatherMap API KEY on lib/api/api_key.dart

```bash
  String apiKey = "<ADD API KEY HERE>";
```


Run the project:

```bash
  flutter run
```


## Screenshots

![App Screenshot](https://drive.google.com/file/d/13T4tXZgy_jElhuJGZDY9iUgcbh60bppr/view?usp=drive_link)

![App Screenshot](https://drive.google.com/file/d/1TA_LwMq6zyTiIYt0-h0IYU2lf5_Dbrw5/view?usp=drive_link)

![App Screenshot](https://drive.google.com/file/d/19KVEMTp3d6RbBex0GbE2zJ1XJdOS1LIG/view?usp=drive_link)

![App Screenshot](https://drive.google.com/file/d/1T8GQUlsMkMz5kq-T9zUT3PGOEQlD9sXt/view?usp=drive_link)

![App Screenshot](https://drive.google.com/file/d/1h3aesF5e3-EruPgXVx66MmH9oWwsRew0/view?usp=drive_link)

![App Screenshot](https://drive.google.com/file/d/1dFLmep5eIhu9AMvlO2VqWfzRm4Hd27b4/view?usp=drive_link)



## Contributing

Contributions are always welcome!



## Authors

Jaykumar Gori

- Github: https://github.com/jaykumargori
- LinkedIn: https://www.linkedin.com/in/jaykumar-gori-06593b203/


## Tech Stack

**Client:** Flutter, Dart


## Documentation

- FLutter https://docs.flutter.dev/

- Dart https://dart.dev/guides

- GetX State Management

GetX is a fast, stable, and light state management library in flutter. There are so many State Management libraries in flutter like MobX, BLoC, Redux, Provider, etc. GetX is also a powerful micro framework and using this, we can manage states, make routing, and can perform dependency injection.

GetX offers a range of benefits for state management in Flutter, including::
Lightweight and efficient: GetX is incredibly lightweight and efficient, making it ideal for small to large-scale applications. It provides a reactive approach to state management that only rebuilds the parts of your UI that need updating, ensuring your application runs smoothly and efficiently.
Easy to learn: GetX has a small learning curve, making it easy for developers to learn and implement. It provides intuitive APIs that are easy to understand and use, making it an excellent choice for both beginner and experienced developers.
Built-in dependency injection: GetX includes built-in dependency injection, allowing you to easily manage dependencies within your application. This feature makes it easy to switch between dependencies and manage them across your application.
Great community support: GetX has a great community that is constantly contributing new features, bug fixes, and support for the library. The community is also very active on social media, making it easy to get help and support when you need it.
There are three principles of GetX:
Performance: As compared to other state management libraries, GetX is best because it consumes minimum resources and provides better performance.
Productivity: GetX’s syntax is easy so it is productive. It saves a lot of time for the developers and increases the speed of the app because it does not use extra resources. It uses only those resources which arecurrently needed and after its work is done, the resources will free automatically. If all the resources are loaded into the memory then it will not be that productive. So better to use GetX for this.
Organization: GetX code is organized as View, Logic, navigation, and dependency injection. So we don’t need any more context to navigate to other screen. We can navigate to screen without using the context so we are not dependent on widget tree.
GetX Managements:
State Management: There are two types of state management:
Simple State Manager: It uses GetBuilder.
Reactive State Manager: It uses GetX and Obx.
Route Management: If we want to make Widgets like Snackbar, Bottomsheets, dialogs, etc. Then we can use GetX for it because GetX can build these widgets without using context.
Dependency Management: If we want to fetch data from other Class then with the help of GetX, we can do this in just a single line of code. Eg: Get.put()


## API Reference

- One Call API 3.0 (OpenWeather) https://openweathermap.org/api/one-call-3

