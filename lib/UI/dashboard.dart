import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UI/card.dart';
import '../UI/last_update_txt.dart';
import '../repositories/data_repo.dart';
import '../repositories/endpoints_data.dart';
import '../services/api.dart';
import 'alert_dialog.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;

  @override
  initState() {
    super.initState();
    final dataRepo = Provider.of<DataRepo>(context, listen: false);
    _endpointsData = dataRepo.getAllEndpointsCachedData();
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      final dataRepo = Provider.of<DataRepo>(context, listen: false);
      final endpointsData = await dataRepo.getAllEndpointsData();

      //print(endpointsData.toString());

      setState(() {
        _endpointsData = endpointsData;
      });
      // on SocketException was identified by turning off wifi
    } on SocketException catch (e) {
      //print('Error Caught!!!');
      //print(e);

      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data. Please try again later.',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later.',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Covid Tracker'),
      ),
      // RefreshIndicator is the pull to refresh
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: [
            LastUpdateStatusText(
                // Use conditional operator "date?.toString()" incase the date is null - "??" if it is, then return the empty string
                lastUpdated: _endpointsData != null ? _endpointsData.values[Endpoint.cases]?.date : null),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointsData != null ? _endpointsData.values[endpoint]?.value : null,
              )
          ],
        ),
      ),
    );
  }
}
