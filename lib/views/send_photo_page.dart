import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/data_event.dart';
import 'package:nearby_connections/nearby_connections.dart';

class SendPhotoPage extends StatefulWidget {
  SendPhotoPage({Key? key,  required this.path}) : super(key: key);

  String path;

  @override
  State<SendPhotoPage> createState() => _SendPhotoPageState();
}

class _SendPhotoPageState extends State<SendPhotoPage> {
  late ScrollController _controller = ScrollController();
  String offset = "0";

  final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = Map();

  String? tempFileUri; //reference to the file currently being transferred
  Map<int, String> map = Map(); //store filename mapped to corresponding payloadId

  @override
  void initState() {
    super.initState();
    //监听滚动事件，打印滚动位置
    // _controller.addListener(() {
    //   print(_controller.offset); //打印滚动位置
    //   print(_controller.position.maxScrollExtent);
    // });

    // eventBus.on<DataEvent>().listen((DataEvent data) => changeData(data.data));
  }

  changeData(data){
    //若不对mounted进行判断，会报错 setState() called after dispose()
    // if(mounted){
      setState(() {
        _controller.jumpTo(data);
        print('data');
        print(data);
        offset = data;
      });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;

    return Scaffold(
      body: ListView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        children: [
          Container(
            width: width,
            // child: Image.asset('assets/images/icon.png',),
            color: const Color(0x266693FF),
            alignment: Alignment.center,
          ),
          Container(
            width: width,
            child: Image.file(File(widget.path),),
            color: const Color(0x266693FF),
            alignment: Alignment.center,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:
        Colors.white,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Help"),
                  content: ListView(
                    children: <Widget>[
                      Text("User Name: " + userName),
                      Wrap(
                        children: <Widget>[
                          ElevatedButton(
                            child: Text("Start Advertising"),
                            onPressed: () async {
                              try {
                                bool a = await Nearby().startAdvertising(
                                  userName,
                                  strategy,
                                  onConnectionInitiated: onConnectionInit,
                                  onConnectionResult: (id, status) {
                                    showSnackbar(status);
                                  },
                                  onDisconnected: (id) {
                                    showSnackbar(
                                        "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
                                    setState(() {
                                      endpointMap.remove(id);
                                    });
                                  },
                                );
                                showSnackbar("ADVERTISING: " + a.toString());
                              } catch (exception) {
                                showSnackbar(exception);
                              }
                            },
                          ),
                          ElevatedButton(
                            child: Text("Stop Advertising"),
                            onPressed: () async {
                              await Nearby().stopAdvertising();
                            },
                          ),
                        ],
                      ),
                      Wrap(
                        children: <Widget>[
                          ElevatedButton(
                            child: Text("Start Discovery"),
                            onPressed: () async {
                              try {
                                bool a = await Nearby().startDiscovery(
                                  userName,
                                  strategy,
                                  onEndpointFound: (id, name, serviceId) {
                                    // show sheet automatically to request connection
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (builder) {
                                        return Center(
                                          child: Column(
                                            children: <Widget>[
                                              Text("id: " + id),
                                              Text("Name: " + name),
                                              Text("ServiceId: " + serviceId),
                                              ElevatedButton(
                                                child: Text("Request Connection"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Nearby().requestConnection(
                                                    userName,
                                                    id,
                                                    onConnectionInitiated: (id, info) {
                                                      onConnectionInit(id, info);
                                                    },
                                                    onConnectionResult: (id, status) {
                                                      showSnackbar(status);
                                                    },
                                                    onDisconnected: (id) {
                                                      setState(() {
                                                        endpointMap.remove(id);
                                                      });
                                                      showSnackbar(
                                                          "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  onEndpointLost: (id) {
                                    showSnackbar(
                                        "Lost discovered Endpoint: ${endpointMap[id]!.endpointName}, id $id");
                                  },
                                );
                                showSnackbar("DISCOVERING: " + a.toString());
                              } catch (e) {
                                showSnackbar(e);
                              }
                            },
                          ),
                          ElevatedButton(
                            child: Text("Stop Discovery"),
                            onPressed: () async {
                              await Nearby().stopDiscovery();
                            },
                          ),
                        ],
                      ),
                      Text("Number of connected devices: ${endpointMap.length}"),
                      ElevatedButton(
                        child: Text("Stop All Endpoints"),
                        onPressed: () async {
                          await Nearby().stopAllEndpoints();
                          setState(() {
                            endpointMap.clear();
                          });
                        },
                      ),
                      Divider(),
                      Text(
                        "Sending Data",
                      ),
                      ElevatedButton(
                        child: Text("Send Random Bytes Payload"),
                        onPressed: () async {
                          endpointMap.forEach((key, value) {
                            String a = Random().nextInt(100).toString();

                            showSnackbar("Sending $a to ${value.endpointName}, id: $key");
                            Nearby()
                                .sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
                          });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close)),
                  ],
                );
              });
        },
        icon: const Text("Help"),
        label: const Icon(Icons.help),
      ),
    );

  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  Future<bool> moveFile(String uri, String fileName) async {
    String parentDir = (await getExternalStorageDirectory())!.absolute.path;
    final b =
    await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

    showSnackbar("Moved file:" + b.toString());
    return b;
  }

  /// Called upon Connection request (on both devices)
  /// Both need to accept connection to start sending/receiving
  void onConnectionInit(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              Text("id: " + id),
              Text("Token: " + info.authenticationToken),
              Text("Name" + info.endpointName),
              Text("Incoming: " + info.isIncomingConnection.toString()),
              ElevatedButton(
                child: Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    endpointMap[id] = info;
                  });
                  Nearby().acceptConnection(id,
                    onPayLoadRecieved: (endid, payload) async {
                      if (payload.type == PayloadType.BYTES) {
                        String str = String.fromCharCodes(payload.bytes!);
                        showSnackbar(endid + ": " + str);
                        changeData(double.parse(str));
                      }
                    },
                    // onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                    //   if (payloadTransferUpdate.status ==
                    //       PayloadStatus.IN_PROGRESS) {
                    //     print(payloadTransferUpdate.bytesTransferred);
                    //   } else if (payloadTransferUpdate.status ==
                    //       PayloadStatus.FAILURE) {
                    //     print("failed");
                    //     showSnackbar(endid + ": FAILED to transfer file");
                    //   } else if (payloadTransferUpdate.status ==
                    //       PayloadStatus.SUCCESS) {
                    //     showSnackbar(
                    //         "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");
                    //
                    //     if (map.containsKey(payloadTransferUpdate.id)) {
                    //       //rename the file now
                    //       String name = map[payloadTransferUpdate.id]!;
                    //       moveFile(tempFileUri!, name);
                    //     } else {
                    //       //bytes not received till yet
                    //       map[payloadTransferUpdate.id] = "";
                    //     }
                    //   }
                    // },
                  );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return SendPage( title: 'bvf',
                  //       );
                  //     },
                  //   ),
                  // );

                },
              ),
              ElevatedButton(
                child: Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}