import '../services/kcd_tree_service.dart';
import 'classification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'search_screen.dart';
import '../services/disease_service.dart';

class ModeScreen extends StatelessWidget {
  final DiseaseService diseaseService;

  const ModeScreen({
    super.key,
    required this.diseaseService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        title: const Text('질병분류기호'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '어떤 모드로\n검색하시겠어요?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildModeCard(
              context,
              icon: Icons.search,
              title: '일반 검색',
              subtitle: '빠르게 검색할 수 있어요',
              color: const Color(0xFF2563EB),
              isLargeText: false,
            ),

            const SizedBox(height: 12),

            _buildModeCard(
              context,
              icon: Icons.text_fields,
              title: '큰글자 검색 (시니어 모드)',
              subtitle: '글씨가 크게 보여요',
              color: const Color(0xFF10B981),
              isLargeText: true,
            ),

            const SizedBox(height: 28),

            const Text(
              '빠른 메뉴',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildQuickMenuCard(
                    icon: CupertinoIcons.square_grid_2x2_fill,
                    title: '전체분류',
			color: const Color(0xFFFF8A00),
			onTap: () {
			  Navigator.push(
			    context,
			    MaterialPageRoute(
			      builder: (context) => ClassificationScreen(
				  treeService: KcdTreeService(),
				),
			    ),
			  );
			},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickMenuCard(
                    icon: CupertinoIcons.person_crop_circle_fill,
                    title: '신체부위',
                    color: const Color(0xFF2563EB),
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickMenuCard(
                    icon: CupertinoIcons.textformat_abc,
                    title: '색인검색',
                    color: const Color(0xFF06B6D4),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isLargeText,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(
              diseaseService: diseaseService,
              initialIsLargeText: isLargeText,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
