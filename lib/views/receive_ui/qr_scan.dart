import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_photo/models/sender_model.dart';
import 'package:wifi_photo/views/receive_ui/progress_page.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
import '../../components/constants.dart';
import '../../services/photon_receiver.dart';
import 'package:qrscan/qrscan.dart' as scan;

class QrReceivePage extends StatefulWidget {
  const QrReceivePage({
    super.key,
  });

  @override
  State<QrReceivePage> createState() => _QrReceivePageState();
}

class _QrReceivePageState extends State<QrReceivePage> {
  _scan() async {
    await Permission.camera.request();
    var resp = await scan.scan();
    return resp;
  }

  bool isDenied = false;
  bool hasErr = false;
  late StateSetter innerState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: null,
          title: const Text(" QR - receive"),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: Container(
            decoration: appBarGradient,
          )
        ),
        body: FutureBuilder(
          future: _scan(),
          builder: (context, AsyncSnapshot snap) {
            if (snap.connectionState == ConnectionState.done) {
              handleQrReceive(snap.data);
              return StatefulBuilder(
                builder: (BuildContext context, sts) {
                  innerState = sts;
                  return hasErr
                      ? const Center(
                    child: Text(
                      'Wrong QR code or \n Devices are not connected to same network',
                      textAlign: TextAlign.justify,
                    ),
                  )
                      : isDenied
                      ? const Center(
                    child: Text('Sender denied,please retry'),
                  )
                      : const Center(
                    child: Text("Waiting for sender to approve"),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: null,
          onPressed: () async {
            setState(() {
              hasErr = isDenied = false;
            });
          },
          label: const Text('Retry'),
          icon: const Icon(
            Icons.refresh,
            color: Color.fromARGB(255, 75, 231, 81),
          ),
        ));
  }

  handleQrReceive(link) async {
    try {
      String host = Uri.parse(link).host;
      int port = Uri.parse(link).port;
      SenderModel senderModel =
          await PhotonReceiver.isPhotonServer(host, port.toString());

      var resp = await PhotonReceiver.isRequestAccepted(
        senderModel,
      );
      if (resp['accepted']) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProgressPage(
                senderModel: senderModel,
                secretCode: resp['code'],
              );
            },
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        innerState(() {
          isDenied = true;
        });
      }
    } catch (_) {
      innerState(() {
        hasErr = true;
      });
    }
  }
}
