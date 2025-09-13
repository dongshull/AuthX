import 'package:flutter/services.dart';
import 'package:authx/utils/totp_parser.dart';

class ClipboardService {
  static final ClipboardService _instance = ClipboardService._internal();
  String _lastClipboardContent = '';

  factory ClipboardService() => _instance;

  ClipboardService._internal();

  /// 手动检查剪贴板中的TOTP URI
  Future<String?> checkClipboardForTotpUri() async {
    try {
      final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      final String? clipboardText = data?.text;

      if (clipboardText != null && 
          clipboardText != _lastClipboardContent && 
          clipboardText.startsWith('otpauth://totp/')) {
        
        // 验证是否为有效的TOTP URI
        try {
          TotpParser.parseUri(clipboardText);
          _lastClipboardContent = clipboardText;
          return clipboardText;
        } catch (e) {
          // 不是有效的TOTP URI，返回null
          return null;
        }
      }
      return null;
    } catch (e) {
      // 忽略剪贴板访问错误
      return null;
    }
  }
}