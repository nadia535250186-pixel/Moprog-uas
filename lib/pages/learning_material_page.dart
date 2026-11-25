import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LearningItem {
  final String title;
  final String meaning;

  const LearningItem(this.title, this.meaning);
}

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  static const Color green = Color(0xFF58CC02);

  static const List<LearningItem> alphabet = [
    LearningItem('A', 'ei'),
    LearningItem('B', 'bi'),
    LearningItem('C', 'si'),
    LearningItem('D', 'di'),
    LearningItem('E', 'i'),
    LearningItem('F', 'ef'),
    LearningItem('G', 'ji'),
    LearningItem('H', 'eich'),
    LearningItem('I', 'ai'),
    LearningItem('J', 'jei'),
    LearningItem('K', 'kei'),
    LearningItem('L', 'el'),
    LearningItem('M', 'em'),
    LearningItem('N', 'en'),
    LearningItem('O', 'ou'),
    LearningItem('P', 'pi'),
    LearningItem('Q', 'kyu'),
    LearningItem('R', 'ar'),
    LearningItem('S', 'es'),
    LearningItem('T', 'ti'),
    LearningItem('U', 'yu'),
    LearningItem('V', 'vi'),
    LearningItem('W', 'dabel yu'),
    LearningItem('X', 'eks'),
    LearningItem('Y', 'wai'),
    LearningItem('Z', 'zed / zi'),
  ];

  // 100 VOCABULARY
  static const String vocabularyData = '''
Apple|Apel
Book|Buku
Car|Mobil
Dog|Anjing
Cat|Kucing
House|Rumah
School|Sekolah
Teacher|Guru
Student|Murid
Friend|Teman
Family|Keluarga
Mother|Ibu
Father|Ayah
Brother|Saudara laki-laki
Sister|Saudara perempuan
Water|Air
Food|Makanan
Rice|Nasi
Bread|Roti
Milk|Susu
Coffee|Kopi
Tea|Teh
Table|Meja
Chair|Kursi
Door|Pintu
Window|Jendela
Room|Kamar
Kitchen|Dapur
Bathroom|Kamar mandi
Bedroom|Kamar tidur
Phone|Telepon
Computer|Komputer
Laptop|Laptop
Bag|Tas
Shoes|Sepatu
Shirt|Kemeja
Pants|Celana
Hat|Topi
Watch|Jam tangan
Money|Uang
Market|Pasar
Store|Toko
Hospital|Rumah sakit
Doctor|Dokter
Nurse|Perawat
Police|Polisi
Driver|Pengemudi
Farmer|Petani
Worker|Pekerja
Student|Pelajar
City|Kota
Village|Desa
Country|Negara
Beach|Pantai
Mountain|Gunung
River|Sungai
Sea|Laut
Sun|Matahari
Moon|Bulan
Star|Bintang
Sky|Langit
Cloud|Awan
Rain|Hujan
Wind|Angin
Tree|Pohon
Flower|Bunga
Grass|Rumput
Bird|Burung
Fish|Ikan
Horse|Kuda
Cow|Sapi
Chicken|Ayam
Duck|Bebek
Rabbit|Kelinci
Lion|Singa
Tiger|Harimau
Elephant|Gajah
Monkey|Monyet
Snake|Ular
Red|Merah
Blue|Biru
Green|Hijau
Yellow|Kuning
Black|Hitam
White|Putih
Big|Besar
Small|Kecil
Long|Panjang
Short|Pendek
Happy|Senang
Sad|Sedih
Beautiful|Cantik / indah
Handsome|Tampan
Good|Baik
Bad|Buruk
Fast|Cepat
Slow|Lambat
Clean|Bersih
Dirty|Kotor
''';

  // 100 DAILY EXPRESSIONS
  static const String expressionData = '''
Good morning|Selamat pagi
Good afternoon|Selamat siang
Good evening|Selamat malam
Good night|Selamat tidur
Hello|Halo
Hi|Hai
How are you?|Apa kabar?
I am fine|Saya baik-baik saja
Nice to meet you|Senang bertemu denganmu
See you|Sampai jumpa
See you later|Sampai nanti
Goodbye|Selamat tinggal
Thank you|Terima kasih
Thank you very much|Terima kasih banyak
You are welcome|Sama-sama
Please|Tolong
Excuse me|Permisi
I am sorry|Saya minta maaf
No problem|Tidak masalah
It is okay|Tidak apa-apa
What is your name?|Siapa namamu?
My name is...|Nama saya...
Where are you from?|Dari mana asalmu?
I am from Indonesia|Saya dari Indonesia
How old are you?|Berapa umurmu?
I am ... years old|Umur saya ... tahun
What do you do?|Apa pekerjaanmu?
I am a student|Saya seorang pelajar
Where do you live?|Di mana kamu tinggal?
I live in Indonesia|Saya tinggal di Indonesia
Can you help me?|Bisakah kamu membantu saya?
Of course|Tentu saja
I understand|Saya mengerti
I do not understand|Saya tidak mengerti
Please repeat|Tolong ulangi
Speak slowly, please|Tolong bicara pelan-pelan
What time is it?|Jam berapa sekarang?
I am hungry|Saya lapar
I am thirsty|Saya haus
I am tired|Saya lelah
I am sleepy|Saya mengantuk
I am happy|Saya senang
I am busy|Saya sibuk
I am ready|Saya siap
Wait a moment|Tunggu sebentar
Come here|Kemarilah
Let us go|Ayo pergi
Be careful|Hati-hati
Good luck|Semoga berhasil
Congratulations|Selamat
Well done|Kerja bagus
That is great|Itu hebat
Really?|Benarkah?
Are you sure?|Apakah kamu yakin?
I think so|Saya rasa begitu
I do not know|Saya tidak tahu
Maybe|Mungkin
Of course not|Tentu tidak
Absolutely|Tentu saja
Never mind|Tidak usah dipikirkan
Do not worry|Jangan khawatir
Calm down|Tenanglah
What happened?|Apa yang terjadi?
What is this?|Apa ini?
Where is the bathroom?|Di mana kamar mandi?
How much is it?|Berapa harganya?
It is expensive|Itu mahal
It is cheap|Itu murah
I like it|Saya menyukainya
I love it|Saya sangat menyukainya
I do not like it|Saya tidak menyukainya
That sounds good|Kedengarannya bagus
I agree|Saya setuju
I disagree|Saya tidak setuju
You are right|Kamu benar
You are welcome here|Kamu diterima di sini
Have a nice day|Semoga harimu menyenangkan
Enjoy your meal|Selamat makan
Bless you|Semoga kamu diberkati
Take care|Jaga diri
Good job|Kerja bagus
What do you mean?|Apa maksudmu?
Can I ask something?|Bolehkah saya bertanya?
Can I come in?|Bolehkah saya masuk?
May I sit here?|Bolehkah saya duduk di sini?
I need help|Saya butuh bantuan
I am on my way|Saya sedang dalam perjalanan
I will be back|Saya akan kembali
Just a minute|Sebentar saja
That is enough|Itu sudah cukup
Let me see|Biar saya lihat
I am not sure|Saya tidak yakin
It depends|Tergantung
That is interesting|Itu menarik
What a surprise|Sungguh mengejutkan
See you tomorrow|Sampai jumpa besok
Have a good weekend|Selamat menikmati akhir pekan
Welcome back|Selamat datang kembali
Happy birthday|Selamat ulang tahun
''';

  // 100 SIMPLE SENTENCES
  static const String sentenceData = '''
I am a student|Saya seorang pelajar
She is my mother|Dia adalah ibu saya
He is my father|Dia adalah ayah saya
This is my book|Ini buku saya
That is your bag|Itu tasmu
I like apples|Saya suka apel
She likes music|Dia suka musik
He plays football|Dia bermain sepak bola
We go to school|Kami pergi ke sekolah
They are my friends|Mereka teman-teman saya
I drink water|Saya minum air
She reads a book|Dia membaca buku
He writes a letter|Dia menulis surat
I eat rice|Saya makan nasi
We watch television|Kami menonton televisi
The sun is bright|Matahari bersinar terang
The sky is blue|Langit berwarna biru
My house is big|Rumah saya besar
The cat is sleeping|Kucing itu sedang tidur
The dog is running|Anjing itu sedang berlari
I wake up early|Saya bangun pagi
I brush my teeth|Saya menyikat gigi
I take a shower|Saya mandi
I eat breakfast|Saya sarapan
I go to work|Saya pergi bekerja
I study English|Saya belajar bahasa Inggris
She cooks dinner|Dia memasak makan malam
He cleans his room|Dia membersihkan kamarnya
We learn together|Kami belajar bersama
They play outside|Mereka bermain di luar
I have a pencil|Saya memiliki pensil
She has a new phone|Dia memiliki telepon baru
He has a bicycle|Dia memiliki sepeda
My brother is tall|Saudara laki-laki saya tinggi
My sister is kind|Saudara perempuan saya baik hati
My father is working|Ayah saya sedang bekerja
My mother is cooking|Ibu saya sedang memasak
The food is delicious|Makanan itu lezat
The water is cold|Air itu dingin
The coffee is hot|Kopi itu panas
I love my family|Saya mencintai keluarga saya
We live in Indonesia|Kami tinggal di Indonesia
I walk to school|Saya berjalan ke sekolah
She sings a song|Dia menyanyikan lagu
He drives a car|Dia mengendarai mobil
The baby is crying|Bayi itu sedang menangis
The birds are flying|Burung-burung sedang terbang
I open the door|Saya membuka pintu
Please close the window|Tolong tutup jendela
The room is clean|Kamar itu bersih
I need a pen|Saya membutuhkan pulpen
She wants some tea|Dia ingin teh
He needs some help|Dia membutuhkan bantuan
I can swim|Saya bisa berenang
She can dance|Dia bisa menari
He can cook|Dia bisa memasak
We are happy|Kami bahagia
They are tired|Mereka lelah
I am learning now|Saya sedang belajar sekarang
She is reading|Dia sedang membaca
He is sleeping|Dia sedang tidur
It is raining|Sedang hujan
The weather is nice|Cuacanya bagus
I have two sisters|Saya memiliki dua saudara perempuan
There is a cat|Ada seekor kucing
There are three books|Ada tiga buku
My shoes are black|Sepatu saya berwarna hitam
Her dress is red|Gaunnya berwarna merah
His car is new|Mobilnya baru
This food is tasty|Makanan ini enak
I like this place|Saya suka tempat ini
We need more time|Kami membutuhkan lebih banyak waktu
She speaks English|Dia berbicara bahasa Inggris
He studies every day|Dia belajar setiap hari
I go home at five|Saya pulang jam lima
My friend is funny|Teman saya lucu
The teacher is kind|Guru itu baik hati
I am very hungry|Saya sangat lapar
She is very smart|Dia sangat pintar
He is very strong|Dia sangat kuat
The shop is open|Toko itu buka
The school is closed|Sekolah itu tutup
I buy some bread|Saya membeli roti
She drinks milk|Dia minum susu
He eats an orange|Dia makan jeruk
We visit our grandmother|Kami mengunjungi nenek
They live near here|Mereka tinggal di dekat sini
I have a question|Saya punya pertanyaan
Please listen to me|Tolong dengarkan saya
Do you like music?|Apakah kamu suka musik?
Where do you live?|Di mana kamu tinggal?
What are you doing?|Apa yang sedang kamu lakukan?
I am doing my homework|Saya sedang mengerjakan PR
She is watching a movie|Dia sedang menonton film
He is playing a game|Dia sedang bermain gim
We are going home|Kami sedang pulang
They are studying English|Mereka sedang belajar bahasa Inggris
I want to be better|Saya ingin menjadi lebih baik
Today is a good day|Hari ini adalah hari yang baik
Tomorrow is Monday|Besok hari Senin
I believe in myself|Saya percaya pada diri sendiri
''';

  static List<LearningItem> parseData(String data) {
    return data
        .trim()
        .split('\n')
        .map((line) {
          final parts = line.split('|');
          return LearningItem(parts[0].trim(), parts[1].trim());
        })
        .toList();
  }

  static List<LearningItem> get vocabulary => parseData(vocabularyData);
  static List<LearningItem> get expressions => parseData(expressionData);
  static List<LearningItem> get sentences => parseData(sentenceData);

  static List<LearningItem> get numbers {
    return List.generate(
      100,
      (index) => LearningItem(
        '${index + 1}',
        numberToWords(index + 1),
      ),
    );
  }

  static String numberToWords(int number) {
    const ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    const tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    if (number < 20) return ones[number];

    if (number < 100) {
      final t = number ~/ 10;
      final o = number % 10;
      return o == 0 ? tens[t] : '${tens[t]}-${ones[o]}';
    }

    return 'One Hundred';
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData('Alphabet', 'Belajar huruf A sampai Z', Icons.abc,
          alphabet),
      _CategoryData('Vocabulary', '100 kosakata bahasa Inggris',
          Icons.menu_book, vocabulary),
      _CategoryData('Numbers', 'Belajar angka 1 sampai 100',
          Icons.calculate, numbers),
      _CategoryData('Daily Expressions', '100 ungkapan sehari-hari',
          Icons.chat_bubble, expressions),
      _CategoryData('Simple Sentences', '100 kalimat sederhana',
          Icons.edit_note, sentences),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Materials',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let’s Learn English!',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Learn English step by step and improve your skills every day.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose Your Material',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...categories.map((category) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: green.withOpacity(0.15),
                  child: Icon(category.icon, color: green, size: 30),
                ),
                title: Text(
                  category.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(category.subtitle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MaterialListPage(
                        title: category.title,
                        items: category.items,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CategoryData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<LearningItem> items;

  _CategoryData(this.title, this.subtitle, this.icon, this.items);
}


class MaterialListPage extends StatefulWidget {
  final String title;
  final List<LearningItem> items;

  const MaterialListPage({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  State<MaterialListPage> createState() => _MaterialListPageState();
}

class _MaterialListPageState extends State<MaterialListPage> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController searchController =
      TextEditingController();

  String searchText = '';
  int? speakingIndex;
  bool isSpeaking = false;

  static const Color green = Color(0xFF58CC02);

  @override
  void initState() {
    super.initState();
    setupVoice();
  }

  Future<void> setupVoice() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          isSpeaking = false;
          speakingIndex = null;
        });
      }
    });

    flutterTts.setErrorHandler((message) {
      if (mounted) {
        setState(() {
          isSpeaking = false;
          speakingIndex = null;
        });
      }
    });
  }

  Future<void> speakItem(LearningItem item, int index) async {
    try {
      await flutterTts.stop();

      // Numbers dibacakan menggunakan tulisan bahasa Inggris.
      final textToSpeak = widget.title == 'Numbers'
          ? item.meaning
          : item.title;

      setState(() {
        speakingIndex = index;
        isSpeaking = true;
      });

      await flutterTts.speak(textToSpeak);
    } catch (e) {
      if (mounted) {
        setState(() {
          speakingIndex = null;
          isSpeaking = false;
        });
      }
    }
  }

  Future<void> stopVoice() async {
    await flutterTts.stop();

    if (mounted) {
      setState(() {
        speakingIndex = null;
        isSpeaking = false;
      });
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      return item.title.toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
          item.meaning.toLowerCase().contains(
                searchText.toLowerCase(),
              );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F5),

      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isSpeaking)
            IconButton(
              tooltip: 'Stop voice',
              onPressed: stopVoice,
              icon: const Icon(Icons.stop_circle_outlined),
            ),
        ],
      ),

      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Let’s Practice!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.items.length} learning materials available',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Tap the speaker to listen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search learning material...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchText = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // MATERIAL COUNT
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Learning List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  '${filteredItems.length} items',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // MATERIAL LIST
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text('No material found'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16, 4, 16, 20,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final active = speakingIndex == index &&
                          isSpeaking;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 11),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 7,
                          ),

                          leading: CircleAvatar(
                            backgroundColor:
                                green.withOpacity(0.15),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Color(0xFF388E00),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          title: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              item.meaning,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          trailing: IconButton(
                            tooltip: 'Listen',
                            onPressed: () {
                              if (active) {
                                stopVoice();
                              } else {
                                speakItem(item, index);
                              }
                            },
                            icon: Icon(
                              active
                                  ? Icons.stop_circle
                                  : Icons.volume_up_rounded,
                              color: green,
                              size: 29,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}