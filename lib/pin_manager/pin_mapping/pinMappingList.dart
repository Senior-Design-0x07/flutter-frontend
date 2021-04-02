import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:hobby_hub_ui/pin_manager/pin_mapping/pinOutputResponse.dart';
import 'package:hobby_hub_ui/services/error/error_service.dart';
import 'package:hobby_hub_ui/services/http_service.dart';

import 'mapped_pin.dart';

class PinMapping extends StatefulWidget {
  @override
  _PinMappingState createState() => _PinMappingState();
}

class _PinMappingState extends State<PinMapping> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController1 = TextEditingController();

  final HttpService http = HttpService();
  List<Pin> mappedPins = [];
  Pin selectedPin;
  String pinNameValue;
  String pinType = '1';
  int buttonSelected = 0;
  bool cmdSuccess = false;
  String error;
  bool connection = true;

  Widget _showConnectionErrors() {
    switch (error) {
      case 'TimeoutException':
        return HHError(title: error, message: "Can't Connect",type: 0);
      default:
        return Text("I'M TEMPORARY in SHOW CONNECTION ERRORS");
    }
  }

  Widget _showButtonErrors() {
    switch (buttonSelected) {
      case 1: // Add Pin
        return HHError(title: 'ADD PIN', message: 'Add Pin Error', type: 1);
      case 2: // Find Pin
        return HHError(title: 'Found PIN', message: 'Found Pin Error', type: 1);
      case 3: // Clear Unused
        return HHError(
            title: 'Clear Unused', message: 'Clear Unused Pins Error', type: 1);
      case 4: // Remove All Pins
        return HHError(
            title: 'Remove All', message: 'Remove Pins Error', type: 1);
      default:
        return Text('Im Temporary in Button ERRORS!');
    }
  }

  void _handleErrors(Object error) {
    setState(() {
      this.error = error.runtimeType.toString();
      connection = false;
    });
  }

  Future<void> _refresh() {
    return http
        .getPinList(restURL: 'api/pin_manager/grab_used_pins')
        .then((_mappedPins) {
      setState(() {
        connection = true;
        mappedPins = _mappedPins;
      });
    }).catchError((Object error) {
      _handleErrors(error);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!connection && error != null)
            _showConnectionErrors(), // Connection Erros
          if (!cmdSuccess && buttonSelected != 0)
            _showButtonErrors(), //Button Errors
          Card(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  iconSize: 30.0,
                  icon: const Icon(
                    Icons.add_box_outlined,
                    color: Colors.lightGreen,
                    size: 30.0,
                  ),
                  tooltip: 'New Pin',
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Center(child: Text("Add Pin")),
                            content: Container(
                              height: 110,
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: (value) {
                                      pinNameValue = value;
                                    },
                                    controller: _textFieldController,
                                    decoration: InputDecoration(
                                        hintText: "Pin Name..."),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      pinType = value;
                                    },
                                    controller: _textFieldController1,
                                    decoration: InputDecoration(
                                        hintText: "Pin Type..."),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () async {
                                    cmdSuccess = await http
                                        .requestNewPin(
                                            restURL: 'api/pins/request_pin',
                                            pinName: pinNameValue,
                                            pinType: int.parse(pinType))
                                        .catchError((Object error) {
                                      _handleErrors(error);
                                    });
                                    buttonSelected = 1;
                                    Navigator.of(context).pop();
                                    _refresh();
                                  },
                                  child: Text('Add')),
                            ],
                          ),
                      barrierDismissible: true),
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: const Icon(
                    Icons.push_pin_outlined,
                    color: Colors.green,
                    size: 30.0,
                  ),
                  tooltip: 'Find Pin',
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Center(child: Text("Find Pin")),
                            content: TextField(
                              onChanged: (value) {
                                pinNameValue = value;
                              },
                              controller: _textFieldController,
                              decoration:
                                  InputDecoration(hintText: "Pin Name..."),
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () async {
                                    selectedPin = null;
                                    selectedPin = await http
                                        .getPin(
                                            restURL: 'api/pins/get_pin',
                                            pinName: pinNameValue)
                                        .catchError((Object error) {
                                      _handleErrors(error);
                                    });
                                    selectedPin != null
                                        ? cmdSuccess = true
                                        : cmdSuccess = false;
                                    buttonSelected = 2;
                                    Navigator.of(context).pop();
                                    _refresh();
                                  },
                                  child: Text('Request')),
                            ],
                          ),
                      barrierDismissible: true),
                ),
                IconButton(
                    iconSize: 30.0,
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.orange,
                      size: 30.0,
                    ),
                    tooltip: 'Clear Unused Pins',
                    onPressed: () async {
                      cmdSuccess = await http
                          .clearUnusedPins(
                              restURL: 'api/pin_manager/clear_unused')
                          .catchError((Object error) {
                        _handleErrors(error);
                      });
                      buttonSelected = 3;
                      _refresh();
                    }),
                IconButton(
                    iconSize: 30.0,
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.redAccent,
                      size: 30.0,
                    ),
                    tooltip: 'Reset All Pins',
                    onPressed: () async {
                      cmdSuccess = await http
                          .resetPinConfig(
                              restURL: 'api/pin_manager/reset_config')
                          .catchError((Object error) {
                        _handleErrors(error);
                      });
                      buttonSelected = 4;
                      _refresh();
                    }),
                SizedBox(
                  width: 150,
                ),
                Container(
                  child: IconButton(
                      iconSize: 30.0,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.amber,
                        size: 30.0,
                      ),
                      tooltip: 'Refresh',
                      onPressed: () {
                        _refreshIndicatorKey.currentState.show();
                      }),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: Card(
                color: Colors.grey[100],
                child: Container(
                    height: 220,
                    child: mappedPins.isNotEmpty
                        ? ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: mappedPins
                                .map((Pin pin) => MappedPin(
                                      mappedPin: pin,
                                    ))
                                .toList(),
                          )
                        : Center(
                            child: Text("No Pins Used"),
                          )),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          cmdSuccess
              ? PinOutputResponse(
                  type: buttonSelected,
                  pin: selectedPin,
                )
              : Column() //Dummy Widget, Handled with error widget above
        ],
      ),
    );
  }
}
