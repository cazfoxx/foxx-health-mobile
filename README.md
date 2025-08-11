# Foxx Health Frontend

A comprehensive health and wellness mobile application built with Flutter, designed to help users track symptoms, manage appointments, and advocate for their health effectively.



## 🛠 Technical Stack

- **Framework**: Flutter (Latest Stable)
- **Authentication**: Firebase Auth
- **State Management**: Flutter Bloc/Cubit
- **Network Layer**: Dio HTTP Client
- **Analytics**: Firebase Analytics
- **Storage**: Shared Preferences & Local Storage
- **UI Components**: Custom Design System

## 📱 Installation

```bash
# Clone the repository
git clone https://github.com/foxxhealth/frontend.git

# Navigate to project directory
cd frontend

# Install dependencies
flutter pub get

# Run the application
flutter run
```

## 🏗 Project Structure

```
lib/
├── core/
│   ├── components/           # Shared UI components
│   ├── constants/           # App constants and configurations
│   ├── network/             # API client and network utilities
│   ├── services/            # Core services (analytics, etc.)
│   └── utils/               # Utility functions and helpers
├── features/
│   ├── data/
│   │   ├── models/          # Data models and DTOs
│   │   └── services/        # API services and repositories
│   └── presentation/
│       ├── cubits/          # State management (Bloc/Cubit)
│       ├── screens/
│       │   ├── splash/      # Splash screen
│       │   ├── loginScreen/ # Authentication screens
│       │   ├── onboarding/  # User onboarding flow
│       │   ├── homeScreen/  # Main home screen
│       │   ├── track_symptoms/ # Symptom tracking
│       │   ├── appointment/ # Appointment management
│       │   └── revamp/      # 🆕 NEW: Revamped UI/UX
│       │       ├── onboarding/     # Enhanced onboarding flow
│       │       ├── home_screen/    # New home screen design
│       │       ├── my_prep/        # Appointment preparation
│       │       ├── appointment/    # Comprehensive appointment flow
│       │       │   ├── view/       # Main appointment flow controller
│       │       │   └── widgets/    # Individual appointment screens
│       │       └── shared/         # Shared revamp components
│       ├── theme/
│       │   ├── app_colors.dart     # Color palette
│       │   └── app_text_styles.dart # Typography system
│       └── widgets/         # Shared presentation widgets
├── assets/
│   ├── fonts/               # Custom fonts
│   └── svg/                 # SVG assets and icons
└── main.dart               # Application entry point
```

## 🆕 Revamp Folder Structure

The `revamp` folder contains the latest UI/UX improvements and new features:

### 📁 `revamp/onboarding/`
- **Enhanced Onboarding Flow**: Multi-step user onboarding with API integration
- **Personalized Questions**: Dynamic questionnaire system
- **Account Creation**: Seamless user registration process

### 📁 `revamp/home_screen/`
- **Modern Home Interface**: Redesigned main screen with improved navigation
- **Quick Actions**: Streamlined access to key features
- **Health Dashboard**: Visual health status overview

### 📁 `revamp/my_prep/`
- **Appointment Management**: Centralized appointment preparation hub
- **Companion Tools**: AI-powered appointment companions
- **Progress Tracking**: Visual progress indicators

### 📁 `revamp/appointment/`
- **15-Screen Flow**: Comprehensive appointment preparation process
- **Data Collection**: Multi-faceted health information gathering
- **Personalized Results**: AI-generated appointment companions

#### Appointment Flow Screens:
1. **Personal Info Review** - User information verification
2. **Appointment Type** - Type of medical appointment
3. **Care Provider** - Healthcare provider selection
4. **Main Reason** - Primary reason for visit
5. **Symptom Selection** - Tracked symptoms review
6. **Life Situation** - Current life circumstances
7. **Journey Progress** - Health journey status
8. **Premium Info** - Premium features introduction
9. **Concern Prioritization** - Priority setting for concerns
10. **Symptom Changes** - Symptom progression tracking
11. **Communication Preferences** - Healthcare communication style
12. **Care Experience** - Past healthcare experiences
13. **Concerns** - Specific worries about care
14. **Data Privacy** - Privacy information and consent
15. **Appointment Companion** - Final personalized companion

### 📁 `revamp/shared/`
- **Reusable Components**: Shared UI components for revamp screens
- **Navigation Elements**: Common navigation patterns
- **Design System**: Consistent styling and theming

## 🎨 Design System

### Colors
- **Primary**: Amethyst Purple (#6B46C1)
- **Secondary**: Background Highlighted (#FFF7E6)
- **Text**: Primary (#1A1A1A), Davy's Gray (#555555)
- **Accent**: Progress Bar Selected (#FFD700)

### Typography
- **Headings**: AppHeadingTextStyles (H1-H4)
- **Body**: AppOSTextStyles (Regular, Medium, Semibold)
- **Specialized**: Link styles, button text, etc.

### Components
- **NeumorphicOptionCard**: Selectable option cards
- **FoxxBackground**: Consistent background component
- **Glass Card Decoration**: Modern glass-morphism effects



## 📊 Analytics & Monitoring

- **Firebase Analytics**: User behavior tracking
- **Crash Reporting**: Error monitoring and reporting
- **Performance Monitoring**: App performance metrics



### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting



## 🔄 Version History

### v2.0.0 (Current - Revamp)




### v1.0.0 (Legacy)
- Basic symptom tracking
- Simple appointment management
- Original onboarding flow

---

**Built with ❤️ by the Foxx Health Team**






