# Contributing to LifeDelta

Thank you for your interest in contributing to LifeDelta! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites

- **Xcode 15.0+** with iOS 17.0+ SDK
- **Git** for version control
- **HealthKit enabled device** for testing
- Basic knowledge of **Swift** and **SwiftUI**

### Development Setup

1. **Fork and clone** the repository:
```bash
git clone https://github.com/yourusername/lifedelta.git
cd lifedelta
```

2. **Open in Xcode**:
```bash
open LifeDelta.xcodeproj
```

3. **Build and test** on your device or simulator

## 📋 Development Guidelines

### Code Style

- Follow **Swift API Design Guidelines**
- Use **SwiftUI** for all UI components
- Implement **Combine** for reactive programming
- Follow **MVVM** architecture pattern

### Privacy First

- **Never** store health data in cloud services
- All processing must happen **on-device**
- Use **AES-256 encryption** for cached data
- Follow **GDPR compliance** requirements

### Testing

- Add **unit tests** for new features
- Test on **multiple iOS versions** (17.0+)
- Verify **HealthKit permissions** work correctly
- Test **offline functionality**

## 🐛 Bug Reports

When reporting bugs, please include:

1. **iOS version** and device model
2. **Steps to reproduce** the issue
3. **Expected vs actual** behavior
4. **Screenshots** if applicable
5. **Console logs** if available

## ✨ Feature Requests

For new features, please:

1. Check existing **issues** first
2. Describe the **use case** and benefits
3. Consider **privacy implications**
4. Ensure **on-device processing** is possible

## 🔄 Pull Request Process

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to your branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### PR Requirements

- [ ] Code follows style guidelines
- [ ] Tests pass locally
- [ ] Privacy implications considered
- [ ] Documentation updated
- [ ] No breaking changes (unless discussed)

## 📱 Testing Checklist

Before submitting a PR, ensure:

- [ ] App builds without warnings
- [ ] All features work on iOS 17.0+
- [ ] HealthKit permissions handled gracefully
- [ ] Offline mode works correctly
- [ ] Dark mode displays properly
- [ ] Accessibility features work
- [ ] No memory leaks detected

## 🏗️ Architecture

### Key Components

- **Models**: Data structures and business logic
- **Managers**: HealthKit, ML model, subscriptions
- **Views**: SwiftUI user interface components
- **Assets**: Icons, colors, and resources

### Data Flow

```
HealthKit → HealthManager → LifeDeltaModel → Views
     ↓
Local Storage (AES-256 encrypted)
```

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [HealthKit Framework](https://developer.apple.com/documentation/healthkit)
- [Core ML Documentation](https://developer.apple.com/documentation/coreml)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## 💬 Community

- **Discussions**: Use GitHub Discussions for questions
- **Issues**: Report bugs and request features
- **Discord**: Join our community server (link coming soon)

## 📄 License

By contributing to LifeDelta, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to LifeDelta! 🎉
