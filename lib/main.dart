import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repositories/data_repo.dart';
import 'services/api_service.dart';
import 'services/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/dashboard.dart';
import 'services/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreference = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreference));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({Key key, this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<DataRepo>(
      create: (_) => DataRepo(
          apiService: APIService(API.sandbox()),
          dataCacheService: DataCacheService(sharedPreferences: sharedPreferences)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid Tracker',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF101010), cardColor: Color(0xFF222222)),
        home: Dashboard(),
      ),
    );
  }
}
