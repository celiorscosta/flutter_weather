import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/settings/bloc/settings_bloc.dart';
import 'package:flutter_weather/simple_bloc_observer.dart';

import 'package:flutter_weather/repositories/repositories.dart';
import 'package:flutter_weather/widgets/bloc/theme_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weather/widgets/widgets.dart';

import 'bloc/blocs.dart';
//import 'models/models.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: http.Client(),
    ),
  );
  Bloc.observer = SimpleBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(),
      ),
      BlocProvider<SettingsBloc>(
        create: (context) => SettingsBloc(),
      ),
    ],
    child: App(weatherRepository: weatherRepository),
  ));
}

class App extends StatelessWidget {
  final WeatherRepository weatherRepository;

  App({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Flutter Weather',
          theme: themeState.theme,
          home: BlocProvider(
            create: (context) =>
                WeatherBloc(weatherRepository: weatherRepository),
            child: Weather(),
          ),
        );
      },
    );
  }
}
