import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DevicePage extends StatefulWidget{

  final BluetoothDevice device;

  const DevicePage({super.key, required this.device});

  @override
  State createState() => _State();

}

class _State extends State<DevicePage>{

  ValueNotifier<List<double>> income_value = ValueNotifier([-1,-1]);

  BluetoothService? uartService;
  bool bluetoothWriting = false;
  double targetTemp = -1;

  // BluetoothService? bluetoothService;

  @override
  void initState() {
    super.initState();
    widget.device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        // Navigator.pop(context);
      }
    });
  }

  int bytesToInteger(List<int> bytes) {
    print("bytes");
    String charValues = '';
    for(int i in bytes){
      charValues = charValues + String.fromCharCode(i) ;
    }

    print(charValues);

    return int.parse(charValues);
  }

  List<int> integerToBytes(int n) {
    // Convert the integer to a string of characters
    String charValues = n.toString();
    print(charValues);

    // Create an empty list of bytes
    List<int> bytes = [];

    // Loop through each character and get its byte value
    for (int i = 0; i < charValues.length; i++) {
      bytes.add(charValues.codeUnitAt(i));
    }

    // Print the list of bytes
    print("bytes $bytes");

    // Return the list of bytes
    return bytes;
  }

  List<double> bytesToListNumbers(List<int> bytes) {
    print("bytes");
    String charValues = '';
    for(int i in bytes){
      charValues = charValues + String.fromCharCode(i) ;
    }

    print(charValues);

    if (charValues.isEmpty){
      return [-1,-1];
    }


    List<String> split = charValues.split(',');
    double temperature = double.parse(split[0]);
    double targetTemperature = double.parse(split[1]);
    targetTemp = targetTemperature;
    print("parsed ${temperature}, ${targetTemperature}");


    return [temperature,targetTemperature];
  }


  Future<bool> getValueChangeFromCharacteristics(BluetoothService service) async {
    // print('Future getValueChange');
    var characteristics = service.characteristics;
    // service.characteristics[0].
    print("characteristics.length: ${characteristics.length}");

    for(BluetoothCharacteristic characteristic in characteristics) {
      // print('characteristic: $characteristic');
      if(characteristic.properties.notify){
        await characteristic.setNotifyValue(true);
        StreamSubscription<dynamic> stream = characteristic.lastValueStream.listen((value) {

          print(value);

          List<double> data = bytesToListNumbers(value);
          print("Incoming Data: $data");
          income_value.value = data;

        });
      }
    }
    // print('done getValueChange');
    return true;
  }

  void increaseTemperature() async{
    if (bluetoothWriting){ return; }
    bluetoothWriting = true;
    if (uartService != null){
      print("uartService set");
      for(BluetoothCharacteristic c in uartService!.characteristics){
        if(c.properties.write){
          int temp = targetTemp.floor() + 1;
          List<int> bytes = integerToBytes(temp);
          print("sending $temp : $bytes");
          await c.write(bytes);
        }
      }
    }
    else{
      print("not uartService set");
    }
    bluetoothWriting = false;
  }

  void lowerTemperature() async{
    bluetoothWriting = false;
    print("bluetoothWriting $bluetoothWriting");
    if (bluetoothWriting){ return; }
    bluetoothWriting = true;
    if (uartService != null){
      print("uartService set");
      for(BluetoothCharacteristic c in uartService!.characteristics){
        if(c.properties.write){
          int temp = targetTemp.floor() - 1;
          List<int> bytes = integerToBytes(temp);
          print("sending $temp : $bytes");
          await c.write(bytes);
        }
      }
    }
    else{
      print("not uartService set");
    }
    bluetoothWriting = false;
  }

  Widget infoDisplay(){

    String info = "";
    double value = income_value.value[0];
    double target = income_value.value[1];


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${value.toStringAsFixed(1)} °C',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),

        const Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Divider(
            color: Colors.black54,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Text(
            'Target Temperature: ${target.toStringAsFixed(1)} °C',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),

      ],
    );

  }

  Widget bodyView(){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ValueListenableBuilder<List<double>>(
              valueListenable: income_value,
              builder: (context, value, child){
                // Color cardColor = const Color(0x9999FFFF);

                return Column(
                  children: [
                    Card(
                    // color: cardColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          children: [
                            Row(),
                            Text(
                              "Temperature Reading",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),



                            income_value.value[0] > 0 ?
                              infoDisplay() :
                              const Text('LOADING...'),

                          ],
                        ),
                      ),
                    ),

                    income_value.value[0] > 0 ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(onPressed: increaseTemperature, child: const Icon(Icons.arrow_upward)),
                          ElevatedButton(onPressed: lowerTemperature, child: const Icon(Icons.arrow_downward)),
                        ],
                      ):
                      Container(),


                  ],
                );
            }
          )
        ],
      ),
    );
  }


  FutureBuilder bluetoothBody(){
    String uart_uuid = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";

    return FutureBuilder<List<BluetoothService>>(
      future: widget.device.discoverServices(),
      builder: (BuildContext context, AsyncSnapshot<List<BluetoothService>> snapshot){
        if (snapshot.hasData){
          List<BluetoothService> services = snapshot.data!;
          bool found = false;
          services.forEach((service) {
            // do something with service
            if(found){ return; }
            if(uart_uuid == service.uuid.toString()){
              print(service.uuid);
              uartService = service;
              getValueChangeFromCharacteristics(service);
              found = true;
            }
          });
          return bodyView();

        }
        else if (snapshot.hasError){
          return const Center(child: Text('An Error Has Occurred'));
        }

        return const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      }
    );
  }


  @override
  Widget build(context){
    String deviceName = widget.device.name;
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName)
      ),
      body: Column(
        children: [
          bluetoothBody(),
        ],
      ),
    );
  }


}