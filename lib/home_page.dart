import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Map<String, dynamic> values = {};

  @override
  void initState() {
    super.initState();
    _loadRemoteConfig();

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      _loadRemoteConfig();
    });
  }

  void _loadRemoteConfig() {
    setState(() {
      values = {
        'api_base_url': remoteConfig.getString('api_base_url'),
        'backend_api_base_url': remoteConfig.getString('backend_api_base_url'),
        'kirana_api_base_url': remoteConfig.getString('kirana_api_base_url'),
        'pos_api_base_url': remoteConfig.getString('pos_api_base_url'),

        // extra metadata
        'lastFetchStatus': remoteConfig.lastFetchStatus.name,
        'lastFetchTime': remoteConfig.lastFetchTime.toString(),
      };
    });
  }

  Widget buildRow(String key, dynamic value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                value.toString(),
                style: const TextStyle(color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await remoteConfig.fetchAndActivate();
    _loadRemoteConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Remote Config')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),

            ...values.entries.map((e) => buildRow(e.key, e.value)),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _refresh,
              child: const Text('Fetch Latest Config'),
            ),
          ],
        ),
      ),
    );
  }
}
