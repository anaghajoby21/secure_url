// chat_page.dart
import 'package:flutter/material.dart';

class SecureUrlChatPage extends StatefulWidget {
  const SecureUrlChatPage({super.key});

  @override
  State<SecureUrlChatPage> createState() => _SecureUrlChatPageState();
}

class _SecureUrlChatPageState extends State<SecureUrlChatPage> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          "Hello! I'm your security assistant. I can help you understand URL threats, answer questions about cybersecurity, and provide guidance on staying safe online. How can I help you today?",
      fromUser: false,
    ),
  ];

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, fromUser: true));
      // fake assistant reply for demo
      _messages.add(_ChatMessage(
          text: "Thanks — I'll look into that. (This is a demo reply)",
          fromUser: false));
    });
    _ctrl.clear();
    // scroll to bottom shortly after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // keep the dark gradient aesthetic similar to the mock
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF071428), Color(0xFF071F2A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: _buildChatCard(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.shield, color: Color(0xFF00E6FF)),
            SizedBox(width: 8),
            Text(
              'SecureURL',
              style: TextStyle(
                color: Color(0xFF00E6FF),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),

        // Top-right: Home button styled to match other pages
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              // Replace the stack and go to home
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
                  SizedBox(width: 8),
                  Text(
                    'Home',
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
      ],
    ),
  );
}

  Widget _buildChatCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Column(
        children: [
          // header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF0BCDDC),
                  child: Icon(Icons.smart_toy, color: Colors.black, size: 18),
                ),
                SizedBox(width: 12),
                Text(
                  'Security Assistant',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          // messages area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.transparent,
                  child: ListView.builder(
                    controller: _scroll,
                    itemCount: _messages.length,
                    padding: const EdgeInsets.only(bottom: 12),
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: msg.fromUser
                            ? _buildUserBubble(msg)
                            : _buildAssistantBubble(msg),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // input area
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.02)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF9FB8C7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              hintText: 'Ask me anything about URL security...',
                              hintStyle: TextStyle(color: Color(0xFF9FB8C7)),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.send, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantBubble(_ChatMessage m) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0BCDDC),
          ),
          child: const Icon(Icons.smart_toy, size: 18, color: Colors.black),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              m.text,
              style: const TextStyle(color: Color(0xFFDFF6F8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserBubble(_ChatMessage m) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Container()),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0BCDDC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            m.text,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

// Simple message model
class _ChatMessage {
  final String text;
  final bool fromUser;
  _ChatMessage({required this.text, required this.fromUser});
}
