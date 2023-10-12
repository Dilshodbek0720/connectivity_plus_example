import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_example/connectivity/connectivity_cubit.dart';
import 'package:connectivity_plus_example/ui/home/home_screen.dart';
import 'package:connectivity_plus_example/ui/no_internet/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ConnectivityCubit(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
      // Scaffold(
      //     body: BlocListener<ConnectivityCubit, ConnectivityState>(
      //   listener: (context, state) {
      //     if (state.connectivityResult == ConnectivityResult.none) {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) =>
      //                   NoInternetScreen(voidCallback: () {})));
      //     }
      //   },
      //   child: SizedBox(
      //     width: MediaQuery.of(context).size.width,
      //     height: MediaQuery.of(context).size.height,
      //     child: Image.network("https://images.unsplash.com/photo-1495344517868-8ebaf0a2044a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1906&q=80", fit: BoxFit.cover,),
      //   ),
      // )),
    );
  }
}
