import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.lock_outline,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'AuthX TOTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                '版本 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '介绍',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AuthX TOTP 是一个开源的双因素认证（2FA）应用程序，'
              '支持基于时间的一次性密码（TOTP）标准，'
              '帮助您安全地保护您的在线账户。',
            ),
            const SizedBox(height: 24),
            const Text(
              '功能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.qr_code),
              title: Text('二维码扫描'),
              subtitle: Text('通过扫描二维码快速添加账户'),
            ),
            const ListTile(
              leading: Icon(Icons.security),
              title: Text('安全存储'),
              subtitle: Text('使用安全存储保护您的密钥'),
            ),
            const ListTile(
              leading: Icon(Icons.sync),
              title: Text('实时同步'),
              subtitle: Text('自动更新验证码和倒计时'),
            ),
            const SizedBox(height: 24),
            const Text(
              '开源许可',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '本应用是开源软件，使用MIT许可证发布。\n'
              '源代码可在GitHub上获取。',
            ),
            const Spacer(),
            Center(
              child: Text(
                '© ${DateTime.now().year} AuthX TOTP',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}