import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_example/connectivity/connectivity_cubit.dart';
import 'package:connectivity_plus_example/ui/home/widgets/text_widget.dart';
import 'package:connectivity_plus_example/ui/no_internet/no_internet_screen.dart';
import 'package:connectivity_plus_example/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey containerKey = GlobalKey();

  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252429),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showAlertDialog(context,
                onTap: (){
                  saveToGallery();
                  saveCheck();
                  Navigator.of(context).pop();
                },
                shareOnTap: (){
                  shareToTelegram();
                  Navigator.of(context).pop();
                }
              );
              // saveToGallery();
            },
            icon: const Icon(
              Icons.share,
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
        title: const Text("Hisobotlar"),
        backgroundColor: const Color(0xFF252429),
      ),
      body: BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (context, state) {
          if (state.connectivityResult == ConnectivityResult.none) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NoInternetScreen(voidCallback: () {})));
          }
        },
        child: ListView(
          children: [
            RepaintBoundary(
              key: containerKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    "assets/img.png",
                    width: 60,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Perevod s karti na kartu",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '27 000 ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        TextSpan(
                            text: "so'm",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.circleCheck, color: Colors.blue, size: 30,),
                      SizedBox(width: 8,),
                      Text("Muvoffaqqiyatli", style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.w500),)
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const TextWidget(text1: "Sana va vaqt:", text2: "12.10.2023 12:20 da"),
                  const TextWidget(text1: "To'lov kartasi:", text2: "860031******2968"),
                  const TextWidget(text1: "Yuboruvchi:", text2: "DILSHODBEK SAYITQULOV"),
                  const TextWidget(text1: "Qabul qiluvchining kartasi:", text2: "986002******6428"),
                  const TextWidget(text1: "Qabul qiluvchi:", text2: "MURTOZAYEV ORZUBEK"),
                  const TextWidget(text1: "To'lov raqami:", text2: "2792791524"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                    child: Divider(height: 1, color: Colors.white.withOpacity(0.6),),
                  ),
                  const TextWidget(text1: "Komissiya:", text2: "270 so'm"),
                  const SizedBox(height: 12,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _takeScreenshot<Uint8List>() async {
    RenderRepaintBoundary boundary = containerKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    var im = await boundary.toImage();
    var byteData = await im.toByteData(format: ImageByteFormat.png);
    setState(() {
      imageBytes = byteData!.buffer.asUint8List();
    });
    return byteData!.buffer.asUint8List();
  }

  shareToTelegram() async{
    const String fileName = 'screenshot.png';
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$fileName';
    File(filePath).writeAsBytesSync(imageBytes!);
    Share.shareFiles([filePath], text: "Share qilasizmi!");
  }

  saveToGallery() async {
    await PermissionUtil.requestAll();
    var pngBytes = await _takeScreenshot();
    var t = await ImageGallerySaver.saveImage(pngBytes);
  }

  void showAlertDialog(BuildContext context,{required VoidCallback onTap,required VoidCallback shareOnTap}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF444444),
          title: const Text('Tanlang:', style: TextStyle(color: Colors.white),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: onTap,
                child: const Text('Yuklab olish', style: TextStyle(color: Colors.white),),
              ),
              TextButton(
                onPressed: shareOnTap,
                child: const Text('Ulashish', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      },
    );
  }

}
