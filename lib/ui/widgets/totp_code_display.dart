import 'package:flutter/material.dart';

class TotpCodeDisplay extends StatelessWidget {
  final String code;
  final int remainingTime;
  final int period;

  const TotpCodeDisplay({
    super.key,
    required this.code,
    required this.remainingTime,
    required this.period,
  });

  String _formatCode(String code) {
    if (code.length == 6) {
      return '${code.substring(0, 3)} ${code.substring(3)}';
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 验证码显示
        Text(
          _formatCode(code),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            height: 1.2,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 倒计时进度条
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // 背景进度条
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // 前景进度条
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 6,
                  width: constraints.maxWidth * (remainingTime / period),
                  decoration: BoxDecoration(
                    color: remainingTime > 5 ? Colors.blue : Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            );
          }
        ),
        
        const SizedBox(height: 8),
        
        // 倒计时文本（右对齐）
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${remainingTime}s',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: remainingTime > 5 ? Colors.blue : Colors.red,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/${period}s',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}