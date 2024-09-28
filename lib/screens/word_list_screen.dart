import 'package:english_study_app/model/word_model.dart';
import 'package:english_study_app/screens/quiz_screen.dart';
import 'package:english_study_app/widgets/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final TextEditingController _englishController = TextEditingController();
  final TextEditingController _turkishController = TextEditingController();
  Box<Word>? _wordBox;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _wordBox = Hive.box<Word>('words');
  }

  void _addWord() {
    if (_englishController.text.isNotEmpty &&
        _turkishController.text.isNotEmpty) {
      final word = Word(
        english: _englishController.text,
        turkish: _turkishController.text,
        date: DateTime.now(),
      );
      _wordBox!.add(word);
      _englishController.clear();
      _turkishController.clear();
      setState(() {});
    }
  }

  void _editWord(int index) {
    final word = _wordBox!.getAt(index)!;
    _englishController.text = word.english;
    _turkishController.text = word.turkish;
    _wordBox!.deleteAt(index);
  }

  void _deleteWord(int index) {
    _wordBox!.deleteAt(index);
    setState(() {});
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  List<Word> _filterWordsByDate() {
    if (_startDate == null || _endDate == null) {
      return _wordBox!.values.toList();
    } else {
      return _wordBox!.values.where((word) {
        final wordDate = word.date;
        return wordDate.isAfter(_startDate!) && wordDate.isBefore(_endDate!);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = _filterWordsByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelime Listesi'),
        backgroundColor: const Color(0xFFB2EBF2),
      ),
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _englishController,
                decoration: const InputDecoration(
                  labelText: 'İngilizce Kelime',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _turkishController,
                decoration: const InputDecoration(
                  labelText: 'Türkçe Kelime',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addWord,
                child: const Text('Kelime Ekle'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(_startDate == null
                        ? 'Başlangıç Tarihi Seç'
                        : 'Başlangıç: ${_startDate!.toLocal()}'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(_endDate == null
                        ? 'Bitiş Tarihi Seç'
                        : 'Bitiş: ${_endDate!.toLocal()}'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: filteredWords.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizScreen(words: filteredWords),
                          ),
                        );
                      }
                    : null,
                child: const Text('Quiz Başlat'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    return ListTile(
                      title: Text('${word.english} - ${word.turkish}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editWord(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteWord(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
