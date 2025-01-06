import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomeScreen(),
    );
  }
}

class Profile {
  final String imageUrl;
  final String name;
  final int age;
  final String job;
  final String location;

  Profile({
    required this.imageUrl,
    required this.name,
    required this.age,
    required this.job,
    required this.location,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final List<Profile> profiles;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _rightSlideAnimation;
  int currentIndex = 0;
  bool isRightSwipe = false;
  double _dragOffset = 0;
  double _angle = 0;
  bool _isDragging = false;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    // İnternet bağlantısını dinle
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _hasInternet = result != ConnectivityResult.none;
      });
    });

    // Örnek profiller
    profiles = [
      Profile(
        imageUrl: 'https://picsum.photos/400/500?random=1',
        name: 'Ayşe',
        age: 25,
        job: 'Mimar',
        location: 'İstanbul',
      ),
      Profile(
        imageUrl: 'https://picsum.photos/400/500?random=2',
        name: 'Mehmet',
        age: 28,
        job: 'Yazılımcı',
        location: 'Ankara',
      ),
      Profile(
        imageUrl: 'https://picsum.photos/400/500?random=3',
        name: 'Zeynep',
        age: 24,
        job: 'Doktor',
        location: 'İzmir',
      ),
    ];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _hasInternet = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showNextProfile({required bool swipeRight}) {
    setState(() {
      isRightSwipe = swipeRight;
      _animationController.forward().then((_) {
        setState(() {
          currentIndex = (currentIndex + 1) % profiles.length;
          _animationController.reset();
          _dragOffset = 0;
          _angle = 0;
        });
      });
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _angle = (_dragOffset / 1000).clamp(-0.349066, 0.349066);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragOffset.abs() > 100) { // Eşik değeri
      if (_dragOffset > 0) {
        _showNextProfile(swipeRight: true);
      } else {
        _showNextProfile(swipeRight: false);
      }
    } else {
      // Kartı orijinal konumuna geri getir
      setState(() {
        _dragOffset = 0;
        _angle = 0;
      });
    }
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tinder',
          style: GoogleFonts.pacifico(
            fontSize: 32,
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.pink,
                  size: 22,
                ),
              ),
            ),
            onPressed: () {
              // Profil sayfasına yönlendirme
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(Icons.chat_bubble, color: Colors.pink),
              ),
              onPressed: () {
                // Mesajlaşma sayfasına yönlendirme
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profil Kartı
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Sürüklenebilir kart
                    Transform.translate(
                      offset: Offset(_dragOffset, 0),
                      child: Transform.rotate(
                        angle: _angle,
                        child: GestureDetector(
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child: Stack(
                            children: [
                              _buildProfileCard(profiles[currentIndex]),
                              if (_isDragging) ...[
                                if (_dragOffset > 50)
                                  Positioned(
                                    top: 50,
                                    right: 20,
                                    child: Transform.rotate(
                                      angle: -_angle,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.pink,
                                            width: 4,
                                          ),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Colors.pink,
                                          size: 60,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_dragOffset < -50)
                                  Positioned(
                                    top: 50,
                                    left: 20,
                                    child: Transform.rotate(
                                      angle: -_angle,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 4,
                                          ),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 60,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 24), // Sol boşluk
                    _buildActionButton(Icons.close, Colors.red,
                        () => _showNextProfile(swipeRight: false)),
                    _buildActionButton(Icons.star, Colors.blue,
                        () => _showNextProfile(swipeRight: true)),
                    _buildActionButton(Icons.favorite, Colors.pink,
                        () => _showNextProfile(swipeRight: true)),
                    const SizedBox(width: 24), // Sağ boşluk
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    if (!_hasInternet) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 50,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 10),
            Text(
              'İnternet bağlantısı yok',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 10),
              Text(
                'Resim yüklenemedi',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(Profile profile) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.65,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Resim
              _buildProfileImage(profile.imageUrl),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
              
              // Bilgi kısmı
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${profile.name}, ',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${profile.age}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${profile.job} • ${profile.location}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: color,
        iconSize: 30,
        onPressed: onPressed,
      ),
    );
  }
}
