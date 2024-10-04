import 'package:english_study_app/model/word_model.dart';
import 'package:english_study_app/widgets/custom_button.dart';
import 'package:english_study_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  final List<Word> words;

  const QuizScreen({super.key, required this.words});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<int> _usedIndexes = [];
  int _currentIndex = 0;
  bool _isCorrect = false;
  bool _showResultButton = false;
  int _wrongAttempts = 0;
  bool _askEnglishToTurkish = true;
  final TextEditingController _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _generateRandomIndex() {
    if (_usedIndexes.length < widget.words.length) {
      Random random = Random();
      do {
        _currentIndex = random.nextInt(widget.words.length);
      } while (_usedIndexes.contains(_currentIndex));
      _usedIndexes.add(_currentIndex);
    } else {
      _currentIndex = -1;
    }
  }

  @override
  void initState() {
    super.initState();
    _generateRandomIndex();
  }

  void _checkAnswer() {
    if (_formKey.currentState!.validate()) {
      String correctAnswer = _askEnglishToTurkish
          ? widget.words[_currentIndex].turkish
          : widget.words[_currentIndex].english;

      if (_answerController.text.trim().toLowerCase() ==
          correctAnswer.toLowerCase()) {
        setState(() {
          _isCorrect = true;
          _wrongAttempts = 0;
          _showResultButton = false;
          _askEnglishToTurkish = !_askEnglishToTurkish;
          _generateRandomIndex();
        });
      } else {
        setState(() {
          _isCorrect = false;
          _wrongAttempts++;

          if (_wrongAttempts >= 3) {
            _showResultButton = true;
          }
        });
      }
      _answerController.clear();
    }
  }

  void _showAnswer() {
    String correctAnswer = _askEnglishToTurkish
        ? _capitalize(widget.words[_currentIndex].turkish)
        : _capitalize(widget.words[_currentIndex].english);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Doğru Cevap',
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
          content: Text(
            correctAnswer,
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff833FF1),
                letterSpacing: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Tamam',
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _capitalize(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == -1) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffBD62DE), Color(0xff5E29FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          toolbarHeight: 80,
          title: Text(
            'Kelime Testi',
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Kelimeler bitti!',
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff833FF1),
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffBD62DE), Color(0xff5E29FD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        toolbarHeight: 80,
        title: Text(
          'Kelime Testi (${_usedIndexes.length}/${widget.words.length})',
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _askEnglishToTurkish
                      ? _capitalize(widget.words[_currentIndex].english)
                      : _capitalize(widget.words[_currentIndex].turkish),
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff833FF1),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _answerController,
                  labelText: 'Cevabınızı Yazın',
                  validationMessage: 'Cevap boş geçilemez',
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: _checkAnswer,
                  backgroundColor: const Color(0xff833FF1),
                  buttonTitle: "Cevapla",
                  textColor: Colors.white,
                ),
                const SizedBox(height: 10),
                if (!_isCorrect && _wrongAttempts > 0)
                  Text(
                    'Yanlış cevap, ${_wrongAttempts == 3 ? 'Doğru Cevabı Bakabilirsin!' : 'Tekrar deneyin!'}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                if (_isCorrect && _currentIndex < widget.words.length)
                  const Text(
                    'Doğru! Sıradaki kelime...',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                const SizedBox(height: 10),
                if (_showResultButton)
                  CustomButton(
                    onPressed: _showAnswer,
                    backgroundColor: Colors.white,
                    buttonTitle: "Sonucu Gör",
                    textColor: const Color(0xff833FF1),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
