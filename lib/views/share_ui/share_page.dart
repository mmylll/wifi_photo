import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_photo/components/constants.dart';
import 'package:wifi_photo/components/dialogs.dart';
import 'package:wifi_photo/controllers/controllers.dart';
import 'package:wifi_photo/models/sender_model.dart';
import 'package:wifi_photo/services/photon_sender.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/components.dart';

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  SenderModel senderModel = PhotonSender.getServerInfo();
  PhotonSender photonSender = PhotonSender();
  late double width;
  late double height;
  bool willPop = false;
  var receiverDataInst = GetIt.I.get<ReceiverDataController>();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: null,
              title: const Text('Share'),
              leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    sharePageAlertDialog(context);
                  }),
              flexibleSpace: Container(
                decoration: appBarGradient,
              )
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (width > 720) ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/share.json',
                          width: 240,
                        ),
                        SizedBox(
                          width: width / 8,
                        ),
                        SizedBox(
                          width: width > 720 ? 200 : 100,
                          height: width > 720 ? 200 : 100,
                          child: QrImage(
                            size: 150,
                            foregroundColor: Colors.black,
                            data: PhotonSender.getPhotonLink,
                            backgroundColor: Colors.white,
                          ),
                        )
                      ],
                    )
                  } else ...{
                    Lottie.asset(
                      'assets/lottie/share.json',
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: QrImage(
                        foregroundColor: Colors.white,
                        data: PhotonSender.getPhotonLink,
                        backgroundColor: Colors.black,
                      ),
                    )
                  },
                  Text(
                    '${photonSender.hasMultipleFiles ? 'Your files are ready to be shared' : 'Your file is ready to be shared'}\nAsk receiver to tap on receive button',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width > 720 ? 18 : 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //receiver data
                  Obx((() => GetIt.I
                      .get<ReceiverDataController>()
                      .receiverMap
                      .isEmpty
                      ? Card(
                    color: const Color.fromARGB(255, 241, 241, 241),
                    clipBehavior: Clip.antiAlias,
                    elevation: 8,
                    // color: Platform.isWindows ? Colors.grey.shade300 : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    child: SizedBox(
                      height: width > 720 ? 200 : 128,
                      width: width > 720 ? width / 2 : width / 1.25,
                      child: Center(
                        child: Wrap(
                          direction: Axis.vertical,
                          children: infoList(
                              senderModel,
                              width,
                              height,
                              true,
                              "bright"),
                        ),
                      ),
                    ),
                  )
                      : SizedBox(
                    width: width / 1.2,
                    child: Card(
                      color: const Color.fromARGB(
                          255, 241, 241, 241),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemCount:
                        receiverDataInst.receiverMap.length,
                        itemBuilder: (context, item) {
                          var keys = receiverDataInst
                              .receiverMap.keys
                              .toList();
                          var data = receiverDataInst.receiverMap;
                          return ListTile(
                            title: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text("Sharing status"),
                                  ),
                                  const Divider(
                                    thickness: 2.4,
                                    indent: 20,
                                    endIndent: 20,
                                    color: Color.fromARGB(
                                        255, 109, 228, 113),
                                  ),
                                  Center(
                                    child: Text(
                                        "Receiver name : ${data[keys[item]]['os']}"),
                                  ),
                                  data[keys[item]]['isCompleted'] ==
                                      'true'
                                      ? const Center(
                                    child: Text(
                                      "All files sent",
                                      textAlign:
                                      TextAlign.center,
                                    ),
                                  )
                                      : Center(
                                    child: Text(
                                        "Sending '${data[keys[item]]['currentFileName']}' (${data[keys[item]]['currentFileNumber']} out of ${data[keys[item]]['filesCount']} files)"),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ))),
                ],
              ),
            ),
          )),
      onWillPop: () async {
        willPop = await sharePageWillPopDialog(context);
        GetIt.I.get<ReceiverDataController>().receiverMap.clear();
        return willPop;
      },
    );
  }
}
