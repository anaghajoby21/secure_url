// lib/views/home.dart
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:secure_url/provider/scanner_provider.dart';

import 'chatbot.dart';
import 'feedback.dart';
import 'login.dart';

class SecureUrlHomePage extends StatefulWidget {
  const SecureUrlHomePage({super.key});

  @override
  State<SecureUrlHomePage> createState() => _SecureUrlHomePageState();
}

class _SecureUrlHomePageState extends State<SecureUrlHomePage> {
  final TextEditingController urlController = TextEditingController();

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = Provider.of<ScannerProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF071228), Color(0xFF0A1525)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopNavbar(context),
                const SizedBox(height: 40),
                const Text(
                  "URL Security Scanner",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Protect yourself from phishing, malware, and malicious websites",
                  style: TextStyle(color: Color(0xFFA9BED1), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildTabToggle(context, scannerProvider),
                const SizedBox(height: 20),
                scannerProvider.selectedTab == 0
                    ? _buildUrlScannerBox(context)
                    : _buildQrScannerBox(context),
                const SizedBox(height: 25),
                _buildScanHistory(scannerProvider),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavbar(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name ?? '/';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF00E6FF).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield, color: Color(0xFF00E6FF)),
            ),
            const SizedBox(width: 12),
            const Text(
              'SecureURL',
              style: TextStyle(
                color: Color(0xFF00E6FF),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        // right side actions
        Row(
          children: [
            _navButton(context, "Home", routeName: '/', active: current == '/'),
            _navButton(context, "Shorten", routeName: '/shorten', active: current == '/shorten'),
            _navButton(context, "Learn", routeName: '/learn', active: current == '/learn'),
            _navButton(context, "Quiz", routeName: '/quiz', active: current == '/quiz'),
            _navButton(context, "Chat", routeName: '/chat', active: current == '/chat'),
            const SizedBox(width: 6),
            _navButton(context, "Feedback", routeName: '/feedback', active: current == '/feedback'),
            const SizedBox(width: 6),
            _navButton(context, "Logout", routeName: '/logout'),
          ],
        )
      ],
    );
  }

  Widget _navButton(BuildContext context, String title, {required String? routeName, bool active = false}) {
    return GestureDetector(
      onTap: () {
        if (routeName == null) return;

        if (routeName == '/logout') {
          // perform logout (clear tokens) and go to login
          Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
          return;
        }

        final current = ModalRoute.of(context)?.settings.name ?? '/';
        if (current == routeName) return;

        // Use replacement for top-level nav to avoid stacking many pages
        Navigator.pushReplacementNamed(context, routeName);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.only(bottom: active ? 4 : 0),
        decoration: active
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF00E6FF), width: 3),
                ),
              )
            : null,
        child: Text(
          title,
          style: TextStyle(
            color: active ? const Color(0xFF00E6FF) : Colors.white70,
            fontSize: 15,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabToggle(BuildContext context, dynamic provider) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabButton("Manual URL", 0, provider),
          _tabButton("QR Code", 1, provider),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index, dynamic provider) {
    bool selected = provider.selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF00E6FF).withOpacity(0.25) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white60,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlScannerBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.link, color: Color(0xFFBFEFF8)),
              SizedBox(width: 10),
              Text(
                "URL Scanner",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Paste any URL to check if it's safe to visit",
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    hintText: "https://example.com",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  final url = urlController.text.trim();
                  if (url.isNotEmpty) {
                    Provider.of<ScannerProvider>(context, listen: false).addHistoryEntry(url, 'LOW');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scan requested for: $url')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Scan URL",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQrScannerBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.qr_code_scanner, color: Color(0xFFBFEFF8), size: 22),
              SizedBox(width: 10),
              Text(
                "QR Code Scanner",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Scan QR codes to check if they contain malicious URLs",
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 18),

          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Start Camera tapped (placeholder)')),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF00E6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code, color: Colors.black, size: 20),
                  SizedBox(width: 12),
                  Text(
                    "Start Camera",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanHistory(ScannerProvider provider) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.history, color: Color(0xFFBFEFF8)),
              SizedBox(width: 10),
              Text("Scan History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Your recent URL scans", style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 18),

          if (provider.history.isEmpty)
            const Text("No scans yet.", style: TextStyle(color: Colors.white60))
          else
            Column(
              children: provider.history.map((entry) {
                final url = entry['url'] ?? '';
                final status = entry['status'] ?? 'UNKNOWN';
                final time = entry['time'] ?? '';
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: status == 'LOW'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(status == 'LOW' ? Icons.check_circle : Icons.warning, color: status == 'LOW' ? Colors.green : Colors.orange, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(url, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(status == 'LOW' ? "This URL appears to be safe." : "Potentially malicious.", style: const TextStyle(color: Colors.white60)),
                            const SizedBox(height: 6),
                            Text("${status.toUpperCase()}  •  ${_formatAgo(time)}", style: const TextStyle(color: Colors.greenAccent)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  String _formatAgo(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inDays >= 1) return "${diff.inDays} days ago";
      if (diff.inHours >= 1) return "${diff.inHours} hours ago";
      if (diff.inMinutes >= 1) return "${diff.inMinutes} minutes ago";
      return "just now";
    } catch (_) {
      return "";
    }
  }
}
