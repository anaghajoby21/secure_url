// lib/views/shorten.dart
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortenPage extends StatefulWidget {
  const ShortenPage({super.key});

  @override
  State<ShortenPage> createState() => _ShortenPageState();
}

class _ShortenPageState extends State<ShortenPage> {
  final TextEditingController _controller = TextEditingController();
  final String _prefsKey = 'shortened_urls_v1';
  List<ShortItem> _items = [];

  static const Color _bgTop = Color(0xFF071228);
  static const Color _bgBottom = Color(0xFF0A1525);
  static const Color _cyan = Color(0xFF00E6FF);
  static const Color _muted = Color(0xFF9FB8C7);

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey) ?? [];
    setState(() {
      _items = list
          .map((s) => ShortItem.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _items.map((i) => jsonEncode(i.toJson())).toList();
    await prefs.setStringList(_prefsKey, list);
  }

  String _generateSlug([int len = 6]) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random.secure();
    return List.generate(len, (_) => chars[rnd.nextInt(chars.length)]).join();
  }

  String _normalize(String s) => s.trim();

  bool _looksLikeUrl(String s) {
    final trimmed = s.trim();
    return trimmed.startsWith('http://') ||
        trimmed.startsWith('https://') ||
        RegExp(r'^[\w-]+\.[\w.-]+').hasMatch(trimmed);
  }

  Future<void> _shorten() async {
    final input = _normalize(_controller.text);
    if (input.isEmpty) {
      _showSnack('Please enter a URL');
      return;
    }
    if (!_looksLikeUrl(input)) {
      _showSnack('Enter a valid URL (include http:// or https:// if possible)');
      return;
    }

    final slug = _generateSlug(6);
    final short = 'https://s.url/$slug'; // replace with real domain when available
    final now = DateTime.now();

    final newItem = ShortItem(
      original: input,
      shortened: short,
      createdAt: now.toIso8601String(),
    );

    setState(() {
      _items.insert(0, newItem);
      if (_items.length > 20) _items = _items.sublist(0, 20);
    });

    await _saveAll();

    _controller.clear();
    await Clipboard.setData(ClipboardData(text: short));
    _showSnack('Shortened and copied to clipboard');
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _showSnack('Copied to clipboard');
  }

  Future<void> _deleteItem(int index) async {
    final removed = _items.removeAt(index);
    await _saveAll();
    setState(() {});
    _showSnack('Deleted ${removed.shortened}');
  }

  String _timeAgo(String iso) {
    final dt = DateTime.tryParse(iso) ?? DateTime.now();
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // page uses transparent scaffold so gradient from parent can show if wanted
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------------------------
                // <- BACK TO HOME BUTTON HERE
                // ---------------------------
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      // navigate back to home (named route '/')
                      Navigator.pushNamed(context, '/');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.home_outlined, color: Color(0xFF00E6FF), size: 20),
                          SizedBox(width: 6),
                          Text(
                            "Home",
                            style: TextStyle(
                              color: Color(0xFF00E6FF),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                // Icon with glow
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.22),
                      boxShadow: [
                        BoxShadow(
                          color: _cyan.withOpacity(0.12),
                          blurRadius: 28,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.link_rounded,
                        color: _cyan,
                        size: 44,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'URL Shortener',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create short, memorable links',
                  style: TextStyle(color: _muted, fontSize: 16),
                ),
                const SizedBox(height: 28),

                // Shorten card
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shorten URL',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter a long URL to create a short link',
                        style: TextStyle(color: _muted),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _shorten(),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'https://example.com/very/long/url...',
                                hintStyle: const TextStyle(color: Colors.white38),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.35),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          InkWell(
                            onTap: _shorten,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 14),
                              decoration: BoxDecoration(
                                color: _cyan,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _cyan.withOpacity(0.18),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Shorten',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Shortened list card
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Shortened URLs',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text('Manage your short links',
                          style: TextStyle(color: _muted)),
                      const SizedBox(height: 16),
                      if (_items.isEmpty)
                        SizedBox(
                          height: 160,
                          child: Center(
                            child: Text(
                              'No shortened URLs yet',
                              style:
                                  TextStyle(color: Colors.white.withOpacity(0.55)),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            // show all items (list already capped at 20)
                            for (var i = 0; i < _items.length; i++)
                              _buildListTile(i, _items[i]),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: child,
    );
  }

  Widget _buildListTile(int index, ShortItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.shortened,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  item.original,
                  style: const TextStyle(color: _muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  _timeAgo(item.createdAt),
                  style: const TextStyle(color: Colors.greenAccent),
                )
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _copyToClipboard(item.shortened),
                icon: const Icon(Icons.copy, color: Colors.white70),
                tooltip: 'Copy',
              ),
              IconButton(
                onPressed: () => _deleteItem(index),
                icon: const Icon(Icons.delete_outline, color: Colors.white54),
                tooltip: 'Delete',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ShortItem {
  final String original;
  final String shortened;
  final String createdAt;

  ShortItem({
    required this.original,
    required this.shortened,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'original': original,
        'shortened': shortened,
        'createdAt': createdAt,
      };

  static ShortItem fromJson(Map<String, dynamic> m) => ShortItem(
        original: m['original'] as String? ?? '',
        shortened: m['shortened'] as String? ?? '',
        createdAt: m['createdAt'] as String? ??
            DateTime.now().toIso8601String(),
      );
}
