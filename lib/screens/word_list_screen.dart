import 'package:english_study_app/model/word_model.dart';
import 'package:english_study_app/screens/quiz_screen.dart';
import 'package:english_study_app/widgets/custom_button.dart';
import 'package:english_study_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final TextEditingController _englishController = TextEditingController();
  final TextEditingController _turkishController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key
  Box<Word>? _wordBox;

  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _wordBox = Hive.box<Word>('words');
  }

  void _addWord() {
    if (_formKey.currentState!.validate()) {
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

  List<Word> _filterWordsByDate() {
    DateTime now = DateTime.now();
    DateTime? filterDate;

    switch (_selectedFilter) {
      case 'Son 1 Hafta':
        filterDate = now.subtract(const Duration(days: 7));
        break;
      case 'Son 1 Ay':
        filterDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'Son 2 Ay':
        filterDate = DateTime(now.year, now.month - 2, now.day);
        break;
      case 'Son 3 Ay':
        filterDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case 'Son 6 Ay':
        filterDate = DateTime(now.year, now.month - 6, now.day);
        break;
      default:
        filterDate = null;
    }

    if (filterDate != null) {
      return _wordBox!.values.where((word) {
        return word.date.isAfter(filterDate!);
      }).toList();
    } else {
      return _wordBox!.values.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = _filterWordsByDate();
    debugPrint(DateTime.now().toString());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 245, 241),
      appBar: AppBar(
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
          'Kelime Listesi',
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CustomButton(
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
              backgroundColor: Colors.white,
              buttonTitle: "Başla",
              textColor: const Color(0xff5E29FD),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _englishController,
                labelText: 'İngilizce Kelime',
                validationMessage: 'İngilizce kelime boş geçilemez',
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _turkishController,
                labelText: 'Türkçe Kelime',
                validationMessage: 'Türkçe kelime boş geçilemez',
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: _addWord,
                backgroundColor: const Color(0xff833FF1),
                buttonTitle: "Kelime Ekle",
                textColor: Colors.white,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff833FF1),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          hint: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Filtreleme Seç'),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilter = newValue!;
                            });
                          },
                          items: <String>[
                            'Son 1 Hafta',
                            'Son 1 Ay',
                            'Son 2 Ay',
                            'Son 3 Ay',
                            'Son 6 Ay'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = null;
                      });
                    },
                    backgroundColor: Colors.white,
                    buttonTitle: "Kaldır",
                    textColor: const Color(0xff833FF1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(
                          '${word.english} - ${word.turkish}',
                          style: const TextStyle(color: Color(0xff833FF1)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xff833FF1)),
                              onPressed: () => _editWord(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color(0xff833FF1)),
                              onPressed: () => _deleteWord(index),
                            ),
                          ],
                        ),
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
