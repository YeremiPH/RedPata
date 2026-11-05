import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpeedView extends StatefulWidget {
  const SpeedView({super.key});

  @override
  State<SpeedView> createState() => SpeedViewState();
}

class SpeedViewState extends State<SpeedView> {
  static const _host = 'speed.cloudflare.com';
  static const _maxGauge = 200.0;

  bool running = false;
  String phase = 'Listo para medir';
  double current = 0;
  double? download;
  double? upload;
  double? ping;
  String? error;

  Future<void> start() async {
    if (running) return;
    setState(() {
      running = true;
      error = null;
      current = 0;
      download = null;
      upload = null;
      ping = null;
    });

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      await _measurePing(client);
      await _measureDownload(client);
      await _measureUpload(client);
      if (mounted) setState(() => phase = 'Prueba completada');
    } catch (_) {
      if (mounted) {
        setState(() {
          error =
              'No se pudo completar la prueba. Comprueba tu conexión a '
              'internet e inténtalo de nuevo.';
          phase = 'Error';
        });
      }
    } finally {
      client.close(force: true);
      if (mounted) {
        setState(() {
          running = false;
          current = 0;
        });
      }
    }
  }

  Future<void> _measurePing(HttpClient client) async {
    setState(() => phase = 'Midiendo ping...');
    final times = <int>[];
    for (var i = 0; i < 5; i++) {
      final sw = Stopwatch()..start();
      final req = await client.getUrl(
        Uri.https(_host, '/__down', {'bytes': '0'}),
      );
      final res = await req.close();
      await res.drain<void>();
      sw.stop();
      times.add(sw.elapsedMilliseconds);
    }
    // El primer intento incluye la conexión TLS, así que se descarta.
    final useful = times.skip(1);
    if (!mounted) return;
    setState(() => ping = useful.reduce((a, b) => a + b) / useful.length);
  }

  Future<void> _measureDownload(HttpClient client) async {
    setState(() => phase = 'Midiendo descarga...');
    final req = await client.getUrl(
      Uri.https(_host, '/__down', {'bytes': '30000000'}),
    );
    final res = await req.close();
    final sw = Stopwatch()..start();
    var bytes = 0;
    await for (final chunk in res) {
      bytes += chunk.length;
      if (sw.elapsedMilliseconds > 150 && mounted) {
        setState(() => current = _mbps(bytes, sw));
      }
      if (sw.elapsed > const Duration(seconds: 8)) break;
    }
    sw.stop();
    if (!mounted) return;
    setState(() => download = _mbps(bytes, sw));
  }

  Future<void> _measureUpload(HttpClient client) async {
    setState(() {
      phase = 'Midiendo subida...';
      current = 0;
    });
    const total = 8000000;
    const chunkSize = 100000;
    final chunk = List<int>.filled(chunkSize, 65);

    final req = await client.postUrl(Uri.https(_host, '/__up'));
    req.headers.contentType = ContentType.binary;
    req.contentLength = total;

    final sw = Stopwatch()..start();
    var sent = 0;
    while (sent < total) {
      req.add(chunk);
      await req.flush();
      sent += chunkSize;
      if (sw.elapsedMilliseconds > 150 && mounted) {
        setState(() => current = _mbps(sent, sw));
      }
      if (sw.elapsed > const Duration(seconds: 8)) break;
    }
    // Si se corta por tiempo, se completa el cuerpo para cerrar la petición.
    if (sent < total) {
      req.add(List<int>.filled(total - sent, 65));
    }
    final res = await req.close();
    await res.drain<void>();
    sw.stop();
    if (!mounted) return;
    setState(() => upload = _mbps(sent, sw));
  }

  double _mbps(int bytes, Stopwatch sw) {
    final seconds = sw.elapsedMicroseconds / 1000000;
    if (seconds <= 0) return 0;
    return bytes * 8 / seconds / 1000000;
  }

  Widget _stat(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: Colors.lightBlue[300]),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(double? v, String unit) =>
      v == null ? '--' : '${v.toStringAsFixed(1)} $unit';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            width: 260,
            height: 200,
            child: CustomPaint(
              painter: _GaugePainter(
                value: current,
                max: _maxGauge,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Align(
                alignment: const Alignment(0, 0.55),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      current.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Mbps', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(phase, style: const TextStyle(fontSize: 16)),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              _stat('Descarga', _fmt(download, 'Mbps'), Icons.download),
              _stat('Subida', _fmt(upload, 'Mbps'), Icons.upload),
              _stat('Ping', _fmt(ping, 'ms'), Icons.timer),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: running ? null : start,
            icon: const Icon(Icons.speed),
            label: Text(running ? 'Midiendo...' : 'Iniciar prueba'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.value, required this.max, required this.color});

  final double value;
  final double max;
  final Color color;

  static const _start = math.pi * 0.8;
  static const _sweep = math.pi * 1.4;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.55);
    final radius = math.min(size.width / 2, size.height * 0.55) - 12;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round
          ..color = Colors.white12;
    canvas.drawArc(rect, _start, _sweep, false, track);

    // Escala no lineal para que velocidades bajas también se aprecien.
    final fraction = (math.sqrt(value / max)).clamp(0.0, 1.0);
    final progress =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round
          ..color = color;
    canvas.drawArc(rect, _start, _sweep * fraction, false, progress);

    final angle = _start + _sweep * fraction;
    final needle =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      center + Offset(math.cos(angle), math.sin(angle)) * (radius - 22),
      needle,
    );
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.max != max || old.color != color;
}
