import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:authx/models/totp_entry.dart';

class SimpleTotpCard extends StatelessWidget {
  final TotpEntry entry;
  final String totpCode;
  final int remainingTime;

  const SimpleTotpCard({
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

  Widget _buildAvatar() {
    // 如果有图标URL，则显示图标；否则显示默认头像
    final String icon = entry.icon.isNotEmpty ? entry.icon : '';
    
    if (icon.isNotEmpty) {
      try {
        // 判断是base64编码还是网络图片链接
        if (icon.startsWith('data:image')) {
          // base64编码图片
          return CircleAvatar(
            radius: 24,
            backgroundImage: MemoryImage(
              _decodeBase64Image(icon),
            ),
          );
        } else {
          // 网络图片链接
          return CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(icon),
          );
        }
      } catch (e) {
        // 如果加载失败，回退到默认头像
        return _buildDefaultAvatar();
      }
    } else {
      // 默认头像
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    final String issuer = entry.issuer.isNotEmpty ? entry.issuer : 'Unknown';
    
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.blue.withOpacity(0.1),
      child: Text(
        issuer.isEmpty ? '?' : issuer.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 20,
        ),
      ),
    );
  }

  Uint8List _decodeBase64Image(String base64String) {
    // 移除base64数据URI前缀
    final String base64Data = base64String.split(',').last;
    // 解码base64字符串
    return Uint8List.fromList(base64.decode(base64Data));
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
            // 头像或图标
            _buildAvatar(),
            
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