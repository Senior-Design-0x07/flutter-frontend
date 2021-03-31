import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/models/pin.dart';
import 'package:hobby_hub_ui/pin_manager/pin_mapping/pinOutputResponse.dart';
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

  final HttpService http = HttpService();
  List<Pin> mappedPins = [];
  Pin selectedPin;
  String pinNameValue;
  int type;
  bool cmdSuccess = false;
  bool cmdButtonPressed = false;

  Widget _checkCmdButton() {
    if (cmdButtonPressed) {
      cmdButtonPressed = false;
      return Text("Hello");
      // return PinOutputResponse(
      //   type: type,
      //   cmdSuccess: cmdSuccess,
      //   pin: selectedPin,
      // );
    } else {
      return Column(children: [Text("BLAH!!")],);
    }
  }

  Future<Null> _refresh() {
    return http
        .getPinList(restURL: 'api/pin_manager/grab_used_pins')
        .then((_mappedPins) {
      setState(() {
        mappedPins = _mappedPins;
      });
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
    return Column(
      children: [
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
                          content: TextField(
                            onChanged: (value) {
                              setState(() {
                                pinNameValue = value;
                              });
                            },
                            controller: _textFieldController,
                            decoration:
                                InputDecoration(hintText: "Pin Name..."),
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () async {
                                  await http.requestNewPin(
                                      restURL: 'api/pins/request_pin',
                                      pinName: pinNameValue);
                                  setState(() {
                                    cmdButtonPressed = true;
                                    type = 1;
                                    _refresh();
                                    Navigator.of(context).pop();
                                  });
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
                              setState(() {
                                pinNameValue = value;
                              });
                            },
                            controller: _textFieldController,
                            decoration:
                                InputDecoration(hintText: "Pin Name..."),
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () async {
                                  cmdButtonPressed = true;
                                  selectedPin = await http.getPin(
                                      restURL: 'api/pins/get_pin',
                                      pinName: pinNameValue);
                                  setState(() {
                                    type = 2;
                                    Navigator.of(context).pop();
                                  });
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
                    cmdSuccess = await http.clearUnusedPins(
                        restURL: 'api/pin_manager/clear_unused');
                    setState(() {
                      type = 3;
                      _refresh();
                    });
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
                    cmdButtonPressed = true;
                    cmdSuccess = await http.resetPinConfig(
                        restURL: 'api/pin_manager/reset_config');
                    setState(() {
                      type = 4;
                      _refresh();
                    });
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
        _checkCmdButton(),
      ],
    );
  }
}
