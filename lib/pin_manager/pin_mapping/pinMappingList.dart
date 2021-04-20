import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:hobby_hub_ui/pin_manager/pin_mapping/pinOutputResponse.dart';
import 'package:hobby_hub_ui/services/error/error_service.dart';
import 'package:hobby_hub_ui/services/http/http_service.dart';

class PinMapping extends StatefulWidget {
  final HttpService http;

  PinMapping({@required this.http});

  @override
  _PinMappingState createState() => _PinMappingState();
}

class _PinMappingState extends State<PinMapping> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController _textFieldController = TextEditingController();

  final List<String> _pinOptions = ["GPIO", "PWM", "I2C", "ANALOG", "SPECIAL"];
  List<Map<int, String>> tempStorage = [];
  Map<int, List<String>> _physicalPinOptions = {};
  List<Pin> mappedPins = [];
  String _pinType;
  Pin selectedPin;
  String _newPhysicalPin = "";
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

  String _selectPinType() {
    switch (_pinType) {
      case "GPIO":
        return '1';
      case "PWM":
        return '2';
      case "I2C":
        return '3';
      case "ANALOG":
        return '4';
      case "SPECIAL":
        return '5';
      default: //Default to GPIO
        return '1';
    }
  }

  Future<void> _refresh() {
    return widget.http
        .getPinList(restURL: 'api/pin_manager/grab_used_pins')
        .then((_mappedPins) {
      connection = true;
      if (_mappedPins.isNotEmpty || buttonSelected == 4)
        setState(() {
          mappedPins = _mappedPins;
        });
    }).catchError((Object error) {
      _handleErrors(error);
    });
  }

  void _arrangePhysicalPins() {
    List<String> list1 = List<String>.empty(growable: true);
    List<String> list2 = List<String>.empty(growable: true);
    List<String> list3 = List<String>.empty(growable: true);
    List<String> list4 = List<String>.empty(growable: true);
    List<String> list5 = List<String>.empty(growable: true);
    List<String> list6 = List<String>.empty(growable: true);

    for (var i = 0; i < tempStorage.length; i++) {
      tempStorage[i].forEach((pinType, pinName) {
        switch (pinType) {
          case 1:
            list1.add(pinName);
            break;
          case 2:
            list2.add(pinName);
            break;
          case 3:
            list3.add(pinName);
            break;
          case 4:
            list4.add(pinName);
            break;
          case 5:
            list5.add(pinName);
            break;
          default:
            list6.add(pinName);
            break;
        }
      });
    }
    _physicalPinOptions[1] = list1;
    _physicalPinOptions[2] = list2;
    _physicalPinOptions[3] = list3;
    _physicalPinOptions[4] = list4;
    _physicalPinOptions[5] = list5;
    _physicalPinOptions[null] = list6;
  }

  void _getPhysicalPins() async {
    if (_physicalPinOptions != {})
      tempStorage = await widget.http
          .getPhysicalPins(restURL: 'api/pin_manager/grab_physical_pins')
          .catchError((Object error) {
        _handleErrors(error);
      });
    _arrangePhysicalPins();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState.show();
    });
    _getPhysicalPins();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!connection && connectionError != null)
            _showConnectionErrors(), // Connection Errors
          if (httpServiceError != null && buttonSelected != 0)
            _showHttpServiceErrors(),
          if (!cmdSuccess && buttonSelected != 0 && httpServiceError != null)
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
                                        httpServiceError = null;
                                        cmdSuccess = await widget.http.requestNewPin(
                                          restURL:
                                              'api/pin_manager/request_pin',
                                          postBody: {
                                            "pin_name": pinNameValue,
                                            "pin_type": _selectPinType()
                                          },
                                        ).catchError((Object error) {
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
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Dismiss')),
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
                                        httpServiceError = null;
                                        selectedPin = null;
                                        selectedPin = await widget.http.getPin(
                                            restURL: 'api/pin_manager/get_pin',
                                            postBody: {
                                              "pin_name": pinNameValue
                                            }).catchError((Object error) {
                                          _handleErrors(error);
                                        });
                                        selectedPin != null
                                            ? cmdSuccess = true
                                            : cmdSuccess = false;
                                        buttonSelected = 2;
                                        _refresh();
                                      },
                                      child: Text('Search')),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Dismiss')),
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
                        httpServiceError = null;
                        cmdSuccess = await widget.http
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
                      httpServiceError = null;
                      cmdSuccess = await widget.http
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
                                .map((Pin mappedPin) => ListTile(
                                      title: Text(mappedPin.namedPin),
                                      subtitle: Row(
                                        children: [
                                          Text("Pin: "),
                                          Text(
                                            mappedPin.pin,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("  Type: "),
                                          Text(
                                            mappedPin.type.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("  In Use: "),
                                          Text(
                                            mappedPin.inUse.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      onTap: () => showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Text("Pin Info"),
                                                content: Text(
                                                    "Are these settings correct?"),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        _newPhysicalPin =
                                                            mappedPin.pin;
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (_) =>
                                                                    AlertDialog(
                                                                      title: Text(
                                                                          "Update Pin"),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text.rich(
                                                                                TextSpan(text: 'Change Pin ', children: <InlineSpan>[
                                                                                  TextSpan(
                                                                                    text: "' " + mappedPin.namedPin + " '",
                                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: " to type: ",
                                                                                    style: TextStyle(fontWeight: FontWeight.normal),
                                                                                  )
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 5),
                                                                            StatefulBuilder(builder:
                                                                                (BuildContext context, StateSetter dropDownState) {
                                                                              return DropdownButton(
                                                                                icon: const Icon(
                                                                                  Icons.push_pin_sharp,
                                                                                  color: Colors.green,
                                                                                  size: 30.0,
                                                                                ),
                                                                                isExpanded: true,
                                                                                hint: Text("Select Pin Type..."),
                                                                                items: _physicalPinOptions[mappedPin.type].map((String thing) => DropdownMenuItem<String>(child: Text(thing), value: thing)).toList(),
                                                                                onChanged: (String value) {
                                                                                  dropDownState(() {
                                                                                    _newPhysicalPin = value;
                                                                                  });
                                                                                },
                                                                                value: _newPhysicalPin,
                                                                              );
                                                                            }),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        FlatButton(
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.of(context).pop();
                                                                              cmdSuccess = await widget.http.updatePin(restURL: 'api/pin_manager/update_pin', postBody: {
                                                                                'pin_name': mappedPin.namedPin,
                                                                                'new_physical_pin': _newPhysicalPin
                                                                              }).catchError((Object error) {
                                                                                _handleErrors(error);
                                                                              });
                                                                              _refresh();
                                                                            },
                                                                            child:
                                                                                Text("Update")),
                                                                        FlatButton(
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text("Dismiss")),
                                                                      ],
                                                                    ),
                                                            barrierDismissible:
                                                                true);
                                                      },
                                                      child: Text('Change')),
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Dismiss')),
                                                ],
                                              ),
                                          barrierDismissible: true),
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
          if (cmdSuccess)
            PinOutputResponse(
              type: buttonSelected,
              pin: selectedPin,
            ),
        ],
      ),
    );
  }
}
