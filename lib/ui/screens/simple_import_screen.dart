import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authx/models/totp_entry.dart';
import 'package:authx/providers/totp_provider.dart';
import 'package:authx/utils/totp_parser.dart';

class SimpleImportScreen extends StatefulWidget {
  const SimpleImportScreen({super.key});

  @override
  State<SimpleImportScreen> createState() => _SimpleImportScreenState();
}

class _SimpleImportScreenState extends State<SimpleImportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uriController = TextEditingController();
  
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _uriController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
        _errorMessage = null;
      });

      try {
        // 解析URI
        final parsed = TotpParser.parseUri(_uriController.text.trim());
        
        // 创建TOTP条目
        final entry = TotpEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: parsed.name,
          issuer: parsed.issuer,
          secret: parsed.secret,
          digits: parsed.digits,
          algorithm: parsed.algorithm,
          period: parsed.period,
          icon: parsed.icon,
        );
        
        // 保存到存储
        final provider = Provider.of<TotpProvider>(context, listen: false);
        await provider.addEntry(entry);
        
        if (mounted) {
          // 返回成功结果
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        setState(() {
          _errorMessage = '无法解析URI: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入验证器'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '支持的导入格式',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• TOTP URI (otpauth://totp/...)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '• 包含密钥、发行方和账户名的标准URI',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '• 支持自定义位数、算法和周期参数',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '• 支持图标参数',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              
              // URI输入框
              TextFormField(
                controller: _uriController,
                maxLines: 8, // 增大输入框高度
                minLines: 5, // 增大输入框最小高度
                decoration: const InputDecoration(
                  labelText: '粘贴导入内容',
                  hintText: 'otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入导入内容';
                  }
                  
                  if (!value.startsWith('otpauth://totp/')) {
                    return '不支持的导入格式';
                  }
                  
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // 格式示例
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '格式示例:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'otpauth://totp/Google:example@gmail.com?secret=JBSWY3DPEHPK3PXP&issuer=Google',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 导入按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _submitForm,
                  child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('导入验证器'),
                ),
              ),
              
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}