import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:authx/ui/screens/add_entry_screen.dart';
import 'package:authx/ui/screens/simple_import_screen.dart';

class ExpandedFab extends StatefulWidget {
  final VoidCallback onManualAdd;
  final VoidCallback onScanQR;
  final VoidCallback onImport;
  final VoidCallback onExport;

  const ExpandedFab({
    super.key,
    required this.onManualAdd,
    required this.onScanQR,
    required this.onImport,
    required this.onExport,
  });

  @override
  State<ExpandedFab> createState() => _ExpandedFabState();
}

class _ExpandedFabState extends State<ExpandedFab> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Widget _buildSubButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: const Color(0xFF2C2C2E), // iOS 18深色模式背景色
          foregroundColor: Colors.white, // iOS 18深色模式前景色
          onPressed: onTap,
          child: Icon(icon),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Stack(
      children: [
        // 遮罩层
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleExpanded,
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withOpacity(0.45 * _fadeAnimation.value),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10.0 * _fadeAnimation.value,
                      sigmaY: 10.0 * _fadeAnimation.value,
                    ),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                );
              },
            ),
          ),
        
        // 主按钮和子按钮
        Positioned(
          right: 16,
          bottom: 16 + bottomPadding, // 添加底部安全区域偏移
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 子按钮们（仅在展开时显示）
              if (_isExpanded)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeOutBack,
                    )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildSubButton(
                          icon: Icons.upload_outlined,
                          label: '导出',
                          onTap: () {
                            _toggleExpanded();
                            widget.onExport();
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        _buildSubButton(
                          icon: Icons.download_outlined,
                          label: '导入',
                          onTap: () {
                            _toggleExpanded();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SimpleImportScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        _buildSubButton(
                          icon: Icons.qr_code_scanner,
                          label: '扫描二维码',
                          onTap: () {
                            _toggleExpanded();
                            widget.onScanQR();
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        _buildSubButton(
                          icon: Icons.edit_outlined,
                          label: '手动添加',
                          onTap: () {
                            _toggleExpanded();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AddEntryScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              
              // 主按钮（始终显示）
              FloatingActionButton(
                backgroundColor: const Color(0xFF2C2C2E), // iOS 18深色模式背景色
                foregroundColor: Colors.white, // iOS 18深色模式前景色
                onPressed: _toggleExpanded,
                child: AnimatedRotation(
                  turns: _isExpanded ? 0.125 : 0.0, // 45度旋转
                  duration: const Duration(milliseconds: 200),
                  child: Icon(_isExpanded ? Icons.close : Icons.add),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}