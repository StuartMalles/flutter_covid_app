import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../repositories/endpoints_data.dart';
import 'api.dart';
import 'endpoint_data.dart';

class DataCacheService {
  final SharedPreferences sharedPreferences;
  DataCacheService({@required this.sharedPreferences});

  static String endpointValueKey(Endpoint endpoint) => '$endpoint/value';
  static String endpointDateKey(Endpoint endpoint) => '$endpoint/date';

  EndpointsData getData() {
    Map<Endpoint, EndpointData> values = {};
    Endpoint.values.forEach((endpoint) {
      final value = sharedPreferences.getInt(endpointValueKey(endpoint));
      final dateString = sharedPreferences.getString(endpointDateKey(endpoint));

      if (value != null && dateString != null) {
        final date = DateTime.tryParse(dateString);
        values[endpoint] = EndpointData(value: value, date: date);
      }
    });

    return EndpointsData(values: values);
  }

  Future<void> setData(EndpointsData data) async {
    data.values.forEach((endpoint, endPointdata) async {
      await sharedPreferences.setInt(endpointValueKey(endpoint), endPointdata.value);
      await sharedPreferences.setString(endpointDateKey(endpoint), endPointdata.date.toIso8601String());
    });
  }
}
