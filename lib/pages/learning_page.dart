import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =====================================================================
// FILE TUNGGAL: learning_page.dart
// Isi: 1) data materi  2) penyimpan progress  3) halaman UI
// Butuh dependency: flutter_tts, shared_preferences
// =====================================================================

// ====================== 1) DATA MATERI ======================

/// Satu materi belajar. [reading] = cara baca (romaji / romanisasi), opsional.
class LearningItem {
  final String title;
  final String? reading;
  final String meaning;
  const LearningItem(this.title, this.meaning, {this.reading});
}

class LanguageInfo {
  final String code;
  final String name;
  final String flag;
  final String ttsLocale;
  const LanguageInfo(this.code, this.name, this.flag, this.ttsLocale);
}

class LevelInfo {
  final int number;
  final String title;
  final String subtitle;
  final IconData icon;
  const LevelInfo(this.number, this.title, this.subtitle, this.icon);
}

class LearningData {
  static const languages = <LanguageInfo>[
    LanguageInfo('en', 'English', '🇬🇧', 'en-US'),
    LanguageInfo('ja', 'Japanese', '🇯🇵', 'ja-JP'),
    LanguageInfo('ko', 'Korean', '🇰🇷', 'ko-KR'),
    LanguageInfo('fr', 'French', '🇫🇷', 'fr-FR'),
  ];

  static const levels = <LevelInfo>[
    LevelInfo(1, 'Dasar', 'Sapaan dan kata sopan', Icons.waving_hand),
    LevelInfo(2, 'Kosakata', 'Benda dan orang sehari-hari', Icons.menu_book),
    LevelInfo(3, 'Ekspresi Harian', 'Ungkapan sehari-hari', Icons.chat_bubble),
    LevelInfo(4, 'Kalimat Sederhana', 'Kalimat pendek lengkap', Icons.edit_note),
    LevelInfo(5, 'Percakapan Lanjutan', 'Kalimat panjang dan sopan', Icons.forum),
  ];

  static int get levelCount => levels.length;

  static LanguageInfo language(String code) =>
      languages.firstWhere((l) => l.code == code, orElse: () => languages.first);

  // Cache supaya teks tidak di-parse berulang kali.
  static final Map<String, List<LearningItem>> _cache = {};

  static List<LearningItem> items(String langCode, int level) {
    return _cache.putIfAbsent('$langCode-$level', () {
      final raw = _raw[langCode]![level - 1];
      return raw
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .map((line) {
        final p = line.split('|').map((e) => e.trim()).toList();
        // Format: "kata|arti"  atau  "kata|cara baca|arti"
        return p.length >= 3
            ? LearningItem(p[0], p[2], reading: p[1])
            : LearningItem(p[0], p[1]);
      }).toList();
    });
  }

  // Satu bahasa = 5 string (Level 1..5). Tambah baris baru di string mana pun
  // untuk menambah materi, progress otomatis menyesuaikan jumlahnya.
  static const Map<String, List<String>> _raw = {
    'en': _en,
    'ja': _ja,
    'ko': _ko,
    'fr': _fr,
  };

  // ============================ ENGLISH ============================
  static const _en = <String>[
    '''
Hello|Halo
Good morning|Selamat pagi
Good night|Selamat malam
Thank you|Terima kasih
Please|Tolong
Sorry|Maaf
Yes|Ya
No|Tidak
Goodbye|Selamat tinggal
Welcome|Selamat datang
''',
    '''
Book|Buku
Water|Air
House|Rumah
Car|Mobil
Friend|Teman
Food|Makanan
Mother|Ibu
Father|Ayah
School|Sekolah
Money|Uang
''',
    '''
How are you?|Apa kabar?
I am fine|Saya baik-baik saja
Nice to meet you|Senang bertemu denganmu
What is your name?|Siapa namamu?
Where are you from?|Dari mana asalmu?
I don't understand|Saya tidak mengerti
Please repeat|Tolong ulangi
How much is this?|Berapa harganya?
Where is the bathroom?|Di mana kamar mandi?
See you tomorrow|Sampai jumpa besok
''',
    '''
I am a student|Saya seorang pelajar
She is my mother|Dia ibu saya
I like apples|Saya suka apel
We go to school|Kami pergi ke sekolah
The cat is sleeping|Kucing itu sedang tidur
I drink water every day|Saya minum air setiap hari
He reads a book|Dia membaca buku
My house is big|Rumah saya besar
They are my friends|Mereka teman saya
The sky is blue|Langit berwarna biru
''',
    '''
Could you help me, please?|Bisakah Anda membantu saya?
I have been studying English for two years|Saya sudah belajar bahasa Inggris selama dua tahun
If it rains tomorrow, we will stay home|Jika besok hujan, kami akan tinggal di rumah
I would like to order a coffee|Saya ingin memesan kopi
Could you tell me how to get to the station?|Bisakah Anda memberi tahu cara ke stasiun?
I am looking forward to meeting you|Saya menantikan pertemuan denganmu
She told me that she was tired|Dia bilang kepada saya bahwa dia lelah
What do you think about this idea?|Bagaimana pendapatmu tentang ide ini?
I forgot my wallet at home|Saya lupa dompet saya di rumah
Let us discuss this problem together|Mari kita bahas masalah ini bersama
''',
  ];

  // ============================ JAPANESE ===========================
  static const _ja = <String>[
    '''
こんにちは|konnichiwa|Halo / Selamat siang
おはよう|ohayou|Selamat pagi
こんばんは|konbanwa|Selamat malam
ありがとう|arigatou|Terima kasih
お願いします|onegaishimasu|Tolong
すみません|sumimasen|Permisi / Maaf
はい|hai|Ya
いいえ|iie|Tidak
さようなら|sayounara|Selamat tinggal
ようこそ|youkoso|Selamat datang
''',
    '''
本|hon|Buku
水|mizu|Air
家|ie|Rumah
車|kuruma|Mobil
友達|tomodachi|Teman
食べ物|tabemono|Makanan
母|haha|Ibu
父|chichi|Ayah
学校|gakkou|Sekolah
お金|okane|Uang
''',
    '''
お元気ですか？|ogenki desu ka?|Apa kabar?
元気です|genki desu|Saya baik-baik saja
はじめまして|hajimemashite|Senang bertemu denganmu
お名前は何ですか？|onamae wa nan desu ka?|Siapa namamu?
どこから来ましたか？|doko kara kimashita ka?|Dari mana asalmu?
わかりません|wakarimasen|Saya tidak mengerti
もう一度お願いします|mou ichido onegaishimasu|Tolong ulangi
これはいくらですか？|kore wa ikura desu ka?|Berapa harganya?
トイレはどこですか？|toire wa doko desu ka?|Di mana kamar mandi?
また明日|mata ashita|Sampai jumpa besok
''',
    '''
私は学生です|watashi wa gakusei desu|Saya seorang pelajar
彼女は私の母です|kanojo wa watashi no haha desu|Dia ibu saya
りんごが好きです|ringo ga suki desu|Saya suka apel
学校に行きます|gakkou ni ikimasu|Saya pergi ke sekolah
猫が寝ています|neko ga nete imasu|Kucing sedang tidur
毎日水を飲みます|mainichi mizu o nomimasu|Saya minum air setiap hari
彼は本を読みます|kare wa hon o yomimasu|Dia membaca buku
私の家は大きいです|watashi no ie wa ookii desu|Rumah saya besar
彼らは私の友達です|karera wa watashi no tomodachi desu|Mereka teman saya
空は青いです|sora wa aoi desu|Langit berwarna biru
''',
    '''
手伝っていただけますか？|tetsudatte itadakemasu ka?|Bisakah Anda membantu saya?
二年間日本語を勉強しています|ninenkan nihongo o benkyou shite imasu|Saya sudah belajar bahasa Jepang dua tahun
明日雨が降ったら、家にいます|ashita ame ga futtara, ie ni imasu|Jika besok hujan, saya di rumah
コーヒーを一つお願いします|koohii o hitotsu onegaishimasu|Saya mau pesan satu kopi
駅への行き方を教えてください|eki e no ikikata o oshiete kudasai|Tolong beri tahu cara ke stasiun
お会いできるのを楽しみにしています|oai dekiru no o tanoshimi ni shite imasu|Saya menantikan pertemuan denganmu
彼女は疲れていると言いました|kanojo wa tsukarete iru to iimashita|Dia bilang bahwa dia lelah
このアイデアについてどう思いますか？|kono aidea ni tsuite dou omoimasu ka?|Bagaimana pendapatmu tentang ide ini?
家に財布を忘れました|ie ni saifu o wasuremashita|Saya lupa dompet di rumah
一緒にこの問題を話し合いましょう|issho ni kono mondai o hanashiaimashou|Mari bahas masalah ini bersama
''',
  ];

  // ============================ KOREAN =============================
  static const _ko = <String>[
    '''
안녕하세요|annyeonghaseyo|Halo
좋은 아침|joeun achim|Selamat pagi
안녕히 주무세요|annyeonghi jumuseyo|Selamat malam (selamat tidur)
감사합니다|gamsahamnida|Terima kasih
부탁합니다|butakhamnida|Tolong
죄송합니다|joesonghamnida|Maaf
네|ne|Ya
아니요|aniyo|Tidak
안녕히 가세요|annyeonghi gaseyo|Selamat tinggal
환영합니다|hwanyeonghamnida|Selamat datang
''',
    '''
책|chaek|Buku
물|mul|Air
집|jip|Rumah
자동차|jadongcha|Mobil
친구|chingu|Teman
음식|eumsik|Makanan
어머니|eomeoni|Ibu
아버지|abeoji|Ayah
학교|hakgyo|Sekolah
돈|don|Uang
''',
    '''
잘 지내세요?|jal jinaeseyo?|Apa kabar?
잘 지내요|jal jinaeyo|Saya baik-baik saja
만나서 반갑습니다|mannaseo bangapseumnida|Senang bertemu denganmu
이름이 뭐예요?|ireumi mwoyeyo?|Siapa namamu?
어디에서 왔어요?|eodieseo wasseoyo?|Dari mana asalmu?
이해 못 했어요|ihae mot haesseoyo|Saya tidak mengerti
다시 말해 주세요|dasi malhae juseyo|Tolong ulangi
이거 얼마예요?|igeo eolmayeyo?|Berapa harganya?
화장실이 어디예요?|hwajangsiri eodiyeyo?|Di mana kamar mandi?
내일 봐요|naeil bwayo|Sampai jumpa besok
''',
    '''
저는 학생입니다|jeoneun haksaengimnida|Saya seorang pelajar
그녀는 제 어머니예요|geunyeoneun je eomeoniyeyo|Dia ibu saya
저는 사과를 좋아해요|jeoneun sagwareul joahaeyo|Saya suka apel
학교에 가요|hakgyoe gayo|Saya pergi ke sekolah
고양이가 자고 있어요|goyangiga jago isseoyo|Kucing sedang tidur
매일 물을 마셔요|maeil mureul masyeoyo|Saya minum air setiap hari
그는 책을 읽어요|geuneun chaegeul ilgeoyo|Dia membaca buku
우리 집은 커요|uri jibeun keoyo|Rumah kami besar
그들은 제 친구예요|geudeureun je chinguyeyo|Mereka teman saya
하늘이 파래요|haneuri paraeyo|Langit berwarna biru
''',
    '''
저를 도와주실 수 있어요?|jeoreul dowajusil su isseoyo?|Bisakah Anda membantu saya?
이 년 동안 한국어를 공부했어요|i nyeon dongan hangugeoreul gongbuhaesseoyo|Saya sudah belajar bahasa Korea dua tahun
내일 비가 오면 집에 있을 거예요|naeil biga omyeon jibe isseul geoyeyo|Jika besok hujan, saya di rumah
커피 한 잔 주문할게요|keopi han jan jumunhalgeyo|Saya mau pesan satu kopi
역에 어떻게 가는지 알려 주세요|yeoge eotteoke ganeunji allyeo juseyo|Tolong beri tahu cara ke stasiun
만나기를 기대하고 있어요|mannagireul gidaehago isseoyo|Saya menantikan pertemuan denganmu
그녀는 피곤하다고 말했어요|geunyeoneun pigonhadago malhaesseoyo|Dia bilang bahwa dia lelah
이 아이디어에 대해 어떻게 생각해요?|i aidieoe daehae eotteoke saenggakhaeyo?|Bagaimana pendapatmu tentang ide ini?
집에 지갑을 두고 왔어요|jibe jigabeul dugo wasseoyo|Dompet saya tertinggal di rumah
같이 이 문제를 이야기해 봐요|gachi i munjereul iyagihae bwayo|Mari bahas masalah ini bersama
''',
  ];

  // ============================ FRENCH =============================
  static const _fr = <String>[
    '''
Bonjour|Halo / Selamat pagi
Bonsoir|Selamat sore / malam
Bonne nuit|Selamat tidur
Merci|Terima kasih
S'il vous plaît|Tolong
Pardon|Maaf
Oui|Ya
Non|Tidak
Au revoir|Selamat tinggal
Bienvenue|Selamat datang
''',
    '''
Livre|Buku
Eau|Air
Maison|Rumah
Voiture|Mobil
Ami|Teman
Nourriture|Makanan
Mère|Ibu
Père|Ayah
École|Sekolah
Argent|Uang
''',
    '''
Comment allez-vous ?|Apa kabar?
Je vais bien|Saya baik-baik saja
Enchanté|Senang bertemu denganmu
Comment vous appelez-vous ?|Siapa namamu?
D'où venez-vous ?|Dari mana asalmu?
Je ne comprends pas|Saya tidak mengerti
Répétez, s'il vous plaît|Tolong ulangi
Combien ça coûte ?|Berapa harganya?
Où sont les toilettes ?|Di mana kamar mandi?
À demain|Sampai jumpa besok
''',
    '''
Je suis étudiant|Saya seorang pelajar
Elle est ma mère|Dia ibu saya
J'aime les pommes|Saya suka apel
Nous allons à l'école|Kami pergi ke sekolah
Le chat dort|Kucing sedang tidur
Je bois de l'eau tous les jours|Saya minum air setiap hari
Il lit un livre|Dia membaca buku
Ma maison est grande|Rumah saya besar
Ils sont mes amis|Mereka teman saya
Le ciel est bleu|Langit berwarna biru
''',
    '''
Pourriez-vous m'aider, s'il vous plaît ?|Bisakah Anda membantu saya?
J'étudie le français depuis deux ans|Saya sudah belajar bahasa Prancis dua tahun
S'il pleut demain, nous resterons à la maison|Jika besok hujan, kami di rumah
Je voudrais commander un café|Saya ingin memesan kopi
Pouvez-vous m'indiquer le chemin de la gare ?|Bisakah Anda tunjukkan jalan ke stasiun?
J'ai hâte de vous rencontrer|Saya menantikan bertemu denganmu
Elle m'a dit qu'elle était fatiguée|Dia bilang kepada saya bahwa dia lelah
Que pensez-vous de cette idée ?|Bagaimana pendapat Anda tentang ide ini?
J'ai oublié mon portefeuille à la maison|Saya lupa dompet di rumah
Discutons de ce problème ensemble|Mari bahas masalah ini bersama
''',
  ];
}

// ====================== 2) PROGRESS ======================

/// Menyimpan bahasa terpilih, materi yang sudah selesai, dan level yang terbuka.
/// Progress disimpan terpisah untuk tiap bahasa dan tetap ada setelah app ditutup.
class ProgressStore extends ChangeNotifier {
  ProgressStore._();
  static final ProgressStore instance = ProgressStore._();

  SharedPreferences? _prefs;
  String _language = 'en';
  final Map<String, Set<int>> _done = {};
  final Set<String> _unlocked = {};

  String get language => _language;

  String _key(String lang, int level) => 'done_${lang}_$level';

  Future<void> load() async {
    if (_prefs != null) return;
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'en';
    _unlocked.addAll(prefs.getStringList('unlocked') ?? const []);
    for (final lang in LearningData.languages) {
      for (var lv = 1; lv <= LearningData.levelCount; lv++) {
        final saved = prefs.getStringList(_key(lang.code, lv)) ?? const [];
        _done[_key(lang.code, lv)] = saved.map(int.parse).toSet();
      }
    }
    _prefs = prefs;
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _language = code;
    await _prefs?.setString('language', code);
    notifyListeners();
  }

  // ---------- Pembacaan progress ----------
  int total(String lang, int level) => LearningData.items(lang, level).length;
  int doneCount(String lang, int level) => _done[_key(lang, level)]?.length ?? 0;
  bool isDone(String lang, int level, int index) =>
      _done[_key(lang, level)]?.contains(index) ?? false;

  bool isLevelCompleted(String lang, int level) {
    final t = total(lang, level);
    return t > 0 && doneCount(lang, level) >= t;
  }

  /// Level 1 selalu terbuka. Level berikutnya terbuka setelah level sebelumnya
  /// pernah diselesaikan (tidak terkunci lagi walau user membatalkan tanda selesai).
  bool isLevelUnlocked(String lang, int level) =>
      level == 1 || _unlocked.contains(_key(lang, level));

  int overallDone(String lang) {
    var n = 0;
    for (var lv = 1; lv <= LearningData.levelCount; lv++) {
      n += doneCount(lang, lv);
    }
    return n;
  }

  int overallTotal(String lang) {
    var n = 0;
    for (var lv = 1; lv <= LearningData.levelCount; lv++) {
      n += total(lang, lv);
    }
    return n;
  }

  // ---------- Skor terbaik matematika (difficulty 1..3) ----------
  int bestMath(int difficulty) => _prefs?.getInt('math_best_$difficulty') ?? 0;

  Future<void> saveMathBest(int difficulty, int score) async {
    if (score > bestMath(difficulty)) {
      await _prefs?.setInt('math_best_$difficulty', score);
      notifyListeners();
    }
  }

  // ---------- Aksi ----------
  /// Tandai / batalkan materi. Return true jika toggle ini baru saja
  /// menyelesaikan satu level penuh.
  Future<bool> toggle(String lang, int level, int index) async {
    final key = _key(lang, level);
    final set = _done.putIfAbsent(key, () => <int>{});
    final wasComplete = isLevelCompleted(lang, level);

    if (!set.remove(index)) set.add(index);

    final nowComplete = isLevelCompleted(lang, level);
    if (nowComplete && level < LearningData.levelCount) {
      _unlocked.add(_key(lang, level + 1)); // buka level berikutnya
    }

    await _prefs?.setStringList(key, set.map((e) => '$e').toList());
    await _prefs?.setStringList('unlocked', _unlocked.toList());
    notifyListeners();
    return !wasComplete && nowComplete;
  }
}

// ====================== 3) HALAMAN UI ======================

const Color kGreen = Color(0xFF58CC02);
const Color kGreenDark = Color(0xFF388E00);
const Color kGreenSoft = Color(0x2658CC02); // hijau transparan ~15%

// =====================================================================
// HALAMAN UTAMA: pilih bahasa + daftar level
// =====================================================================
class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  final _store = ProgressStore.instance;
  late final Future<void> _loading = _store.load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi Pembelajaran',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _loading,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListenableBuilder(
            listenable: _store,
            builder: (context, _) => _buildBody(context),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final lang = LearningData.language(_store.language);
    final done = _store.overallDone(lang.code);
    final total = _store.overallTotal(lang.code);
    final progress = total == 0 ? 0.0 : done / total;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1) PILIHAN BAHASA
        const Text('Pilih Bahasa',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: LearningData.languages.map((l) {
            return ChoiceChip(
              label: Text('${l.flag} ${l.name}'),
              selected: l.code == lang.code,
              selectedColor: kGreenSoft,
              onSelected: (_) => _store.setLanguage(l.code),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // HEADER + PROGRESS KESELURUHAN
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ayo Belajar ${lang.name}! ${lang.flag}',
                style: const TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selesaikan tiap level untuk membuka level berikutnya.',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$done dari $total materi selesai (${(progress * 100).round()}%)',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2) DAFTAR LEVEL 1-5
        const Text('Pilih Level',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...LearningData.levels.map((lv) => _levelCard(context, lang, lv)),
        const SizedBox(height: 12),

        // LATIHAN MATEMATIKA
        const Text('Latihan Matematika',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...List.generate(3, (i) => _mathCard(context, i + 1)),
      ],
    );
  }

  static const _mathNames = ['Mudah', 'Sedang', 'Sulit'];
  static const _mathDesc = [
    'Tambah dan kurang sampai 20',
    'Kali, bagi, tambah, kurang',
    'Dua operasi sekaligus',
  ];
  static const _mathIcons = [Icons.add, Icons.close, Icons.functions];

  Widget _mathCard(BuildContext context, int difficulty) {
    final best = _store.bestMath(difficulty);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: kGreenSoft,
          child: Icon(_mathIcons[difficulty - 1], color: kGreen, size: 28),
        ),
        title: Text(_mathNames[difficulty - 1],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${_mathDesc[difficulty - 1]}\nSkor terbaik: $best/10'),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MathQuizPage(difficulty: difficulty)),
        ),
      ),
    );
  }

  Widget _levelCard(BuildContext context, LanguageInfo lang, LevelInfo lv) {
    final unlocked = _store.isLevelUnlocked(lang.code, lv.number);
    final completed = _store.isLevelCompleted(lang.code, lv.number);
    final done = _store.doneCount(lang.code, lv.number);
    final total = _store.total(lang.code, lv.number);
    final progress = total == 0 ? 0.0 : done / total;

    return Card(
      elevation: unlocked ? 2 : 0,
      color: unlocked ? Colors.white : Colors.grey.shade200,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (!unlocked) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(
                    'Selesaikan Level ${lv.number - 1} dulu untuk membuka level ini.'),
              ));
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LevelPage(langCode: lang.code, level: lv.number),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: completed
                    ? kGreen
                    : unlocked
                        ? kGreenSoft
                        : Colors.grey.shade400,
                child: Icon(
                  completed
                      ? Icons.check
                      : unlocked
                          ? lv.icon
                          : Icons.lock,
                  color: completed || !unlocked ? Colors.white : kGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level ${lv.number} · ${lv.title}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(
                      unlocked
                          ? lv.subtitle
                          : 'Selesaikan Level ${lv.number - 1} untuk membuka',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    if (unlocked) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation(kGreen),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('$done/$total materi selesai',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                    ],
                  ],
                ),
              ),
              Icon(unlocked ? Icons.arrow_forward_ios : Icons.lock_outline,
                  size: 18, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// HALAMAN MATERI SATU LEVEL: daftar materi + suara + tombol Selesai
// =====================================================================
class LevelPage extends StatefulWidget {
  final String langCode;
  final int level;

  const LevelPage({super.key, required this.langCode, required this.level});

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  final _store = ProgressStore.instance;
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _search = TextEditingController();

  late final LanguageInfo _lang = LearningData.language(widget.langCode);
  late final LevelInfo _levelInfo = LearningData.levels[widget.level - 1];
  late final List<LearningItem> _items =
      LearningData.items(widget.langCode, widget.level);

  String _query = '';
  int? _speakingIndex; // index asli di _items

  @override
  void initState() {
    super.initState();
    _setupVoice();
  }

  Future<void> _setupVoice() async {
    await _tts.setLanguage(_lang.ttsLocale); // suara ikut bahasa terpilih
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _tts.setCompletionHandler(_resetSpeaking);
    _tts.setErrorHandler((_) => _resetSpeaking());
  }

  void _resetSpeaking() {
    if (mounted) setState(() => _speakingIndex = null);
  }

  Future<void> _speak(int index) async {
    try {
      await _tts.stop();
      setState(() => _speakingIndex = index);
      await _tts.speak(_items[index].title);
    } catch (_) {
      _resetSpeaking();
    }
  }

  Future<void> _stop() async {
    await _tts.stop();
    _resetSpeaking();
  }

  Future<void> _toggleDone(int index) async {
    final justCompleted =
        await _store.toggle(widget.langCode, widget.level, index);
    if (justCompleted && mounted) _showLevelComplete();
  }

  void _showLevelComplete() {
    final isLast = widget.level >= LearningData.levelCount;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Level Selesai!'),
        content: Text(isLast
            ? 'Hebat! Kamu sudah menyelesaikan semua level ${_lang.name}.'
            : 'Level ${widget.level + 1} sekarang terbuka. Lanjut belajar!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tetap di sini'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kGreen),
            onPressed: () {
              Navigator.pop(ctx); // tutup dialog
              Navigator.pop(context); // kembali ke daftar level
            },
            child: Text(isLast ? 'Selesai' : 'Ke daftar level'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F5),
      appBar: AppBar(
        title: Text('Level ${widget.level} · ${_levelInfo.title}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_speakingIndex != null)
            IconButton(
              tooltip: 'Hentikan suara',
              onPressed: _stop,
              icon: const Icon(Icons.stop_circle_outlined),
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _store,
        builder: (context, _) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final done = _store.doneCount(widget.langCode, widget.level);
    final total = _items.length;
    final progress = total == 0 ? 0.0 : done / total;

    // Simpan index asli supaya tanda "selesai" tetap benar saat difilter.
    final q = _query.toLowerCase();
    final filtered = <MapEntry<int, LearningItem>>[
      for (var i = 0; i < _items.length; i++)
        if (_items[i].title.toLowerCase().contains(q) ||
            _items[i].meaning.toLowerCase().contains(q) ||
            (_items[i].reading?.toLowerCase().contains(q) ?? false))
          MapEntry(i, _items[i]),
    ];

    return Column(
      children: [
        // HEADER + PROGRESS LEVEL
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          decoration: const BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_lang.flag} ${_lang.name} · ${_levelInfo.subtitle}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Text('$done dari $total materi selesai',
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.volume_up, color: Colors.white, size: 18),
                  SizedBox(width: 7),
                  Text('Ketuk speaker untuk mendengarkan',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),

        // PENCARIAN
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _search,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Cari materi pembelajaran...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _search.clear();
                        setState(() => _query = '');
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

        // DAFTAR MATERI
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('Tidak ada materi ditemukan'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final index = filtered[i].key;
                    return _itemCard(index, filtered[i].value);
                  },
                ),
        ),
      ],
    );
  }

  Widget _itemCard(int index, LearningItem item) {
    final isDone = _store.isDone(widget.langCode, widget.level, index);
    final speaking = _speakingIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? kGreen : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            leading: CircleAvatar(
              backgroundColor: isDone ? kGreen : kGreenSoft,
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text('${index + 1}',
                      style: const TextStyle(
                          color: kGreenDark, fontWeight: FontWeight.bold)),
            ),
            title: Text(item.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.reading != null)
                    Text(item.reading!,
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: kGreenDark)),
                  Text(item.meaning,
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            trailing: IconButton(
              tooltip: speaking ? 'Hentikan' : 'Dengarkan',
              onPressed: () => speaking ? _stop() : _speak(index),
              icon: Icon(
                speaking ? Icons.stop_circle : Icons.volume_up_rounded,
                color: kGreen,
                size: 29,
              ),
            ),
          ),

          // 3) TOMBOL SELESAI / SUDAH DIPELAJARI
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: isDone
                  ? OutlinedButton.icon(
                      onPressed: () => _toggleDone(index),
                      icon: const Icon(Icons.check_circle, size: 18),
                      label: const Text('Sudah dipelajari'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kGreenDark,
                        side: const BorderSide(color: kGreen),
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: () => _toggleDone(index),
                      icon: const Icon(Icons.done, size: 18),
                      label: const Text('Selesai'),
                      style: FilledButton.styleFrom(backgroundColor: kGreen),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}


// ====================== 4) LATIHAN MATEMATIKA ======================

class MathQuestion {
  final String text;
  final int answer;
  final List<int> options;
  const MathQuestion(this.text, this.answer, this.options);
}

class MathGenerator {
  static final Random _rnd = Random();

  static int _between(int min, int max) => min + _rnd.nextInt(max - min + 1);

  /// difficulty: 1 = mudah, 2 = sedang, 3 = sulit
  static MathQuestion generate(int difficulty) {
    String text;
    int answer;

    if (difficulty == 1) {
      // tambah / kurang sampai 20
      final a = _between(1, 20);
      final b = _between(1, 20);
      if (_rnd.nextBool()) {
        text = '$a + $b';
        answer = a + b;
      } else {
        final big = max(a, b), small = min(a, b);
        text = '$big − $small';
        answer = big - small;
      }
    } else if (difficulty == 2) {
      switch (_rnd.nextInt(4)) {
        case 0:
          final a = _between(2, 10), b = _between(2, 10);
          text = '$a × $b';
          answer = a * b;
        case 1:
          final b = _between(2, 10), q = _between(2, 10);
          text = '${b * q} ÷ $b';
          answer = q;
        case 2:
          final a = _between(10, 99), b = _between(10, 99);
          text = '$a + $b';
          answer = a + b;
        default:
          final a = _between(10, 99), b = _between(10, 99);
          final big = max(a, b), small = min(a, b);
          text = '$big − $small';
          answer = big - small;
      }
    } else {
      switch (_rnd.nextInt(3)) {
        case 0:
          final a = _between(5, 50), b = _between(2, 12), c = _between(2, 12);
          text = '$a + $b × $c';
          answer = a + b * c;
        case 1:
          final a = _between(2, 20), b = _between(2, 20), c = _between(2, 10);
          text = '($a + $b) × $c';
          answer = (a + b) * c;
        default:
          final a = _between(5, 15), b = _between(5, 15);
          final c = _between(1, a * b - 1);
          text = '$a × $b − $c';
          answer = a * b - c;
      }
    }
    return MathQuestion(text, answer, _options(answer));
  }

  static List<int> _options(int answer) {
    final opts = <int>{answer};
    while (opts.length < 4) {
      final c = answer + _between(-6, 6);
      if (c >= 0) opts.add(c);
    }
    return opts.toList()..shuffle(_rnd);
  }
}

class MathQuizPage extends StatefulWidget {
  final int difficulty; // 1..3
  const MathQuizPage({super.key, required this.difficulty});

  @override
  State<MathQuizPage> createState() => _MathQuizPageState();
}

class _MathQuizPageState extends State<MathQuizPage> {
  static const int totalQuestions = 10;
  static const _names = ['Mudah', 'Sedang', 'Sulit'];

  final _store = ProgressStore.instance;
  late List<MathQuestion> _questions;
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    final seen = <String>{};
    final list = <MathQuestion>[];
    while (list.length < totalQuestions) {
      final q = MathGenerator.generate(widget.difficulty);
      if (seen.add(q.text)) list.add(q); // tanpa soal yang sama
    }
    _questions = list;
    _index = 0;
    _score = 0;
    _selected = null;
    _finished = false;
  }

  void _answer(int value) {
    if (_selected != null) return; // sudah dijawab
    setState(() {
      _selected = value;
      if (value == _questions[_index].answer) _score++;
    });
  }

  void _next() {
    if (_index == totalQuestions - 1) {
      _store.saveMathBest(widget.difficulty, _score);
      setState(() => _finished = true);
    } else {
      setState(() {
        _index++;
        _selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F5),
      appBar: AppBar(
        title: Text('Matematika · ${_names[widget.difficulty - 1]}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
      ),
      body: _finished ? _buildResult() : _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_index];
    final answered = _selected != null;
    final correct = _selected == q.answer;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Soal ${_index + 1} dari $totalQuestions',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Skor: $_score',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: kGreenDark)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (_index + (answered ? 1 : 0)) / totalQuestions,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation(kGreen),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 36),
          decoration: BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text('${q.text} = ?',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 24),
        ...q.options.map((opt) {
          Color bg = Colors.white;
          Color border = Colors.grey.shade300;
          Color fg = Colors.black87;
          if (answered) {
            if (opt == q.answer) {
              bg = kGreenSoft;
              border = kGreen;
              fg = kGreenDark;
            } else if (opt == _selected) {
              bg = const Color(0x26E53935);
              border = const Color(0xFFE53935);
              fg = const Color(0xFFC62828);
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton(
              onPressed: () => _answer(opt),
              style: OutlinedButton.styleFrom(
                backgroundColor: bg,
                foregroundColor: fg,
                side: BorderSide(color: border, width: 2),
                minimumSize: const Size.fromHeight(58),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('$opt',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          );
        }),
        if (answered) ...[
          const SizedBox(height: 4),
          Text(
            correct ? 'Benar! 🎉' : 'Salah. Jawaban yang benar: ${q.answer}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: correct ? kGreenDark : const Color(0xFFC62828),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _next,
            style: FilledButton.styleFrom(
              backgroundColor: kGreen,
              minimumSize: const Size.fromHeight(52),
            ),
            child: Text(
                _index == totalQuestions - 1 ? 'Lihat hasil' : 'Soal berikutnya'),
          ),
        ],
      ],
    );
  }

  Widget _buildResult() {
    final best = _store.bestMath(widget.difficulty);
    final msg = _score == totalQuestions
        ? 'Sempurna! 🏆'
        : _score >= 7
            ? 'Hebat! 🎉'
            : _score >= 4
                ? 'Lumayan, terus berlatih ya 💪'
                : 'Jangan menyerah, coba lagi! 🌱';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('$_score / $totalQuestions',
                style: const TextStyle(
                    fontSize: 56, fontWeight: FontWeight.bold, color: kGreen)),
            const SizedBox(height: 8),
            Text('Skor terbaik: $best/$totalQuestions',
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => setState(_start),
              icon: const Icon(Icons.refresh),
              label: const Text('Ulangi'),
              style: FilledButton.styleFrom(
                backgroundColor: kGreen,
                minimumSize: const Size.fromHeight(52),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52)),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}