import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:hobby_hub_ui/pin_manager/pin_mapping/pinOutputResponse.dart';
import 'package:hobby_hub_ui/services/error/error_service.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';

import 'mapped_pin.dart';

class PinMapping extends StatefulWidget {
  @override
  _PinMappingState createState() => _PinMappingState();
}

class _PinMappingState extends State<PinMapping> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController _textFieldController = TextEditingController();

  final HttpService http = HttpService();
  final List<String> _pinOptions = ["GPIO", "PWM", "I2C", "ANALOG", "SPECIAL"];
  String _pinType;
  List<Pin> mappedPins = [];
  Pin selectedPin;
  String pinNameValue = "";
  int buttonSelected = 0;
  bool cmdSuccess = false;
  bool connection = true;
  List<String> connectionError;
  String httpServiceError;

  Widget _showConnectionErrors() {
    switch (connectionError[0]) {
      case 'Timeout':
        return HHError(
            title: connectionError[0] + " Exception",
            message: "Can't Connect",
            type: 0);
      default:
        return HHError(
            title: "Exception",
            message: "A connection error has ocurred",
            type: 0);
    }
  }

  Widget _showHttpServiceErrors() {
    switch (httpServiceError.split(":")[0]) {
      case 'Exception': //Generic Exceptions from HTTP_SERVICE
        return HHError(
            title: httpServiceError.split(":")[0],
            message: httpServiceError.split("Exception: ")[1],
            type: 0);
      default:
        return HHError(
            title: "Exception", message: "An error has ocurred", type: 0);
    }
  }

  Widget _showButtonErrors() {
    switch (buttonSelected) {
      case 1: // Add Pin
        return HHError(title: 'Add Pin', message: 'Add Pin Error', type: 1);
      case 2: // Find Pin
        return HHError(
            title: 'Found Pin', message: 'Could not find pin', type: 1);
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
      error.toString().split("Exception")[0] == "Timeout"
          ? connection = false
          : connection = true;
      error.toString().split("Exception")[0] != ""
          ? this.connectionError = error.toString().split("Exception")
          : this.httpServiceError = error.toString();
    });
  }

  Widget _showNoPins() {
    return AlertDialog(
      title: Center(child: Text("No Pins Used")),
      content: Text('There are no pins mapped yet.'),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Dismiss')),
      ],
    );
  }

  _selectPinType() {
    switch (_pinType) {
      case "GPIO":
        return 1;
      case "PWM":
        return 2;
      case "I2C":
        return 3;
      case "ANALOG":
        return 4;
      case "SPECIAL":
        return 5;
      default: //Default to GPIO
        return 1;
    }
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
          if (!connection && connectionError != null)
            _showConnectionErrors(), // Connection Errors
          if (pinNameValue == "" &&
              httpServiceError != null &&
              buttonSelected != 0)
            _showHttpServiceErrors(),
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
                    onPressed: () {
                      showDialog(
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
                                      StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter dropDownState) {
                                        return DropdownButton(
                                          icon: const Icon(
                                            Icons.push_pin_sharp,
                                            color: Colors.green,
                                            size: 30.0,
                                          ),
                                          isExpanded: true,
                                          hint: Text("Select Pin Type..."),
                                          items: _pinOptions
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                      child: Text(item),
                                                      value: item))
                                              .toList(),
                                          onChanged: (String value) {
                                            dropDownState(() {
                                              _pinType = value;
                                            });
                                          },
                                          value: _pinType,
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        cmdSuccess = await http
                                            .requestNewPin(
                                                restURL: 'api/pins/request_pin',
                                                pinName: pinNameValue,
                                                pinType: _selectPinType())
                                            .catchError((Object error) {
                                          _handleErrors(error);
                                        });
                                        //Get rid of null
                                        cmdSuccess == null
                                            ? cmdSuccess = false
                                            : cmdSuccess = true;
                                        buttonSelected = 1;
                                        _refresh();
                                      },
                                      child: Text('Add')),
                                ],
                              ),
                          barrierDismissible: true);
                    }),
                IconButton(
                  iconSize: 30.0,
                  icon: const Icon(
                    Icons.push_pin_outlined,
                    color: Colors.green,
                    size: 30.0,
                  ),
                  tooltip: 'Find Pin',
                  onPressed: () {
                    if (mappedPins.isNotEmpty) {
                      showDialog(
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
                                        Navigator.of(context).pop();
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
                                        _refresh();
                                      },
                                      child: Text('Request')),
                                ],
                              ),
                          barrierDismissible: true);
                    } else {
                      buttonSelected = 0;
                      showDialog(
                          context: context,
                          builder: (_) => _showNoPins(),
                          barrierDismissible: true);
                    }
                  },
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
                      if (mappedPins.isNotEmpty) {
                        cmdSuccess = await http
                            .clearUnusedPins(
                                restURL: 'api/pin_manager/clear_unused')
                            .catchError((Object error) {
                          _handleErrors(error);
                        });
                        //Get rid of null
                        cmdSuccess == null
                            ? cmdSuccess = false
                            : cmdSuccess = true;
                        buttonSelected = 3;
                        _refresh();
                      } else {
                        buttonSelected = 0;
                        showDialog(
                            context: context,
                            builder: (_) => _showNoPins(),
                            barrierDismissible: true);
                      }
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
                      //Get rid of null
                      cmdSuccess == null
                          ? cmdSuccess = false
                          : cmdSuccess = true;
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
                        buttonSelected = 0;
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
