import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  String errorMessage = 'Waiting for user input...';
  String buttonText = 'Scan for devices';
  bool isScanning = false;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  List<BluetoothDevice> discoveredDevices = [];

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    _stopScan();
    super.dispose();
  }

  Future<void> startBluetoothProcess() async {
    if (isScanning) return;

    setState(() {
      isScanning = true;
      errorMessage = 'Initializing Bluetooth...';
      discoveredDevices.clear();
    });

    if (await FlutterBluePlus.isSupported == false) {
      setState(() {
        errorMessage = 'Bluetooth not supported on this device.';
        isScanning = false;
      });
      return;
    }

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        _startScan();
      } else {
        setState(() {
          errorMessage = 'Please enable Bluetooth';
          isScanning = false;
        });
      }
    }, onError: (e) {
      setState(() {
        errorMessage = 'Bluetooth error: ${e.toString()}';
        isScanning = false;
      });
    });
  }

  void _startScan() async {
    setState(() {
      errorMessage = 'Scanning for devices...';
    });

    // Setup scan listener
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty) {
        final newDevices = results
            .where((r) => !discoveredDevices.any((d) => d.remoteId == r.device.remoteId))
            .map((r) => r.device)
            .toList();

        if (newDevices.isNotEmpty) {
          setState(() {
            discoveredDevices.addAll(newDevices);
            errorMessage = 'Found ${discoveredDevices.length} device(s)';
          });
        }
      }
    }, onError: (e) {
      setState(() {
        errorMessage = 'Scan error: ${e.toString()}';
        isScanning = false;
      });
    });

    // Start scan
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to start scan: ${e.toString()}';
        isScanning = false;
      });
    }
  }

  Future<void> _stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
      _scanResultsSubscription?.cancel();
      setState(() {
        isScanning = false;
        errorMessage = 'Scan stopped. Found ${discoveredDevices.length} device(s)';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error stopping scan: ${e.toString()}';
      });
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() => errorMessage = 'Connecting to ${device.platformName}...');

    try {
      StreamSubscription<BluetoothConnectionState>? connectionSubscription;
      connectionSubscription = device.connectionState.listen((state) async {
        if (state == BluetoothConnectionState.disconnected) {
          setState(() => errorMessage = 'Disconnected from ${device.platformName}');
        }
      });
      device.cancelWhenDisconnected(connectionSubscription, delayed: true);

      await device.connect(autoConnect: false);
      setState(() => errorMessage = 'Connected to ${device.platformName}!');
      List<BluetoothService> services = await device.discoverServices();
      print("Discovered services: $services");
    } catch (e) {
      setState(() => errorMessage = 'Connection failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Scanner'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(errorMessage),
            const SizedBox(height: 10),
            if (isScanning) const CircularProgressIndicator(),
            if (discoveredDevices.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Discovered Devices:', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: discoveredDevices.length,
                  itemBuilder: (context, index) {
                    final device = discoveredDevices[index];
                    return ListTile(
                      title: Text(device.platformName.isEmpty ? 'Unknown Device' : device.platformName),
                      subtitle: Text(device.remoteId.str),
                      trailing: IconButton(
                        icon: const Icon(Icons.bluetooth),
                        onPressed: () {
                          _connectToDevice(device);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isScanning ? _stopScan : startBluetoothProcess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanning ? Colors.red : Colors.lightBlue,
                ),
                child: Text(isScanning ? 'Stop Scanning' : 'Scan for Devices'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}