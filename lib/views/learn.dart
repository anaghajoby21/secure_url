// lib/views/learn.dart
import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  static const Color _bgTop = Color(0xFF071228);
  static const Color _bgBottom = Color(0xFF0A1525);
  static const Color _cyan = Color(0xFF00E6FF);
  static const Color _muted = Color(0xFF9FB8C7);
  static const double _pad = 28.0;

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ),
      );

  Widget _mutedText(String text) => Text(
        text,
        style: const TextStyle(color: _muted, fontSize: 15, height: 1.5),
      );

  Widget _bullet(String text, {IconData? icon}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? Icons.circle, size: 8, color: _cyan),
            const SizedBox(width: 12),
            Expanded(child: _mutedText(text)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: _pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------------------------------------------------------
              // BACK TO HOME BUTTON — TOP RIGHT CORNER
              // ---------------------------------------------------------
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_outlined,
                            color: _cyan, size: 20),
                        SizedBox(width: 6),
                        Text(
                          "Home",
                          style: TextStyle(
                            color: _cyan,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
                // header icon + title
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.18),
                    boxShadow: [
                      BoxShadow(
                        color: _cyan.withOpacity(0.12),
                        blurRadius: 26,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.book_outlined, color: _cyan, size: 40),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Learn About URLs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Everything you need to know about URL security',
                  style: TextStyle(color: _muted, fontSize: 16),
                ),
                const SizedBox(height: 22),

                // big card: What is a URL?
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.link, color: _cyan, size: 22),
                        const SizedBox(width: 10),
                        const Text(
                          'What is a URL?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      _mutedText(
                          'A URL (Uniform Resource Locator) is the address used to access resources on the internet — web pages, images, APIs and more. It tells your browser where to locate a resource.'),
                      const SizedBox(height: 12),

                      // breakdown box
                      _buildInnerBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Example URL breakdown:',
                                style: TextStyle(
                                    color: _cyan, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10),
                            SelectableText(
                              'https://www.example.com/page?query=value#section',
                              style: const TextStyle(
                                  fontFamily: 'monospace',
                                  color: _cyan,
                                  fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            _richRow('https://', ' - Protocol (secure)'),
                            _richRow('www.example.com', ' - Domain name'),
                            _richRow('/page', ' - Path'),
                            _richRow('?query=value', ' - Query parameters'),
                            _richRow('#section', ' - Fragment'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Threats card
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.warning_amber_outlined, color: _cyan),
                        const SizedBox(width: 10),
                        const Text(
                          'Common URL-related threats',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      _bullet('Phishing links that impersonate trusted sites to steal credentials.'),
                      _bullet('Malware hosting links that download malicious files.'),
                      _bullet('Typosquatting: attacker registers domain near legitimate one (e.g. gooogle.com).'),
                      _bullet('Open redirects: safe-looking links that forward to malicious domains.'),
                      _bullet('Malicious query parameters that exploit site logic or expose sensitive data.'),
                      _bullet('URL shortener abuse — hides the real destination.'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // How to spot suspicious URLs
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.search_outlined, color: _cyan),
                        const SizedBox(width: 10),
                        const Text(
                          'How to spot suspicious URLs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      _bullet('Check the domain carefully — the domain is the authoritative part.'),
                      _bullet('Prefer HTTPS (lock icon), but HTTPS alone does not guarantee safety.'),
                      _bullet('Hover (desktop) or long-press (mobile) to preview links before tapping.'),
                      _bullet('Watch for unusual ports or long random strings in path/query.'),
                      _bullet('Be suspicious of shortened links — expand them first when possible.'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // How to avoid / protect yourself
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.shield_outlined, color: _cyan),
                        const SizedBox(width: 10),
                        const Text(
                          'How to avoid & protect yourself',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      _bullet('Use reputable link scanners (like the app) before visiting unknown URLs.'),
                      _bullet('Keep browser & OS updated; enable safe browsing features.'),
                      _bullet('Never enter credentials from a link — go to the site manually when in doubt.'),
                      _bullet('Use browser plugins or services that expand shortened URLs and preview destinations.'),
                      _bullet('Enable 2FA on important accounts to limit damage from stolen credentials.'),
                      _bullet('Avoid clicking links in unsolicited emails or messages.'),
                      const SizedBox(height: 8),
                      const Text(
                        'If you believe a link is malicious:',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      _bullet('Do not click it; report to your IT/security team or the hosting provider.'),
                      _bullet('If you clicked and entered credentials, change them immediately and enable 2FA.'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Quick checklist
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Quick Checklist'),
                      _bullet('Check domain and subdomain carefully.'),
                      _bullet('Verify HTTPS and certificate when possible.'),
                      _bullet('Preview shortened links before visiting.'),
                      _bullet('Use official apps & bookmarks for important sites.'),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: child,
    );
  }

  Widget _buildInnerBox({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: child,
    );
  }

  Widget _richRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          SelectableText(left,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: _cyan,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(width: 10),
          Expanded(child: Text(right, style: const TextStyle(color: _muted))),
        ],
      ),
    );
  }
}
