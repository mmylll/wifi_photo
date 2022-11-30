import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:wifi_photo/services/photon_sender.dart';
import 'package:wifi_photo/views/receive_ui/qr_scan.dart';
import '../../components/snackbar.dart';
import '../../methods/methods.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../models/sender_model.dart';
import '../../services/photon_receiver.dart';
import '../receive_ui/progress_page.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({Key? key}) : super(key: key);

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  PhotonSender photonSePhotonSender = PhotonSender();
  bool isLoading = false; // Create a controller to send instructions to scanner

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isLoading) ...{
          Card(
            color: const Color.fromARGB(255, 241, 241, 241),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            child: InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await handleSharing(context);
                setState(() {
                  isLoading = false;
                });
              },
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/lottie/rocket-send.json',
                    width: size.width / 1.6,
                    height: size.height / 6,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Share',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Card(
            color: const Color.fromARGB(255, 241, 241, 241),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            child: InkWell(
              onTap: () {
                if (Platform.isAndroid || Platform.isIOS) {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/receivepage');
                                  },
                                  child: const Text('Normal mode'),
                                ),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                // ElevatedButton(
                                //   onPressed: () async {
                                //     Navigator.of(context).push(
                                //         MaterialPageRoute(
                                //             builder: (context) {
                                //               return const QrReceivePage();
                                //             }));
                                //   },
                                //   child: const Text('QR Code mode'),
                                // )
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  Navigator.of(context).pushNamed('/receivepage');
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Lottie.asset(
                    'assets/lottie/receive-file.json',
                    width: size.width / 1.6,
                    height: size.height / 6,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Receive',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        } else ...{
          Center(
            child: SizedBox(
              width: size.width / 4,
              height: size.height / 4,
              child: Lottie.asset(
                'assets/lottie/setting_up.json',
                width: 100,
                height: 100,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Please wait !',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          )
        },
      ],
    );
  }
}
