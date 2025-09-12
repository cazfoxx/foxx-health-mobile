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
- **Image Handling**: Image Picker for profile uploads

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
├── core/                    # Core functionality
│   ├── components/          # Shared UI components
│   ├── constants/           # App constants
│   ├── network/             # API client & network utilities
│   │   ├── api_client.dart  # Dio HTTP client configuration
│   │   └── api_logger_interceptor.dart # Request/response logging
│   └── utils/               # Utility functions
├── features/                # Feature-based modules
│   ├── data/                # Data layer
│   │   └── models/          # Data models (HealthTracker, AppointmentCompanion, etc.)
│   └── presentation/        # UI layer
│       ├── cubits/          # State management with integrated API calls
│       │   ├── symptom_search/           # Centralized API operations
│       │   ├── onboarding/               # Onboarding flow management
│       │   ├── appointment_companion/    # Appointment companion logic
│       │   ├── banner/                   # Banner management
│       │   └── home_health_tracker/      # Home health tracker state
│       ├── screens/         # Screen implementations
│       │   ├── health_profile/           # Health profile & questions
│       │   ├── appointment/              # Appointment management
│       │   ├── onboarding/               # Onboarding flow
│       │   ├── profile/                  # User profile management
│       │   └── main_navigation/          # Main app navigation
│       ├── theme/           # App theming
│       └── widgets/         # Shared widgets
└── main.dart               # App entry point
```

## 🏛️ Architecture Overview

### **Refactored Architecture (Current)**

The application follows a **Cubit-Centric Architecture** where API calls are directly integrated into cubits, eliminating the traditional service layer for better cohesion and simplified data flow.

#### **Key Architectural Decisions:**

1. **Service Layer Elimination**: 
   - Removed `lib/features/data/services/` directory
   - API calls moved directly into relevant cubits
   - Reduced abstraction layers for better maintainability

2. **Centralized API Operations**:
   - `SymptomSearchCubit` serves as the primary API hub
   - Handles multiple domains: symptoms, health trackers, appointments, profile icons, AI responses
   - Single point of truth for API operations

3. **Feature-Specific Cubits**:
   - `OnboardingCubit`: Manages onboarding questions and flow
   - `AppointmentCompanionCubit`: Handles appointment companion operations
   - `BannerCubit`: Manages banner content
   - `HomeHealthTrackerCubit`: Manages home health tracker state

#### **Data Flow:**

```
UI Screen → Cubit → API Client → Backend
    ↑                                    ↓
    ←────────── State Updates ←───────────
```

#### **Benefits of New Architecture:**

- **Reduced Complexity**: Fewer abstraction layers
- **Better Cohesion**: Related functionality grouped together
- **Easier Testing**: Direct cubit testing without service mocking
- **Simplified Debugging**: Clear call stack and error handling
- **Faster Development**: Less boilerplate code

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

## 🔧 Core Features

### **API Integration**
- **Centralized API Client**: Dio-based HTTP client with interceptors
- **Authentication**: Bearer token management
- **Error Handling**: Comprehensive error handling and logging
- **Request/Response Logging**: Detailed API call monitoring

### **State Management**
- **Cubit Pattern**: Lightweight state management
- **Integrated API Calls**: Direct API integration in cubits
- **Reactive UI**: Automatic UI updates on state changes
- **Error States**: Graceful error handling and recovery

### **Health Profile System**
- **Get to Know Me API**: Dynamic health questions from backend
- **Question Categories**: Appointment Companion, Digital Twin, Symptom Insights
- **Data Usage Tags**: Visual indicators for question purposes
- **Filtering & Sorting**: Advanced question management

### **Appointment Management**
- **AI-Generated Questions**: Dynamic appointment preparation
- **Companion Creation**: Personalized appointment companions
- **Response Generation**: AI-powered question generation
- **Premium Features**: Enhanced AI responses for premium users

### **Profile Management**
- **Icon Upload**: Profile picture upload functionality
- **Image Picker**: Gallery-based image selection
- **Real-time Updates**: Immediate UI updates on profile changes

## 📊 Analytics & Monitoring

- **Firebase Analytics**: User behavior tracking
- **Crash Reporting**: Error monitoring and reporting
- **Performance Monitoring**: App performance metrics
- **API Logging**: Detailed request/response logging

## 🚀 Development Guidelines

### **Code Style**
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting

### **Architecture Patterns**
- **Cubit-Centric**: Prefer cubits over complex service layers
- **Direct API Integration**: Keep API calls close to state management
- **Feature-Based Organization**: Group related functionality together
- **Single Responsibility**: Each cubit handles one domain area

### **API Development**
- **Centralized Operations**: Use SymptomSearchCubit for multiple domains
- **Error Handling**: Implement comprehensive error states
- **Loading States**: Always provide loading indicators
- **Retry Mechanisms**: Allow users to retry failed operations

### **Testing Strategy**
- **Cubit Testing**: Test state changes and API interactions
- **Widget Testing**: Test UI components and interactions
- **Integration Testing**: Test complete user flows
- **API Mocking**: Mock API responses for testing

## 🔄 Migration Notes

### **From Service Layer Architecture**
- **Removed**: `lib/features/data/services/` directory
- **Moved**: API calls from services to cubits
- **Updated**: All import statements and method calls
- **Enhanced**: Error handling and loading states

### **Breaking Changes**
- Service classes no longer exist
- API calls now go through cubits directly
- Import statements updated throughout the codebase
- Method signatures may have changed

## 📝 API Endpoints

### **Health Profile**
- `GET /api/v1/get-to-know-me/` - Fetch health profile questions

### **Appointments**
- `POST /api/v1/appointment-companions/{id}/generate-ai-response` - Generate AI questions
- `GET /api/v1/appointment-companions/{id}` - Get companion details

### **Profile Management**
- `POST /api/v1/accounts/me/profile-icon/upload` - Upload profile icon
- `GET /api/v1/accounts/me/profile-icon` - Get profile icon

### **Health Tracking**
- `GET /api/v1/health-trackers` - Get health trackers
- `POST /api/v1/health-trackers` - Create health tracker

## 🤝 Contributing

1. Follow the new cubit-centric architecture
2. Integrate API calls directly into cubits
3. Maintain comprehensive error handling
4. Add loading states for all async operations
5. Follow the established design system
6. Write tests for new functionality

## 📄 License

This project is proprietary software. All rights reserved.











