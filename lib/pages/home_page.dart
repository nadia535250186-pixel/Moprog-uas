import 'package:flutter/material.dart';
import 'learning_material_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLanguage = 'English';

  final Map<String, String> languages = {
    'English': '🇬🇧',
    'Japanese': '🇯🇵',
    'Korean': '🇰🇷',
    'French': '🇫🇷',
  };

  void openLearning() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levels = [
      {
        'title': 'Level 1',
        'subtitle': 'Pemula',
        'icon': Icons.looks_one,
      },
      {
        'title': 'Level 2',
        'subtitle': 'Dasar',
        'icon': Icons.looks_two,
      },
      {
        'title': 'Level 3',
        'subtitle': 'Menengah',
        'icon': Icons.looks_3,
      },
      {
        'title': 'Level 4',
        'subtitle': 'Lanjutan',
        'icon': Icons.looks_4,
      },
      {
        'title': 'Level 5',
        'subtitle': 'Mahir',
        'icon': Icons.looks_5,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FFF0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Learner! 👋',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263A20),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Siap belajar bahasa hari ini?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0D5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '0 XP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                'Bahasa yang Ingin Dipelajari',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263A20),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      languages[selectedLanguage]!,
                      style: const TextStyle(fontSize: 35),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            value: selectedLanguage,
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            items: languages.keys.map((language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(
                                  language,
                                  style: const TextStyle(
                                    color: Color(0xFF263A20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedLanguage = value;
                                });
                              }
                            },
                          ),
                          const Text(
                            'Pilih bahasa untuk dipelajari',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Progress Belajar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263A20),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Perkembangan Belajarmu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '0%',
                          style: TextStyle(
                            color: Color(0xFF58CC02),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0,
                        minHeight: 10,
                        backgroundColor: Color(0xFFE5E5E5),
                        valueColor: AlwaysStoppedAnimation(
                          Color(0xFF58CC02),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ayo mulai belajar untuk meningkatkan progress!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Level Pembelajaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263A20),
                ),
              ),

              const SizedBox(height: 15),

              ...levels.map((level) {
                return InkWell(
                  onTap: openLearning,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F8DF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            level['icon'] as IconData,
                            color: const Color(0xFF58CC02),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                level['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                level['subtitle'] as String,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: openLearning,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF58CC02),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Mulai Belajar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}