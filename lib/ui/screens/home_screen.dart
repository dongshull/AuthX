import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authx/models/totp_entry.dart';
import 'package:authx/providers/totp_provider.dart';
import 'package:authx/services/totp_service.dart';
import 'package:authx/services/timer_service.dart';
import 'package:authx/ui/screens/about_screen.dart';
import 'package:authx/ui/screens/add_entry_screen.dart';
import 'package:authx/ui/screens/simple_import_screen.dart';
import 'package:authx/ui/screens/debug_screen.dart';
import 'package:authx/ui/screens/qr_scanner_screen.dart';
import 'package:authx/ui/widgets/expanded_fab.dart';
import 'package:authx/ui/widgets/simple_totp_card.dart';
import 'package:authx/ui/widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 启动定时器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimerService>(context, listen: false).startTimer();
    });
  }

  void _onManualAdd() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEntryScreen(),
      ),
    );
    
    // 如果添加成功，刷新列表
    if (result == true) {
      Provider.of<TotpProvider>(context, listen: false).loadEntries();
    }
  }

  void _onScanQR() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );
    
    if (result != null && mounted) {
      // TODO: 处理扫描结果
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('二维码扫描功能已实现')),
      );
    }
  }

  void _onImport() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SimpleImportScreen(),
      ),
    );
    
    // 如果导入成功，刷新列表
    if (result == true) {
      Provider.of<TotpProvider>(context, listen: false).loadEntries();
    }
  }

  void _onExport() {
    // TODO: 实现导出功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('导出功能将在后续版本中实现')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 扩展body到系统UI区域
      appBar: AppBar(
        title: const Text('AuthX TOTP'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                builder: (context) => const DebugScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<TotpProvider, TimerService>(
        builder: (context, totpProvider, timerService, child) {
          if (totpProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (totpProvider.entries.isEmpty) {
            return const EmptyStateView();
          }
          
          // 页脚跟随内容，使用ListView展示所有内容
          return RefreshIndicator(
            onRefresh: totpProvider.loadEntries,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // TOTP条目列表
                for (int index = 0; index < totpProvider.entries.length; index++)
                  SimpleTotpCard(
                    entry: totpProvider.entries[index],
                    totpCode: TotpService.generateTotp(totpProvider.entries[index]),
                    remainingTime: TotpService.getRemainingTime(totpProvider.entries[index]),
                  ),
                
                // 页脚组件
                const Footer(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: ExpandedFab(
        onManualAdd: _onManualAdd,
        onScanQR: _onScanQR,
        onImport: _onImport,
        onExport: _onExport,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无TOTP条目',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            '点击右下角"+"添加新的验证器',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddEntryScreen(),
                ),
              );
            },
            child: const Text('添加第一个验证器'),
          ),
          const SizedBox(height: 32),
          const Footer(), // 空状态时也显示页脚
        ],
      ),
    );
  }
}