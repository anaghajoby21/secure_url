// lib/views/quiz.dart
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class _QuizPageState extends State<QuizPage> {
  static const Color _bgTop = Color(0xFF071228);
  static const Color _bgBottom = Color(0xFF0A1525);
  static const Color _cyan = Color(0xFF00E6FF);
  static const Color _muted = Color(0xFF9FB8C7);

  final List<Question> _questions = [
    Question(
      question: 'What is URL encoding?',
      options: [
        'Encrypting the URL',
        'Converting special characters to a web-safe format',
        'Shortening URLs',
        'Deleting URLs'
      ],
      correctIndex: 1,
    ),
    Question(
      question: 'Which part of a URL identifies the website?',
      options: ['Protocol', 'Path', 'Domain name', 'Fragment'],
      correctIndex: 2,
    ),
    Question(
      question: 'Which indicates a more secure connection in browsers?',
      options: ['HTTP', 'HTTPS (lock icon)', 'A long URL', 'Shortened URL'],
      correctIndex: 1,
    ),
    Question(
      question: 'Typosquatting is:',
      options: [
        'A type of URL shortening',
        'Registering misleading domain names similar to real sites',
        'A browser feature',
        'An encoding method'
      ],
      correctIndex: 1,
    ),
    Question(
      question: 'An open redirect can be dangerous because:',
      options: [
        'It shortens URLs',
        'It encrypts data',
        'It forwards users to a malicious site',
        'It blocks traffic'
      ],
      correctIndex: 2,
    ),
    Question(
      question: 'Best practice when receiving an unexpected link:',
      options: [
        'Click it immediately',
        'Forward it to friends',
        'Preview or scan it first and avoid entering credentials',
        'Save it to bookmarks'
      ],
      correctIndex: 2,
    ),
    Question(
      question: 'Which is true about shortened URLs?',
      options: [
        'They always guarantee safety',
        'They reveal the original domain',
        'They can hide the real destination',
        'They are never used in phishing'
      ],
      correctIndex: 2,
    ),
    Question(
      question: 'Which of these is a sign of a suspicious URL?',
      options: [
        'Familiar domain name',
        'Unusual ports and long random strings',
        'Short meaningful slug',
        'HTTPS with a valid cert'
      ],
      correctIndex: 1,
    ),
    Question(
      question: 'What should you do if you enter credentials on a phishing site?',
      options: [
        'Nothing',
        'Change credentials immediately and enable 2FA',
        'Share credentials with friends',
        'Wait 24 hours'
      ],
      correctIndex: 1,
    ),
    Question(
      question: 'A reliable way to preview a shortened link is:',
      options: [
        'Click it without thinking',
        'Use an expand/preview tool or scanner',
        'Trust the sender always',
        'Copy it to an unknown site'
      ],
      correctIndex: 1,
    ),
  ];

  int _current = 0;
  int _score = 0;
  int? _selectedIndex; // currently selected option
  bool _answered = false;

  void _selectOption(int idx) {
    if (_answered) return; // prevent changing answer after submitted
    setState(() {
      _selectedIndex = idx;
    });
  }

  void _submitAnswer() {
    if (_selectedIndex == null) {
      // optionally show a hint
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option')),
      );
      return;
    }

    final isCorrect = _selectedIndex == _questions[_current].correctIndex;
    setState(() {
      _answered = true;
      if (isCorrect) _score += 1;
    });

    // short delay then advance to next question (gives user feedback)
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    setState(() {
      _selectedIndex = null;
      _answered = false;
      if (_current < _questions.length - 1) {
        _current += 1;
      } else {
        // reached end - keep current to show result
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _current = 0;
      _score = 0;
      _selectedIndex = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;
    final isFinished = _current >= total - 1 && _answered == false && _selectedIndex == null && false; // placeholder not used
    final mq = MediaQuery.of(context).size;

    return Scaffold(
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // top nav / back to home button (top-right)
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, '/'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.home_outlined, color: _cyan, size: 20),
                          SizedBox(width: 8),
                          Text('Home', style: TextStyle(color: _cyan, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // big icon + title
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.18),
                    boxShadow: [
                      BoxShadow(color: _cyan.withOpacity(0.12), blurRadius: 26, spreadRadius: 4),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.psychology_outlined, color: _cyan, size: 44),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Security Quiz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Test your knowledge about URL security',
                  style: TextStyle(color: _muted, fontSize: 16),
                ),

                const SizedBox(height: 22),

                // main question card
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: mq.height * 0.35),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.02)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // header row: question number and score
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_current + 1} of $total',
                            style: const TextStyle(color: _muted),
                          ),
                          Text('Score: $_score/$total', style: const TextStyle(color: _muted)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // question text
                      Text(
                        _questions[_current].question,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(height: 18),

                      // options
                      Column(
                        children: [
                          for (var i = 0; i < _questions[_current].options.length; i++)
                            _optionTile(i, _questions[_current].options[i]),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // submit / next / finish button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!_answered)
                            ElevatedButton(
                              onPressed: _submitAnswer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _cyan,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Submit'),
                            )
                          else
                            ElevatedButton(
                              onPressed: () {
                                if (_current < total - 1) {
                                  setState(() {
                                    _selectedIndex = null;
                                    _answered = false;
                                    _current += 1;
                                  });
                                } else {
                                  // show results dialog
                                  _showResults();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _cyan,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(_current < total - 1 ? 'Next' : 'See Results'),
                            ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _optionTile(int index, String text) {
    final isSelected = _selectedIndex == index;
    final correctIndex = _questions[_current].correctIndex;
    Color borderCol = Colors.white.withOpacity(0.03);
    Color bgCol = Colors.transparent;
    Widget leading = Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
    );

    // when answered, show green/red markers
    if (_answered) {
      if (index == correctIndex) {
        borderCol = Colors.green.withOpacity(0.6);
        bgCol = Colors.green.withOpacity(0.06);
        leading = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.12)),
          child: const Icon(Icons.check, size: 14, color: Colors.green),
        );
      } else if (isSelected && index != correctIndex) {
        borderCol = Colors.red.withOpacity(0.6);
        bgCol = Colors.red.withOpacity(0.04);
        leading = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.06)),
          child: const Icon(Icons.close, size: 14, color: Colors.red),
        );
      }
    } else if (isSelected) {
      borderCol = _cyan.withOpacity(0.9);
      bgCol = _cyan.withOpacity(0.03);
      leading = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _cyan)),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_answered) return;
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: bgCol,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderCol),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.white.withOpacity(0.95)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (ctx) {
        final total = _questions.length;
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.03),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(18),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Quiz Results', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Text('You scored $_score out of $total', style: const TextStyle(color: _muted)),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _restartQuiz();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Restart Quiz'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

