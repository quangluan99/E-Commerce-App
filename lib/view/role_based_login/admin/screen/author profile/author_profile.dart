// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorProfileScreen extends StatefulWidget {
  const AuthorProfileScreen({super.key});

  @override
  State<AuthorProfileScreen> createState() => _AuthorProfileScreenState();
}

class _AuthorProfileScreenState extends State<AuthorProfileScreen> {
  bool _isFollowing = false;
  int _followerCount = 137;
  final String avatarUrl =
      'https://firebasestorage.googleapis.com/v0/b/e-commerce-app-d0db2.firebasestorage.app/o/avarta.png?alt=media&token=72fd3492-fabb-4898-a3cf-55f635aff499';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/e-commerce-app-d0db2.firebasestorage.app/o/hometown.png?alt=media&token=e6394fff-7655-482a-96fb-df6ccab0e63a',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  _buildBioSection(),
                  const SizedBox(height: 24),
                  _buildSocialLinks(),
                  const SizedBox(height: 24),
                  _buildRecentPosts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImagePage(imageUrl: avatarUrl),
              ),
            );
          },
          child: Hero(
            tag: 'author-avatar',
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Bùi Quang Luân',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Flutter Developer & Technical Writer',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFollowing ? Colors.grey : Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                setState(() {
                  _isFollowing = !_isFollowing;
                  _followerCount += _isFollowing ? 1 : -1;
                });
              },
              child: Text(
                _isFollowing ? 'FOLLOWING' : 'FOLLOW',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            OutlinedButton(
              onPressed: () {},
              child: const Text(
                'Have A Nice Day ♥️',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn('Posts', '7.0'),
        _buildStatColumn('Followers', _followerCount.toString()),
        _buildStatColumn('Following', '89'),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '''  Hi, I am Luân, seeking a Flutter Intern role. With a strong foundation in Flutter and Dart, plus basic Kotlin and Java skills, I’ve built real-world projects at university and personal projects. I love Flutter’s “one codebase, multi-platform” approach for saving development time while ensuring smooth, consistent UX across devices. ''',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '''  A proactive communicator and time-manager, I excel in team settings and enjoy learning from mentors and sharing knowledge. In the short term, I aim to sharpen my skills and gain valuable internship experience; long-term, I aspire to be a Flutter Software Engineer designing and delivering large-scale, high-quality applications. My passion for technology and professional attitude will allow me to contribute and grow quickly in your company.''',
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16.0),
        const Text(
          'Connect with me',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16.0),
        Wrap(
          spacing: 20,
          children: [
            _buildSocialIcon(Icons.facebook, 'Facebook',
                'https://www.facebook.com/profile.php?id=100011622435983'),
            _buildSocialIcon(
                Icons.code, 'GitHub', 'https://github.com/quangluan99'),
            _buildSocialIcon(Iconsax.instagram, 'Instagram',
                'https://www.instagram.com/lunaahh33/'),
          ],
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child:
                _buildContact(Icons.email, 'Email: ', 'bqluan1902@gmail.com')),
        _buildContact(Icons.phone, 'Phone: ', '0344279504'),
      ],
    );
  }

  Row _buildContact(IconData icon, String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(
          width: 8.0,
        ),
        Text.rich(
          TextSpan(
              text: title,
              style: const TextStyle(fontWeight: FontWeight.w800),
              children: [
                TextSpan(
                    text: content,
                    style: const TextStyle(color: Colors.deepPurpleAccent))
              ]),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String label, String url) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cannot open link: $url')),
              );
            }
          },
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRecentPosts() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Recent Posts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      const SizedBox(height: 16),
      ...List.generate(3, (index) => _buildPostItem(context, index)),
    ]);
  }
}

Widget _buildPostItem(BuildContext context, int index) {
  // URL
  const List<String> postUrls = [
    'https://github.com/quangluan99/E-Commerce-App',
    'https://github.com/quangluan99/Hotel-Booking-App',
    'https://github.com/quangluan99/BookApp',
  ];

  const List<String> date = [
    'May, 2025',
    'February , 2025',
    'December , 2024',
  ];

  const List<String> title = [
    'E Commerce App ',
    'Hotel Booking App',
    'Book App'
  ];

  final String postUrl = postUrls[index % postUrls.length];

  return InkWell(
    onTap: () async {
      final Uri uri = Uri.parse(postUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot open link: $postUrl')),
        );
      }
    },
    child: Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage('assets/author_post/image${index + 1}.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(title[index]),
        subtitle: Text(date[index]),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    ),
  );
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: 'author-avatar',
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 33.0),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
