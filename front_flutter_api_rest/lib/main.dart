import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/cache/ClienteCacheModel.dart';
import 'package:front_flutter_api_rest/src/cache/ProductoCacheModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/shoping/carrito.dart';
import 'package:front_flutter_api_rest/src/services/firebase_service.dart';
import 'package:front_flutter_api_rest/src/services/shoping/cliente.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:one_context/one_context.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp(
    options: FirebaseConfig.options,
  );

  // Inicializa Hive
  await initializeHive();

  final themeProvider = ThemeProvider();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => ClienteService()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => themeProvider),
      ],
      child: MyApp(),
    ),
  );
}

// Función para inicializar Hive y abrir las cajas
Future<void> initializeHive() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  // Registramos el adaptador del modelo de ProductoCacheModel
  Hive.registerAdapter(ProductoCacheModelAdapter());
  Hive.registerAdapter(ClienteCacheModelAdapter());

  // Intentamos abrir la caja 'cart' solo si no está abierta.
  try {
    if (!Hive.isBoxOpen('cart')) {
      print('Abriendo la caja "cart"');
      await Hive.openBox<ProductoCacheModel>('cart');
    } else {
      print('La caja "cart" ya estaba abierta');
    }
  } catch (e) {
    print('Error al abrir la caja: $e');
  }
  // Intentamos abrir la caja 'clientecaja' solo si no está abierta.
  try {
    if (!Hive.isBoxOpen('clientecaja')) {
      print('Abriendo la caja "clientecaja"');
      // await Hive.deleteBoxFromDisk('clientecaja');
      await Hive.openBox<ClienteCacheModel>('clientecaja');
    } else {
      print('La caja "clientecaja" ya estaba abierta');
    }
  } catch (e) {
    print('Error al abrir la caja: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Cierra todas las cajas abiertas al cerrar la app
    Hive.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OneNotification(
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: AppRoutes.getRoutes(),
        navigatorKey: OneContext().key,
        builder: OneContext().builder,
      ),
    );
  }
}
