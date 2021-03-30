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
  String codeDialog;
  bool cmdButtonPressed = false;
  int type;

  // Widget _showMappedPinList(List<Pin> pins) {
  //   // return FutureBuilder(
  //   //   future: http.getPinList(restURL: 'api/pin_manager/grab_used_pins'),
  //   //   builder: (BuildContext context, AsyncSnapshot snapshot) {
  //   //     if (snapshot.hasData) {
  //   List<Pin> mappedPins = [];
  //   return Expanded(
  //     child: ListView(
  //       children: mappedPins
  //           .map((Pin pin) => MappedPin(
  //                 mappedPin: pin,
  //               ))
  //           .toList(),
  //     ),
  //   );
  //   // } else {
  //   //   return Column(
  //   //     children: [
  //   //       SizedBox(
  //   //         height: 25,
  //   //       ),
  //   //       Text("Grabbing Data"),
  //   //       SizedBox(
  //   //         height: 20,
  //   //       ),
  //   //       Center(child: CircularProgressIndicator()),
  //   //     ],
  //   //   );
  //   // }
  //   //   },
  //   // );
  // }

  Widget _checkCmdButton() {
    if (cmdButtonPressed) {
      cmdButtonPressed = false;
      return PinOutputResponse(
        type: type,
      );
    } else {
      return Column();
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
                icon: const Icon(
                  Icons.add_box_outlined,
                  color: Colors.lightGreen,
                  size: 35.0,
                ),
                tooltip: 'Request New Pin',
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text("Add Pin"),
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
                                  await http.requestNewPin(
                                      restURL: 'api/pins/request_pin',
                                      pinName: pinNameValue);
                                  setState(() {
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
                icon: const Icon(
                  Icons.push_pin_outlined,
                  color: Colors.green,
                  size: 35.0,
                ),
                tooltip: 'Get Pin',
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text("Find Pin"),
                          content: TextField(
                            onChanged: (value) {
                              setState(() {
                                pinNameValue = value;
                              });
                            },
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () async {
                                  await http.requestNewPin(
                                      restURL: 'api/pins/request_pin',
                                      pinName: 'sdfghj');
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: Text('REQUEST')),
                          ],
                        ),
                    barrierDismissible: true),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.orange,
                    size: 35.0,
                  ),
                  tooltip: 'Clear Unused Pins',
                  onPressed: () async {
                    await http.clearUnusedPins(
                        restURL: 'api/pin_manager/clear_unused');
                    setState(() {
                      _refresh();
                    });
                  }),
              IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.redAccent,
                    size: 35.0,
                  ),
                  tooltip: 'Reset All Pins',
                  onPressed: () async {
                    await http.resetPinConfig(
                        restURL: 'api/pin_manager/reset_config');
                    setState(() {
                      _refresh();
                    });
                  }),
              SizedBox(
                width: 100,
              ),
              Container(
                child: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.amber,
                      size: 35.0,
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
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: mappedPins
                      .map((Pin pin) => MappedPin(
                            mappedPin: pin,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        _checkCmdButton(),
      ],
    );
  }
}
