import 'package:flutter/material.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFormat = 'shorts'; // 'shorts' (9:16) or 'longform' (16:9)
  bool autoSubtitles = true;
  bool autoCutSilence = true;
  bool generateHashtags = true;
  bool isUploading = false;
  String? selectedFileName;

  void _pickVideo() {
    setState(() {
      selectedFileName = "smartphone_recording_2026.mp4";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("📸 스마트폰 영상 파일이 선택되었습니다."),
        backgroundColor: Color(0xFF6C5CE7),
      ),
    );
  }

  void _startAIAnalysis() {
    if (selectedFileName == null) {
      _pickVideo();
    }
    setState(() {
      isUploading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        isUploading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditorScreen(
            formatType: selectedFormat,
            videoName: selectedFileName ?? "smartphone_recording_2026.mp4",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF00CEC9)),
            const SizedBox(width: 8),
            const Text(
              'AI YouTube Auto Studio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.videocam_outlined, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "휴대폰 영상만 선택하면 끝!",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "AI가 NG컷을 자르고 예능 자막을 입히며, 제목과 해시태그까지 자동으로 생성하여 당신의 유튜브에 올립니다.",
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Video Upload Zone
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF161824),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selectedFileName != null ? const Color(0xFF00CEC9) : Colors.white24,
                    width: selectedFileName != null ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      selectedFileName != null ? Icons.check_circle : Icons.cloud_upload_outlined,
                      size: 48,
                      color: selectedFileName != null ? const Color(0xFF00CEC9) : const Color(0xFFA29BFE),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      selectedFileName ?? "스마트폰 동영상 파일 터치하여 선택",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: selectedFileName != null ? Colors.white : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedFileName != null ? "파일 준비 완료 (클릭하여 다른 영상 선택)" : "MP4, MOV, AVI 지원 (최대 4K)",
                      style: const TextStyle(fontSize: 12, color: Colors.white38),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Video Format Selection
            const Text(
              "🎯 타깃 유튜브 영상 포맷",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _FormatCard(
                    title: "YouTube Shorts",
                    subtitle: "9:16 세로 숏폼",
                    icon: Icons.stay_current_portrait,
                    isSelected: selectedFormat == 'shorts',
                    onTap: () => setState(() => selectedFormat = 'shorts'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FormatCard(
                    title: "일반 롱폼 영상",
                    subtitle: "16:9 가로 동영상",
                    icon: Icons.stay_current_landscape,
                    isSelected: selectedFormat == 'longform',
                    onTap: () => setState(() => selectedFormat = 'longform'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // AI Options
            const Text(
              "🤖 AI 자동 편집 옵션",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161824),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Whisper AI 정밀 자막 생성", style: TextStyle(fontSize: 14)),
                    subtitle: const Text("예능 스타일 하이라이트 색상 자막 렌더링", style: TextStyle(fontSize: 12, color: Colors.white38)),
                    value: autoSubtitles,
                    activeColor: const Color(0xFF00CEC9),
                    onChanged: (val) => setState(() => autoSubtitles = val),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  SwitchListTile(
                    title: const Text("무음 구간 & NG컷 자동 삭제", style: TextStyle(fontSize: 14)),
                    subtitle: const Text("말 없는 빈공간을 탐지하여 타이트하게 커팅", style: TextStyle(fontSize: 12, color: Colors.white38)),
                    value: autoCutSilence,
                    activeColor: const Color(0xFF00CEC9),
                    onChanged: (val) => setState(() => autoCutSilence = val),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  SwitchListTile(
                    title: const Text("Gemini SEO 제목 & 해시태그 추출", style: TextStyle(fontSize: 14)),
                    subtitle: const Text("유튜브 알고리즘 추천 키워드 10개 이상 생성", style: TextStyle(fontSize: 12, color: Colors.white38)),
                    value: generateHashtags,
                    activeColor: const Color(0xFF00CEC9),
                    onChanged: (val) => setState(() => generateHashtags = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Action Button
            ElevatedButton(
              onPressed: isUploading ? null : _startAIAnalysis,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 5,
              ),
              child: isUploading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text("AI가 영상을 분석하는 중...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, color: Colors.white),
                        SizedBox(width: 8),
                        Text("AI 자동 분석 & 편집 시작하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C5CE7).withOpacity(0.2) : const Color(0xFF161824),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C5CE7) : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF00CEC9) : Colors.white54, size: 32),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.white70)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}
