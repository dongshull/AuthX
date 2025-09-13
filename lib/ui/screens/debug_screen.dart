import 'package:flutter/material.dart';
import 'package:authx/models/totp_entry.dart';
import 'package:authx/services/totp_service.dart';
import 'package:authx/services/totp_test_service.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final _secretController = TextEditingController();
  final _digitsController = TextEditingController(text: '6');
  final _periodController = TextEditingController(text: '30');
  final _algorithmController = TextEditingController(text: 'SHA1');
  
  String _totpCode = '';
  int _remainingTime = 0;
  String _error = '';
  bool _rfcTestPassed = false;

  @override
  void initState() {
    super.initState();
    // 运行RFC测试用例
    _rfcTestPassed = TotpTestService.runRfcTestCases();
  }

  @override
  void dispose() {
    _secretController.dispose();
    _digitsController.dispose();
    _periodController.dispose();
    _algorithmController.dispose();
    super.dispose();
  }

  void _generateTotp() {
    setState(() {
      _error = '';
      _totpCode = '';
      _remainingTime = 0;
    });
    
    try {
      final entry = TotpEntry(
        id: 'debug',
        name: 'Debug',
        issuer: 'Debug',
        secret: _secretController.text.trim(),
        digits: int.tryParse(_digitsController.text) ?? 6,
        period: int.tryParse(_periodController.text) ?? 30,
        algorithm: _algorithmController.text.trim(),
      );
      
      setState(() {
        _totpCode = TotpService.generateTotp(entry);
        _remainingTime = TotpService.getRemainingTime(entry);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _runRfcTests() {
    setState(() {
      _rfcTestPassed = TotpTestService.runRfcTestCases();
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _rfcTestPassed 
              ? 'RFC测试通过!' 
              : 'RFC测试失败，请检查实现',
          ),
          backgroundColor: _rfcTestPassed ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOTP 调试'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _secretController,
              decoration: const InputDecoration(
                labelText: '密钥 (Base32)',
                hintText: '例如: JBSWY3DPEHPK3PXP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _digitsController,
                    decoration: const InputDecoration(
                      labelText: '位数',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _periodController,
                    decoration: const InputDecoration(
                      labelText: '周期(秒)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _algorithmController,
              decoration: const InputDecoration(
                labelText: '算法',
                hintText: '例如: SHA1, SHA256, SHA512',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generateTotp,
                    child: const Text('生成TOTP'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _runRfcTests,
                    child: const Text('运行RFC测试'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _rfcTestPassed ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _rfcTestPassed ? Icons.check_circle : Icons.error,
                    color: _rfcTestPassed ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _rfcTestPassed 
                      ? 'RFC测试已通过' 
                      : 'RFC测试未通过',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _rfcTestPassed ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (_error.isNotEmpty) ...[
              const Text('错误:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              Text(_error),
              const SizedBox(height: 16),
            ],
            
            if (_totpCode.isNotEmpty) ...[
              const Text('生成的TOTP码:', style: TextStyle(fontWeight: FontWeight.bold)),
              Center(
                child: Text(
                  _totpCode,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              
              const Text('剩余时间:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('$_remainingTime 秒'),
              const SizedBox(height: 16),
            ],
            
            const Divider(),
            const Text('测试用例:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('密钥: JBSWY3DPEHPK3PXP'),
            const Text('预期结果: 通常以 287082 开头'),
            const SizedBox(height: 8),
            const Text('RFC测试用例:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('密钥: GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ'),
            const Text('计数器: 1'),
            const Text('SHA1预期结果: 94287082'),
            const Text('SHA256预期结果: 46119246'),
            const Text('SHA512预期结果: 90693936'),
          ],
        ),
      ),
    );
  }
}