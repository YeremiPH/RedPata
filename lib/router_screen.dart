import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Contenido del administrador del router; se muestra dentro de la pantalla
/// principal para conservar la barra superior e inferior.
class RouterView extends StatefulWidget {
  const RouterView({super.key});

  @override
  State<RouterView> createState() => RouterViewState();
}

class RouterViewState extends State<RouterView> {
  WebViewController? _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    String? ip;
    try {
      ip = await NetworkInfo().getWifiGatewayIP();
    } catch (_) {}
    if (!mounted) return;
    if (ip == null || ip.isEmpty) {
      setState(
        () =>
            _error =
                'No se pudo detectar la IP del router. '
                'Conéctate a una red WiFi.',
      );
      return;
    }
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('http://$ip'));
    setState(() => _controller = controller);
  }

  void reload() {
    if (_controller != null) {
      _controller!.reload();
    } else {
      setState(() => _error = null);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(controller: _controller!);
  }
}
