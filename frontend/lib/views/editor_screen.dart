import 'package:flutter/material.dart';
import 'upload_status_screen.dart';

class EditorScreen extends StatefulWidget {
  final String formatType;
  final String videoName;

  const EditorScreen({
    super.key,
    required this.formatType,
    required this.videoName,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _hashtagController;

  bool isRendering = false;
  String privacyStatus = 'unlisted'; // 'public', 'unlisted', 'private'

  final List<String> titleCandidates = [
    "🔥 AI가 분석한 오늘의 하이라이트 순간!",
    "이 영상 꼭 보세요! 1분만에 끝나는 일상 꿀팁",
    "스마트폰 촬영 영상을 AI로 편집해봤습니다"
  ];

  final List<Map<String, dynamic>> subtitles = [
    {"start": "00:00", "end": "00:04", "text": "안녕하세요! 오늘 촬영한 일상 테스트 영상입니다."},
    {"start": "00:04", "end": "00:08", "text": "AI가 무음 구간을 지우고 예능 자막을 달아주네요."},
    {"start": "00:08", "end": "00:13", "text": "클릭 한 번으로 제 유튜브 채널에 자동 업로드됩니다!"}
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: titleCandidates[0]);
    _descController = TextEditingController(
      text: "스마트폰으로 촬영한 원본 영상을 AI가 분석하고 편집하여 게시한 영상입니다.\n\n#Shorts #AI자동편집 #유튜브스튜디오 #크리에이터"
    );
    _hashtagController = TextEditingController(
      text: "#Shorts, #AI편집, #유튜브자동화, #스마트폰촬영, #하이라이트, #자동자막, #AITools"
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  void _renderAndPublish() {
    setState(() {
      isRendering = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        isRendering = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadStatusScreen(
            title: _titleController.text,
            formatType: widget.formatType,
            privacyStatus: privacyStatus,
            hashtags: _hashtagController.text,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isShorts = widget.formatType == 'shorts';

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Studio 스튜디오 편집'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF00CEC9)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Mockup Window
            Center(
              child: Container(
                width: isShorts ? 220 : MediaQuery.of(context).size.width,
                height: isShorts ? 360 : 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6C5CE7), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C5CE7).withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_circle_fill, color: Color(0xFF00CEC9), size: 56),
                          const SizedBox(height: 8),
                          Text(
                            isShorts ? "Shorts (9:16) 미리보기" : "롱폼 (16:9) 미리보기",
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // Subtitle Overlay Demo Badge
                    Positioned(
                      bottom: 20,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.yellow, width: 1.5),
                        ),
                        child: const Text(
                          "🔥 AI 예능 자막: 오늘 촬영한 소중한 영상입니다!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // AI Title Candidate Selector
            const Text(
              "✨ Gemini AI 추천 제목 선택",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Column(
              children: titleCandidates.map((cand) {
                bool isSelected = _titleController.text == cand;
                return GestureDetector(
                  onTap: () => setState(() => _titleController.text = cand),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6C5CE7).withOpacity(0.25) : const Color(0xFF161824),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? const Color(0xFF6C5CE7) : Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isSelected ? const Color(0xFF00CEC9) : Colors.white38,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(cand, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : Colors.white70)),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Custom Title Field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "최종 유튜브 제목",
                labelStyle: const TextStyle(color: Color(0xFFA29BFE)),
                filled: true,
                fillColor: const Color(0xFF161824),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),

            // Subtitle Timeline Cards
            const Text(
              "📝 Whisper AI 자막 검토",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161824),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: subtitles.map((sub) {
                  return ListTile(
                    dense: true,
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${sub['start']}",
                        style: const TextStyle(fontSize: 11, color: Color(0xFF00CEC9), fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(sub['text'], style: const TextStyle(fontSize: 13, color: Colors.white)),
                    trailing: const Icon(Icons.edit_note, color: Colors.white38, size: 20),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Hashtags Field
            TextField(
              controller: _hashtagController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "자동 생성된 SEO 해시태그",
                labelStyle: const TextStyle(color: Color(0xFFA29BFE)),
                filled: true,
                fillColor: const Color(0xFF161824),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),

            // Privacy Status Dropdown
            Row(
              children: [
                const Text("유튜브 공개 범위: ", style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: privacyStatus,
                  dropdownColor: const Color(0xFF161824),
                  style: const TextStyle(color: Color(0xFF00CEC9), fontWeight: FontWeight.bold),
                  items: const [
                    DropdownMenuItem(value: 'unlisted', child: Text('일부공개 (권장)')),
                    DropdownMenuItem(value: 'public', child: Text('전체공개')),
                    DropdownMenuItem(value: 'private', child: Text('비공개')),
                  ],
                  onChanged: (val) => setState(() => privacyStatus = val!),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Upload Button
            ElevatedButton(
              onPressed: isRendering ? null : _renderAndPublish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00CEC9),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 5,
              ),
              child: isRendering
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text("FFmpeg 렌더링 & 유튜브 업로드 중...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, color: Colors.black),
                        SizedBox(width: 8),
                        Text("유튜브에 최종 영상 업로드하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
