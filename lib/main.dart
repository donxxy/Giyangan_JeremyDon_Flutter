import 'package:flutter/material.dart';
// google_fonts removed — use built-in TextStyle for web compatibility
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const CpuMembershipApp());
}

/// Root app widget.
class CpuMembershipApp extends StatelessWidget {
  const CpuMembershipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CPU Org Membership Card',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 30, 158, 175), // CPU maroon-ish tone
        // using default TextTheme to avoid external font package on web
      ),
      home: const MembershipCardScreen(),
    );
  }
}

/// Simple data model for a member — swap this with real data
/// (API response, local DB, etc.) in a production app.
class Member {
  final String name;
  final String orgName;
  final String course;
  final String memberId;
  final String validity;
  final String photoUrl;
  final String facebookUrl;

  const Member({
    required this.name,
    required this.orgName,
    required this.course,
    required this.memberId,
    required this.validity,
    required this.photoUrl,
    required this.facebookUrl,
  });
}

class MembershipCardScreen extends StatelessWidget {
  const MembershipCardScreen({super.key});

  // Sample member — update these fields as needed.
  static const Member _member = Member(
    name: 'Jeremy Don Giyangan',
    orgName: 'Philippine Society of Software Engineering',
    course: 'BS Sofware Engineering - II',
    memberId: '25-2331-49',
    validity: 'S.Y. 2025 - 2026',
    photoUrl: 'https://relay.xstlo.com/p/9ycihn.jpg',
    facebookUrl: 'https://www.facebook.com/CentralPhilippineUniversity.CPU',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3ECE9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 26, 85, 161),
        title: const Text(
          'Digital Membership Card',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _MembershipCard(member: _member),
          ),
        ),
      ),
    );
  }
}

/// The polished, single-screen membership card widget tree.
/// Includes the "Visit CPU Facebook Page" button as part of the card.
class _MembershipCard extends StatelessWidget {
  final Member member;
  const _MembershipCard({required this.member});

  Future<void> _openFacebookPage(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the Facebook page.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(255, 48, 169, 199), Color.fromARGB(255, 21, 142, 179)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background circles for visual polish
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: org name + a small crest placeholder
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.school, color: Color(0xFF7A1E2B)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CENTRAL PHILIPPINE UNIVERSITY',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              member.orgName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Photo + name/details row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _MemberPhoto(photoUrl: member.photoUrl),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              member.course,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _InfoChip(
                              icon: Icons.badge_outlined,
                              label: member.memberId,
                            ),
                            const SizedBox(height: 6),
                            _InfoChip(
                              icon: Icons.event_available_outlined,
                              label: 'Valid ${member.validity}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.white.withOpacity(0.25), height: 1),
                  const SizedBox(height: 12),

                  // "Official Member" badge row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'OFFICIAL MEMBER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.verified, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Facebook button lives inside the card
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1877F2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.facebook),
                      label: const Text(
                        'Visit CPU Facebook Page',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      onPressed: () => _openFacebookPage(context, member.facebookUrl),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),                                                                
    );
  }
}

/// Circular member photo loaded with cached_network_image so repeat
/// visits to this screen don't re-download the image, and a
/// placeholder/error widget is shown while loading or on failure.
class _MemberPhoto extends StatelessWidget {
  final String photoUrl;
  const _MemberPhoto({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoUrl,
          width: 86,
          height: 86,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 86,
            height: 86,
            color: Colors.white24,
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 86,
            height: 86,
            color: Colors.white24,
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }
}

/// Small pill-style info row used for ID number and validity period.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 14),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}