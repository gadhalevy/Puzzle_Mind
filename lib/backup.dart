import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const PuzzleMindApp());
}

class PuzzleMindApp extends StatelessWidget {
  const PuzzleMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Mind',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.desktopLayout,
  });

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return mobileLayout;
        }
        return desktopLayout;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController _emailController = TextEditingController();
  bool _showGames = false;
  String _selectedGame = 'תשבץ הגיון';

  Future<void> sendEmail(String receiver) async {
    if (receiver.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'נא להזין כתובת אימייל',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }

    try {
      final emailPassword = dotenv.env['EMAIL_PASSWORD'] ?? '';
      final smtpServer = gmail('khanuka1912@gmail.com', emailPassword);

      final message = Message()
        ..from = const Address('khanuka1912@gmail.com', 'Puzzle Mind')
        ..recipients.add(receiver)
        ..subject = 'Puzzle Mind'
        ..text = 'צורפת לרשימת התפוצה של Puzzle Mind';

      await send(message, smtpServer);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'האימייל נשלח בהצלחה!',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
        _emailController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'שגיאה בשליחת האימייל: $e',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      }
    }
  }

  Widget _buildFeatureCard(String title, String description, Color color, String imagePath) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildGameDescription() {
    return const Text(
      'פאזל מיינד מציעה משחקי חשיבה מאתגרים המפתחים יכולות קוגנטיביות ומחזקים את הזיכרון. המשחקים מציעים מגוון רחב של אתגרים המותאמים לכל הרמות והגילים.',
      style: TextStyle(fontSize: 18),
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    );
  }

  Widget _buildGamesSection() {
    return Column(
      children: [
        Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _showGames = !_showGames;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_showGames ? Icons.expand_less : Icons.expand_more),
                    const SizedBox(width: 8),
                    const Text(
                      'מה יש לנו להציע?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_showGames) ...[
          const SizedBox(height: 16),
          Center(
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(value: 'תשבץ הגיון', label: Text('תשבץ הגיון')),
                ButtonSegment<String>(value: 'זיהוי דמות', label: Text('זיהוי דמות')),
                ButtonSegment<String>(value: 'זיהוי מקום', label: Text('זיהוי מקום')),
              ],
              selected: {_selectedGame},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedGame = newSelection.first;
                });
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  const TextStyle(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: _buildSelectedGameContent(),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectedGameContent() {
    String imagePath;
    String title;
    String description;
    Color color;

    switch (_selectedGame) {
      case 'תשבץ הגיון':
        imagePath = 'assets/images/higayon.png';
        title = 'תשבץ הגיון';
        description = 'תשבץ הגיון מבוסס הקשר לארוע מסוים או לקבוצה מסוימת מוקרן על מסך גדול המנצח הינו זה הפותר את מירב ההגדרות.';
        color = Colors.yellow;
        break;
      case 'זיהוי דמות':
        imagePath = 'assets/images/mi.png';
        title = 'מי הדמות';
        description = 'פלטפורמה של משחקים שבה המשתמש כותב חידה על דמות בטלפון החידה מוקרנת על מסך גדול ושאר המשתתפים פותרים כל חידה בתורה המנצח הינו זה שזיהה את מירב הדמויות.';
        color = Colors.cyan;
        break;
      case 'זיהוי מקום':
        imagePath = 'assets/images/place.png';
        title = 'זיהוי מקום';
        description = 'המערכת בוחרת יישוב מסוים בארץ כמטרה, כל משתתף בוחר ישוב מסוים דרך הטלפון ומקבל חיווי על המרחק והכיוון של הבחירה שלו מהמטרה המנצח הינו הקרוב ביותר למטרה.';
        color = Colors.greenAccent;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/mankhe.png',
              height: 200,
            ),
            const SizedBox(height: 32),
            const Text(
              'ברוכים הבאים לפאזל מיינד',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            _buildGameDescription(),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'הכנס אימייל ליצירת קשר',
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => sendEmail(_emailController.text),
              child: const Text('!שלח'),
            ),
            const SizedBox(height: 32),
            const Text(
              'למה לבחור בנו?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildFeatureCard(
                  'הנאה צרופה',
                  'חוויה מהנה ובלתי נשכחת שתגרום לכם לצחוק להנות ולהתחבר יחד.',
                  Colors.blue,
                  'assets/images/hanaa.png',
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  'חוויה מעצימה ומגבשת',
                  'פיתוח חשיבה יצירתית עבודת צוות ופתרון בעיות מורכבות בדרך מהנה ומאתגרת.',
                  Colors.green,
                  'assets/images/havaia.png',
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  'משחקי חברה חכמים ומענינים',
                  'מגוון רחב של משחקים חברתיים המשלבים איסטרטגיה יצירתיות ואינטרקציה חברתית.',
                  Colors.orange,
                  'assets/images/haham.png',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildGamesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'ברוכים הבאים לפאזל מיינד',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 16),
                      _buildGameDescription(),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'הכנס אימייל',
                                border: OutlineInputBorder(),
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => sendEmail(_emailController.text),
                            child: const Text('!שלח'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/mankhe.png',
                  width: 375,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32),
            color: Colors.grey[100],
            child: Column(
              children: [
                const Text(
                  'למה לבחור בנו?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFeatureCard(
                      'הנאה צרופה',
                      'חוויה מהנה ובלתי נשכחת שתגרום לכם לצחוק להנות ולהתחבר יחד.',
                      Colors.blue,
                      'assets/images/hanaa.png',
                    ),
                    _buildFeatureCard(
                      'חוויה מעצימה ומגבשת',
                      'פיתוח חשיבה יצירתית עבודת צוות ופתרון בעיות מורכבות בדרך מהנה ומאתגרת.',
                      Colors.green,
                      'assets/images/havaia.png',
                    ),
                    _buildFeatureCard(
                      'משחקי חברה חכמים ומענינים',
                      'מגוון רחב של משחקים חברתיים המשלבים איסטרטגיה יצירתיות ואינטרקציה חברתית.',
                      Colors.orange,
                      'assets/images/haham.png',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildGamesSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileLayout: _buildMobileLayout(),
        desktopLayout: _buildDesktopLayout(),
      ),
    );
  }
}
