# AuthX TOTP - 安全身份验证器

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%5E3.8.1-blue?logo=flutter" alt="Flutter Version">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue" alt="Platform">
</p>

<p align="center">
  <img src="https://github.com/flutter/flutter/blob/master/dev/docs/assets/images/flutter-logo.png?raw=true" width="200">
</p>

AuthX TOTP 是一个基于 Flutter 开发的双因素认证（2FA）应用程序，支持基于时间的一次性密码（TOTP）标准，帮助您安全地保护您的在线账户。

## 🌟 功能特性

### 🔐 核心功能
- **TOTP 认证**：基于 RFC 6238 标准实现的时间一次性密码
- **多算法支持**：支持 SHA1、SHA256、SHA512 算法
- **自定义配置**：支持自定义位数（6位或8位）和周期
- **安全存储**：使用 flutter_secure_storage 安全存储密钥

### 📱 用户界面
- **现代化设计**：采用 Material Design 和 iOS 18 深色模式风格
- **流畅动画**：精心设计的交互动画效果
- **全屏适配**：完美适配各种屏幕尺寸，包括 iPhone 的圆角屏幕
- **边缘到边缘显示**：充分利用设备屏幕空间

### 🛠️ 多种添加方式
- **手动输入**：手动添加账户信息和密钥
- **二维码扫描**：通过扫描 QR 码快速添加账户
- **剪贴板导入**：自动检测剪贴板中的 TOTP URI
- **URI 导入**：支持直接粘贴 otpauth:// URI 格式

### 🎨 视觉特色
- **毛玻璃效果**：深色毛玻璃背景搭配渐变遮罩
- **霓虹蓝主题**：独特的霓虹蓝主题色彩
- **Neumorphic 设计**：凹嵌样式输入框设计
- **动态图标**：支持自定义账户图标（网络图片或 base64）

## 📋 技术栈

- **Flutter**：^3.8.1
- **Dart**：^3.8.1
- **状态管理**：Provider
- **安全存储**：flutter_secure_storage
- **二维码扫描**：qr_code_scanner
- **加密库**：crypto
- **UI 框架**：Material Design

## 🚀 安装与运行

### 环境要求
- Flutter SDK ^3.8.1
- Android Studio 或 Xcode
- Android 或 iOS 设备/模拟器

### 安装步骤

```bash
# 克隆项目
git clone https://github.com/dongshull/AuthX.git
cd AuthX

# 获取依赖
flutter pub get

# 运行应用
flutter run
```

### 构建应用

```bash
# Android APK
flutter build apk

# iOS IPA
flutter build ios

# Web
flutter build web
```

## 📖 使用指南

### 添加验证器

1. **手动添加**：
   - 点击右下角 "+" 按钮
   - 选择"手动添加"
   - 输入发行方、账户名和密钥

2. **二维码扫描**：
   - 点击右下角 "+" 按钮
   - 选择"扫描二维码"
   - 对准 QR 码进行扫描

3. **剪贴板导入**：
   - 复制 otpauth:// URI 到剪贴板
   - 应用会自动检测并提示导入

4. **URI 导入**：
   - 点击右下角 "+" 按钮
   - 选择"导入"
   - 粘贴完整的 TOTP URI

### 支持的 URI 格式

```
otpauth://totp/Google:example@gmail.com?secret=JBSWY3DPEHPK3PXP&issuer=Google
```

支持的参数：
- `secret`：必需，Base32 编码的密钥
- `issuer`：发行方
- `digits`：验证码位数（6 或 8）
- `algorithm`：算法（SHA1、SHA256、SHA512）
- `period`：周期（默认 30 秒）
- `icon`：图标 URL 或 base64 数据

## 🧪 测试

项目包含完整的测试套件，验证 TOTP 算法的正确性：

```bash
flutter test
```

## 📱 界面预览

### 主界面
<p align="center">
  <img src="https://raw.githubusercontent.com/flutter/website/master/src/assets/images/docs/get-started/flutter-ui-layout.png" width="300">
</p>

### 添加验证器
<p align="center">
  <img src="https://raw.githubusercontent.com/flutter/website/master/src/assets/images/docs/get-started/flutter-ui-layout.png" width="300">
</p>

### 导入界面
<p align="center">
  <img src="https://raw.githubusercontent.com/flutter/website/master/src/assets/images/docs/get-started/flutter-ui-layout.png" width="300">
</p>

## 🔒 安全性

- **密钥安全存储**：使用 flutter_secure_storage 在设备安全存储中保存密钥
- **本地处理**：所有计算均在本地完成，密钥不会上传到任何服务器
- **加密传输**：建议通过 HTTPS 传输 TOTP URI
- **权限控制**：仅申请必要的设备权限（相机用于二维码扫描）

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进项目：

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。

## 👥 作者

AuthX TOTP 由 [dongshull](https://github.com/dongshull) 开发和维护。

## 🙏 致谢

- 感谢 [Flutter](https://flutter.dev/) 团队提供的优秀框架
- 感谢所有开源库的贡献者
- 感谢所有测试和反馈的用户

## 🔗 相关链接

- [Flutter 官方文档](https://flutter.dev/docs)
- [RFC 6238 TOTP 标准](https://tools.ietf.org/html/rfc6238)
- [Google Authenticator](https://github.com/google/google-authenticator)