import 'package:flutter/material.dart';

class UploadStatusScreen extends StatelessWidget {
  final String title;
  final String formatType;
  final String privacyStatus;
  final String hashtags;

  const UploadStatusScreen({
    super.key,
    required this.title,
    required this.formatType,
    required this.privacyStatus,
    required this.hashtags,
  });

  @style
  @override
  Widget build(BuildContext context) {
    bool isShorts = formatType == 'shorts';
    String videoUrl = isShorts ? "https://youtube.com/shorts/AI_DEMO_VID_889" : "https://youtu.be/AI_DEMO_VID_889";

    return Scaffold(
      appBar: AppBar(
        title: const Text('유튜브 업로드 완료'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF161824),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00CEC9), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00CEC9).withOpacity(0.2),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00CEC9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 40, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "🎉 유튜브 게시 완료!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "AI 자동 편집, 예능 자막, 해시태그 생성이 모두 완료되어 유튜브 채널에 게시되었습니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                  ),
                  const Divider(height: 30, color: Colors.white10),
                  
                  // Info rows
                  _infoRow("동영상 제목", title),
                  const SizedBox(height: 8),
                  _infoRow("업로드 포맷", isShorts ? "YouTube Shorts (9:16)" : "일반 롱폼 영상 (16:9)"),
                  const SizedBox(height: 8),
                  _infoRow("공개 상태", privacyStatus == 'unlisted' ? '일부공개' : (privacyStatus == 'public' ? '전체공개' : '비공개')),
                  const SizedBox(height: 16),

                  // URL Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link, color: Color(0xFF00CEC9), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            videoUrl,
                            style: const TextStyle(color: Color(0xFF00CEC9), fontSize: 13, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                "새로운 영상 편집하기",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
