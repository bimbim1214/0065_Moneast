import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamfix/data/repository/auth_repository.dart';
import 'package:pamfix/data/repository/buah_repository.dart';
import 'package:pamfix/data/repository/kategori_buah_repository.dart';
import 'package:pamfix/data/repository/pembelian_repository.dart';
import 'package:pamfix/data/repository/supplier_repository.dart';
import 'package:pamfix/presentation/auth/bloc/kategori/kategori_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/login/login_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/pembelian/pembelian_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/register/register_bloc.dart';
import 'package:pamfix/presentation/auth/bloc/supplier/supplier_bloc.dart';
import 'package:pamfix/presentation/auth/buah_screen.dart';
import 'package:pamfix/presentation/auth/kategori_screen.dart';
import 'package:pamfix/presentation/auth/login_screen.dart';
import 'package:pamfix/presentation/auth/bloc/buah/buah_bloc.dart';
import 'package:pamfix/presentation/auth/pembelian_screen.dart';
import 'package:pamfix/presentation/auth/supplier_screen.dart';
import 'package:pamfix/services/service_http_client.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => 
          LoginBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => 
          RegisterBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => 
          BuahBloc(buahRepository: BuahRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => 
          KategoriBloc(kategoriRepository: KategoriRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => 
          SupplierBloc(supplierRepository: SupplierRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (context) => 
          PembelianBloc(pembelianRepository: PembelianRepository(ServiceHttpClient())),
        ),
      ],
      child: MaterialApp(
        title: 'PamFix',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const BuahScreen(), 
        // home: const KategoriScreen(),
        home: const LoginScreen(),
        // home: const SupplierScreen(),
        // home: const PembelianScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
