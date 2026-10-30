import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Analizador WiFi',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.lightBlue[300]!,
        ),
      ),
      home: const WifiInfoScreen(),
    );
  }
}

class WifiInfoScreen extends StatefulWidget {
  // skipInit: si es true, no llamará a _loadWifiInfo en initState.
  // Esto facilita las pruebas unitarias donde los plugins de plataforma
  // no están disponibles.
  const WifiInfoScreen({super.key, this.skipInit = false});

  final bool skipInit;

  @override
  State<WifiInfoScreen> createState() => _WifiInfoScreenState();
}

class _WifiInfoScreenState extends State<WifiInfoScreen> {
  final info = NetworkInfo();
  String wifiName = 'Desconocido';
  String wifiBSSID = 'Desconocido';
  String wifiIP = 'Desconocido';
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Solo cargamos la información si no estamos en modo "skipInit".
    if (!widget.skipInit) {
      _loadWifiInfo();
    }
  }

  Future<void> _loadWifiInfo() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final permissionStatus = await Permission.location.request();

      if (!mounted) return;

      if (!permissionStatus.isGranted) {
        setState(() {
          wifiName = 'Permiso denegado';
          wifiBSSID = '-';
          wifiIP = '-';
        });
        return;
      }

      final name = await info.getWifiName() ?? 'Desconocido';
      final bssid = await info.getWifiBSSID() ?? 'Desconocido';
      final ip = await info.getWifiIP() ?? 'Desconocido';

      if (!mounted) return;

      setState(() {
        wifiName = name;
        wifiBSSID = bssid;
        wifiIP = ip;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error al obtener datos WiFi: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildWifiInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analizador WiFi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : _loadWifiInfo,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Analizador WiFi',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () => openAppSettings(),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ayuda'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sección de ayuda en desarrollo'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    : wifiName == 'Permiso denegado'
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber,
                            size: 50,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Se necesita permiso de ubicación para obtener información WiFi',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              openAppSettings(); // Abre la configuración de la app
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue[300],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Abrir configuración',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        _buildWifiInfoCard('Nombre de la red (SSID)', wifiName),
                        _buildWifiInfoCard('Dirección MAC (BSSID)', wifiBSSID),
                        _buildWifiInfoCard('Dirección IP', wifiIP),
                        const SizedBox(height: 20),
                        if (wifiIP != 'Desconocido' && wifiIP != '-')
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Aquí podrías añadir funcionalidad adicional
                                // como un escaneo de red o test de velocidad
                              },
                              child: const Text('Realizar test de velocidad'),
                            ),
                          ),
                      ],
                    ),
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.blue[200],
            backgroundColor: Colors.black87,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.network_wifi),
                label: 'WiFi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.device_hub),
                label: 'Red',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.speed),
                label: 'Velocidad',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.security),
                label: 'Seguridad',
              ),
            ],
            onTap: (index) {
              // Aquí puedes implementar la navegación entre vistas
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sección ${index + 1} en desarrollo')),
              );
            },
          ),
        ],
      ),
    );
  }
}
