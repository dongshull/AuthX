import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authx/models/totp_entry.dart';
import 'package:authx/providers/totp_provider.dart';
import 'package:authx/services/clipboard_service.dart';
import 'package:authx/ui/screens/qr_scanner_screen.dart';
import 'package:authx/utils/totp_parser.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _issuerController = TextEditingController();
  final _secretController = TextEditingController();
  final _iconController = TextEditingController(); // 图标输入控制器
  
  bool _isManualInput = true;
  String? _scanResult;

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    _secretController.dispose();
    _iconController.dispose(); // 释放图标控制器
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String id = _generateId();
      final String name = _nameController.text.trim();
      final String issuer = _issuerController.text.trim();
      final String secret = _secretController.text.trim().replaceAll(' ', '');
      final String icon = _iconController.text.trim(); // 获取图标链接
      
      final TotpEntry entry = TotpEntry(
        id: id,
        name: name,
        issuer: issuer,
        secret: secret,
        icon: icon, // 添加图标字段
      );
      
      final TotpProvider provider = Provider.of<TotpProvider>(context, listen: false);
      provider.addEntry(entry).then((_) {
        if (mounted) {
          Navigator.of(context).pop(true); // 返回true表示添加成功
        }
      }).catchError((error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('添加失败: $error')),
          );
        }
      });
    }
  }

  String _generateId() {
    final random = Random();
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           random.nextInt(10000).toString();
  }

  void _scanQRCode() async {
    final String? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _scanResult = result;
      });
      
      try {
        final parsed = TotpParser.parseUri(result);
        _nameController.text = parsed.name;
        _issuerController.text = parsed.issuer;
        _secretController.text = parsed.secret;
        
        setState(() {
          _isManualInput = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('二维码解析成功')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('无法解析二维码内容')),
          );
        }
      }
    }
  }

  void _checkClipboardForTotpUri() async {
    final ClipboardService clipboardService = ClipboardService();
    final String? uri = await clipboardService.checkClipboardForTotpUri();
    
    if (uri != null && mounted) {
      try {
        final parsed = TotpParser.parseUri(uri);
        _nameController.text = parsed.name;
        _issuerController.text = parsed.issuer;
        _secretController.text = parsed.secret;
        
        setState(() {
          _isManualInput = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已从剪贴板导入TOTP信息')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('剪贴板中的内容无法解析')),
          );
        }
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('剪贴板中未找到有效的TOTP URI')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加验证器'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.content_paste),
            onPressed: _checkClipboardForTotpUri,
            tooltip: '从剪贴板导入',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // 图标输入框
              TextFormField(
                controller: _iconController,
                decoration: const InputDecoration(
                  labelText: '图标',
                  hintText: '支持图床链接或base64编码图片',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 发行方输入框
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(
                  labelText: '发行方',
                  hintText: '例如：Google',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入发行方';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '账户',
                  hintText: '例如：user@example.com',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入账户名';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _secretController,
                decoration: const InputDecoration(
                  labelText: '密钥',
                  hintText: '例如：JBSWY3DPEHPK3PXP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入密钥';
                  }
                  // 简单验证Base32格式
                  if (!RegExp(r'^[A-Z2-7]+=*$').hasMatch(value.trim().toUpperCase())) {
                    return '密钥格式不正确';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('添加验证器'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}