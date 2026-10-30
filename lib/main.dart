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
      title: 'RED PATA',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.lightBlue[300]!,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _start(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const WifiInfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF172019), Color(0xFF54503D), Color(0xFFE9A64F)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 90,
              left: -100,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightGreen.withValues(alpha: 0.12),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 32, 20, 12),
                    child: Text(
                      'BIENVENIDO A REDPATA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final phoneHeight =
                            constraints.maxHeight < 360
                                ? constraints.maxHeight * 0.72
                                : 300.0;
                        final routerWidth =
                            constraints.maxWidth < 320
                                ? constraints.maxWidth * 0.88
                                : 280.0;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              bottom: 80,
                              left: constraints.maxWidth * 0.17,
                              child: _buildAntenna(-0.15),
                            ),
                            Positioned(
                              bottom: 80,
                              left: constraints.maxWidth * 0.48,
                              child: _buildAntenna(0),
                            ),
                            Positioned(
                              bottom: 80,
                              right: constraints.maxWidth * 0.17,
                              child: _buildAntenna(0.15),
                            ),
                            Positioned(
                              bottom: 38,
                              child: Container(
                                width: routerWidth,
                                height: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE7E2D3),
                                      Color(0xFFA8A18D),
                                    ],
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 22,
                                      offset: Offset(0, 14),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.wifi,
                                      color: Color(0xFF263B49),
                                      size: 32,
                                    ),
                                    const SizedBox(width: 14),
                                    Text(
                                      'REDPATA',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade900,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    const Icon(
                                      Icons.circle,
                                      color: Color(0xFFFFB443),
                                      size: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 66,
                              child: Container(
                                width: phoneHeight * 0.55,
                                height: phoneHeight,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF11151B),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 24,
                                      offset: Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(21),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF55B5DB),
                                          Color(0xFFB88DC4),
                                          Color(0xFFE5A68B),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 13,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF11151B),
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.wifi,
                                          size: 66,
                                          color: Color(0xFF102E3C),
                                          shadows: [
                                            Shadow(
                                              color: Colors.white70,
                                              blurRadius: 12,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'RED PATA',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black54,
                                                blurRadius: 8,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 18,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2C3945),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                    child: SizedBox(
                      width: 230,
                      height: 58,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD98A), Color(0xFFFFF0C8)],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 14,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32),
                            onTap: () => _start(context),
                            child: const Center(
                              child: Text(
                                'COMENZAR',
                                style: TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF21180F),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAntenna(double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 8,
        height: 122,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF4D6), Color(0xFF9C927A)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 3),
            ),
          ],
        ),
      ),
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

      final locationServiceEnabled =
          await Permission.location.serviceStatus.isEnabled;

      if (!locationServiceEnabled) {
        if (!mounted) return;
        setState(() {
          errorMessage =
              'Activa la ubicación del dispositivo para que Android permita '
              'leer el nombre de la red Wi-Fi.';
        });
        return;
      }

      final name = await info.getWifiName();
      final bssid = await info.getWifiBSSID() ?? 'Desconocido';
      final ip = await info.getWifiIP() ?? 'Desconocido';
      final wifiNameUnavailable = name == null || name == '<unknown ssid>';

      if (!mounted) return;

      setState(() {
        wifiName = wifiNameUnavailable ? 'No disponible' : name;
        wifiBSSID = bssid;
        wifiIP = ip;
        if (wifiNameUnavailable) {
          errorMessage =
              'No se pudo leer el nombre de la red. Comprueba que estés '
              'conectado a Wi-Fi y que la app tenga permiso de ubicación.';
        }
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
        title: const Text('RED PATA'),
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
