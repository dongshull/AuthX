import 'package:flutter/material.dart';
import 'package:authx/models/totp_entry.dart';

class TotpCard extends StatelessWidget {
  final TotpEntry entry;
  final String totpCode;
  final int remainingTime;

  const TotpCard({
    super.key,
    required this.entry,
    required this.totpCode,
    required this.remainingTime,
  });

  String _formatTotpCode(String code) {
    if (code.length == 6) {
      return '${code.substring(0, 3)} ${code.substring(3)}';
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    final String issuer = entry.issuer.isNotEmpty ? entry.issuer : 'Unknown';
    final String accountName = entry.name.isNotEmpty ? entry.name : 'No name';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 头像
            CircleAvatar(
              radius: 28, // 进一步增大头像尺寸
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Text(
                issuer.isEmpty ? '?' : issuer.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 24, // 调整字体大小以适应更大的头像
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 账户信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issuer,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    accountName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // 验证码和倒计时
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTotpCode(totpCode),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${remainingTime}s',
                  style: TextStyle(
                    fontSize: 12,
                    color: remainingTime > 5 ? Colors.grey : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}