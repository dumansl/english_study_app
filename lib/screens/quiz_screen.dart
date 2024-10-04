import 'package:english_study_app/model/word_model.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final List<Word> words;

  const QuizScreen({super.key, required this.words});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  bool _isCorrect = false;
  final TextEditingController _answerController = TextEditingController();

  void _checkAnswer() {
    if (_answerController.text.trim().toLowerCase() ==
        widget.words[_currentIndex].turkish.toLowerCase()) {
      setState(() {
        _isCorrect = true;
        _currentIndex++;
      });
    } else {
      setState(() {
        _isCorrect = false;
      });
    }
    _answerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelime Testi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'İngilizce: ${widget.words[_currentIndex].english}',
              style: const TextStyle(fontSize: 24),
            ),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Türkçe Çeviri'),
            ),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text('Cevapla'),
            ),
            if (!_isCorrect)
              const Text('Yanlış cevap, doğru cevabı tekrar deneyin!'),
            if (_isCorrect && _currentIndex < widget.words.length)
              const Text('Doğru! Sıradaki kelime...'),
            if (_currentIndex >= widget.words.length)
              const Text('Test tamamlandı!'),
          ],
        ),
      ),
    );
  }
}
