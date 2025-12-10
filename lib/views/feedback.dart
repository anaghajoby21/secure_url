// feedback_page.dart
// Single-file Flutter implementation of the SecureURL "Feedback" page UI shown in the images.
// Paste into lib/feedback_page.dart and import into your app (or set as home to run directly).

import 'package:flutter/material.dart';

class SecureUrlFeedbackPage extends StatefulWidget {
  const SecureUrlFeedbackPage({super.key});

  @override
  State<SecureUrlFeedbackPage> createState() => _SecureUrlFeedbackPageState();
}

class _SecureUrlFeedbackPageState extends State<SecureUrlFeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectCtrl = TextEditingController();
  final TextEditingController _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (!_formKey.currentState!.validate()) return;
    final subject = _subjectCtrl.text.trim();
    final message = _messageCtrl.text.trim();

    // TODO: send to backend or show confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feedback submitted'),
        content: const Text('Thanks for your feedback — we will review it soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // clear fields (optional)
    _subjectCtrl.clear();
    _messageCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF071428), Color(0xFF071F2A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 24),
                _buildHeader(context),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 6,
                      child: _buildFeedbackCard(context),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Expanded(flex: 6, child: _buildInfoCard(context)),
                    Expanded(child: Container()),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildTopBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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

        // ---------- UPDATED HOME BUTTON ----------
        InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
      ],
    ),
  );
}


  Widget _buildHeader(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Send Us Feedback',
          style: TextStyle(
            color: Color(0xFF00E6FF),
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Help us improve SecureURL with your suggestions',
          style: TextStyle(color: Color(0xFF9FB8C7), fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback Form',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Share your thoughts, report issues, or suggest new features',
              style: TextStyle(color: Color(0xFF9FB8C7)),
            ),
            const SizedBox(height: 18),

            const Text('Subject', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _styledTextField(controller: _subjectCtrl, hint: 'Brief summary of your feedback', validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter a subject';
              return null;
            }),
            const SizedBox(height: 18),

            const Text('Message', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _styledTextField(
              controller: _messageCtrl,
              hint: 'Please provide detailed feedback...',
              minLines: 6,
              maxLines: 8,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your message';
                return null;
              },
            ),

            const SizedBox(height: 18),
            // submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitFeedback,
                icon: const Icon(Icons.send, color: Colors.black),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Submit Feedback', style: TextStyle(color: Colors.black)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E6FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _styledTextField({
    required TextEditingController controller,
    required String hint,
    int minLines = 1,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9FB8C7)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.35),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'What kind of feedback can I provide?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFDFF6F8)),
          ),
          SizedBox(height: 12),
          BulletText('Report false positives or negatives in URL detection'),
          BulletText('Suggest new features or improvements'),
          BulletText('Report bugs or technical issues'),
          BulletText('Share your experience using SecureURL'),
        ],
      ),
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;
  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: const Color(0xFF9FB8C7), borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF9FB8C7)))),
        ],
      ),
    );
  }
}
