<div align="center">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS Version">
  <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Privacy-First-red.svg" alt="Privacy First">
</div>

# 🕰️ LifeDelta

> **Gain days you can see** — an on-device longevity dashboard that turns your health data into real-time life-expectancy deltas.

<div align="center">
  <img src="https://via.placeholder.com/300x200/00C851/FFFFFF?text=LifeDelta+App" alt="LifeDelta App Preview" width="300">
</div>

## ✨ What is LifeDelta?

LifeDelta is a revolutionary iOS app that transforms passive health metrics into an engaging, privacy-first longevity dashboard. By combining actuarial life tables with on-device machine learning, it displays your remaining life expectancy and quantifies the impact of daily habits in **concrete days gained or lost**.

### 🎯 Core Value Proposition

- **Instant Meaning**: A live countdown that moves when you walk, sleep, or quit vaping
- **Actionable Clarity**: Every habit shows a concrete "+ / – days" impact, not abstract scores  
- **Privacy by Default**: All modeling happens on-device; no health data leaves your phone
- **Built-in Virality**: Shareable "+73 days gained" cards drive organic growth loops

## 🚀 Features

### 🆓 Free Features
- **Life Countdown**: Real-time countdown of remaining life days with live updates
- **HealthKit Integration**: Syncs steps, resting heart rate, sleep, and VO₂ max data
- **Basic Dashboard**: LifeScore overview with weekly deltas and top risk factors
- **Weekly Digest**: Email summaries of your progress and insights

### 👑 Pro Features ($19/year)
- **Habit Simulator**: See how lifestyle changes impact life expectancy in real-time
- **AR Food Scanner**: Scan food to estimate nutritional impact on longevity
- **Advanced Analytics**: Detailed insights and trend analysis with SHAP explanations
- **Shareable Cards**: Generate viral "gains" cards with referral codes
- **Streak Insurance**: Protect your progress with gamified streak protection
- **Data Export**: Full GDPR-compliant data export and deletion

## 🛡️ Privacy & Security

<div align="center">
  <img src="https://img.shields.io/badge/Privacy-100%25_On--Device-brightgreen.svg" alt="Privacy First">
  <img src="https://img.shields.io/badge/Encryption-AES--256-blue.svg" alt="AES-256 Encryption">
  <img src="https://img.shields.io/badge/GDPR-Compliant-red.svg" alt="GDPR Compliant">
</div>

- **🔒 100% On-Device Processing**: All health data processing happens locally
- **🔐 AES-256 Encryption**: Device-key encryption for cached data
- **☁️ No Cloud Storage**: Raw health data never leaves your device
- **📋 GDPR Compliant**: Full data export and deletion capabilities
- **🛡️ No Data Sharing**: We never share your health data with third parties

## 💰 Monetization

| Plan | Price | Features |
|------|-------|----------|
| **Free** | $0 | Life countdown, basic dashboard, weekly email |
| **Pro** | $19/year | Full HealthKit sync, habit simulator, AR scanning, advanced analytics, data export |

## 🏗️ Tech Stack

<div align="center">

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Frontend** | SwiftUI + Combine | Modern iOS development |
| **ML** | Core ML + scikit-survival | On-device survival analysis |
| **Backend** | FastAPI + Supabase | Micro-coach & auth |
| **Automation** | n8n + Resend | Email digests |
| **Payments** | Stripe | Subscription management |
| **Analytics** | PostHog | User behavior tracking |

</div>

## 🚀 Getting Started

### Prerequisites

- **Xcode 15.0+** with iOS 17.0+ SDK
- **iOS 17.0+** device or simulator
- **HealthKit enabled** device for full functionality

### 📱 Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/lifedelta.git
cd lifedelta
```

2. **Open in Xcode:**
```bash
open LifeDelta.xcodeproj
```

3. **Build and run:**
   - Select your target device
   - Press `Cmd + R` to build and run

### 🔧 HealthKit Setup

The app requires HealthKit permissions for optimal functionality:

| Data Type | Purpose | Required |
|-----------|---------|----------|
| **Step Count** | Activity tracking | ✅ Yes |
| **Heart Rate** | Cardiovascular health | ✅ Yes |
| **Sleep Analysis** | Sleep quality metrics | ✅ Yes |
| **VO₂ Max** | Fitness level assessment | ✅ Yes |
| **Body Mass** | BMI calculations | ✅ Yes |
| **Height** | BMI calculations | ✅ Yes |

## 📁 Project Structure

```
LifeDelta/
├── 📱 LifeDeltaApp.swift          # Main app entry point
├── 🏠 ContentView.swift           # Root view with tab navigation
├── 📊 Models/
│   └── HealthData.swift           # Data models and structures
├── ⚙️ Managers/
│   ├── HealthManager.swift        # HealthKit integration
│   ├── LifeDeltaModel.swift       # ML model and calculations
│   └── SubscriptionManager.swift  # In-app purchases
├── 🎨 Views/
│   ├── OnboardingView.swift       # User onboarding flow
│   ├── DashboardView.swift        # Main dashboard
│   ├── HabitSimulatorView.swift   # Habit impact simulator
│   ├── ARScannerView.swift        # Food scanning interface
│   ├── ProfileView.swift          # User profile and settings
│   └── PaywallView.swift          # Subscription paywall
└── 🎨 Assets.xcassets/            # App icons and colors
```

## 🏗️ Architecture

<div align="center">
  <img src="https://via.placeholder.com/600x400/2C3E50/FFFFFF?text=LifeDelta+Architecture" alt="Architecture Diagram" width="600">
</div>

```
┌────────────┐
│ SwiftUI App│
└─────┬──────┘
      │ Core ML .mlmodel (on-device)
      │
┌─────▼──────┐           ┌─────────────┐
│ Local Cache│◄──RLS──►│ Supabase     │ (auth, anon telemetry)
└────────────┘           └─────────────┘
      │                         ▲
      │ POST /micro-coach        │ Webhook
      ▼                         │
┌────────────┐                 │
│ FastAPI    │──► GPT-4o ◄─────┘
│ (Fly.io)   │
└────────────┘
```

## 🗺️ Development Roadmap

### ✅ Phase 1: Foundation (Weeks 1-2)
- [x] Project setup and basic structure
- [x] HealthKit integration
- [x] Core ML model integration
- [x] Basic UI components
- [x] Onboarding flow

### 🚧 Phase 2: Core Features (Weeks 3-4)
- [x] Habit simulator with real-time updates
- [x] AR food scanning implementation
- [x] Shareable OG-card generation
- [x] Stripe paywall integration
- [ ] Advanced analytics dashboard

### 📧 Phase 3: Automation (Weeks 5-6)
- [ ] Weekly digest email system (n8n + Resend)
- [ ] Beta testing with TestFlight (100 users)
- [ ] PostHog analytics integration
- [ ] Performance optimization

### 🚀 Phase 4: Launch (Weeks 7-8)
- [ ] App Store submission
- [ ] Product Hunt launch
- [ ] Social media marketing
- [ ] User feedback integration

## 📊 Success Metrics

| Metric | Target | Current |
|--------|--------|---------|
| **Activation Rate** | ≥70% | TBD |
| **WAU/MAU** | ≥50% | TBD |
| **Free→Pro Conversion** | ≥3% | TBD |
| **K-factor (Referrals)** | ≥0.25 | TBD |
| **Model MAE** | ≤7 years | TBD |

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add some amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Swift style guidelines
- Add tests for new features
- Update documentation as needed
- Ensure privacy-first principles

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

<div align="center">

| Channel | Contact |
|---------|---------|
| 📧 **Email** | support@lifedelta.app |
| 🌐 **Website** | https://lifedelta.app |
| ❓ **Help Center** | https://lifedelta.app/help |
| 🐛 **Bug Reports** | [GitHub Issues](https://github.com/yourusername/lifedelta/issues) |

</div>

## 🙏 Acknowledgments

- **HealthKit** framework for health data integration
- **Core ML** for on-device machine learning
- **SwiftUI** for modern iOS development
- **The longevity research community** for data and insights
- **EZ MONEY** for the vision and execution

---

<div align="center">
  <strong>Made with ❤️ by the EZ MONEY team</strong>
  <br>
  <em>Gain days you can see</em>
</div>
