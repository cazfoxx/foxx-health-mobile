# 🚀 Foxx Health Developer Quick Reference

A quick reference guide for common development tasks, commands, and patterns used in the Foxx Health Flutter project.

## 🏃‍♂️ Quick Start Commands

```bash
# Setup development environment
chmod +x scripts/setup_dev_environment.sh
./scripts/setup_dev_environment.sh

# Run the app
flutter run

# Run on specific device
flutter run -d chrome    # Web
flutter run -d android   # Android
flutter run -d ios       # iOS

# Build for production
flutter build apk --release      # Android APK
flutter build appbundle --release # Android App Bundle
flutter build ios --release      # iOS
flutter build web --release      # Web
```

## 📁 Project Structure Quick Reference

```
lib/
├── core/                    # Core functionality
│   ├── components/          # Shared UI components
│   ├── constants/           # App constants & config
│   ├── network/             # API client & network
│   ├── services/            # Core services
│   └── utils/               # Utilities
├── features/                # Feature modules
│   ├── data/                # Data layer
│   └── presentation/        # UI layer
└── main.dart               # App entry point
```

## 🎯 Common Development Patterns

### Creating a New Feature

1. **Create Feature Structure**
```bash
mkdir -p lib/features/your_feature/data/models
mkdir -p lib/features/your_feature/data/services
mkdir -p lib/features/your_feature/presentation/cubits
mkdir -p lib/features/your_feature/presentation/screens
mkdir -p lib/features/your_feature/presentation/widgets
```

2. **Model Example**
```dart
// lib/features/your_feature/data/models/your_model.dart
class YourModel {
  final String id;
  final String name;
  
  YourModel({required this.id, required this.name});
  
  factory YourModel.fromJson(Map<String, dynamic> json) {
    return YourModel(
      id: json['id'],
      name: json['name'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
```

3. **Service Example**
```dart
// lib/features/your_feature/data/services/your_service.dart
class YourService {
  final ApiClient _apiClient;
  
  YourService(this._apiClient);
  
  Future<List<YourModel>> getItems() async {
    final response = await _apiClient.get('/items');
    return (response.data as List)
        .map((json) => YourModel.fromJson(json))
        .toList();
  }
}
```

4. **Cubit Example**
```dart
// lib/features/your_feature/presentation/cubits/your_cubit.dart
class YourCubit extends Cubit<YourState> {
  final YourService _service;
  
  YourCubit(this._service) : super(YourInitial());
  
  Future<void> loadItems() async {
    emit(YourLoading());
    try {
      final items = await _service.getItems();
      emit(YourLoaded(items));
    } catch (e) {
      emit(YourError(e.toString()));
    }
  }
}
```

5. **Screen Example**
```dart
// lib/features/your_feature/presentation/screens/your_screen.dart
class YourScreen extends StatelessWidget {
  const YourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => YourCubit(
        context.read<YourService>(),
      ),
      child: BlocBuilder<YourCubit, YourState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Your Feature')),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(YourState state) {
    if (state is YourLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is YourLoaded) {
      return ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(state.items[index].name));
        },
      );
    } else if (state is YourError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const SizedBox.shrink();
  }
}
```

## 🔧 Common Commands

### Flutter Commands
```bash
# Dependencies
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade dependencies
flutter pub outdated         # Check for outdated packages

# Code Quality
flutter format lib/          # Format code
flutter analyze              # Analyze code
flutter test                 # Run tests
flutter test --coverage      # Run tests with coverage

# Build & Run
flutter clean                # Clean build cache
flutter run                  # Run in debug mode
flutter run --release        # Run in release mode
flutter build apk            # Build Android APK
flutter build appbundle      # Build Android App Bundle
flutter build ios            # Build iOS
flutter build web            # Build web

# Device Management
flutter devices              # List available devices
flutter doctor               # Check Flutter installation
```

### Git Commands
```bash
# Branch Management
git checkout -b feature/new-feature    # Create feature branch
git checkout -b bugfix/issue-fix       # Create bugfix branch
git checkout main                      # Switch to main branch

# Committing
git add .                              # Stage all changes
git commit -m "feat: add new feature"  # Commit with conventional message
git push origin feature/new-feature    # Push to remote

# Pull Requests
git pull origin main                   # Update main branch
git merge main                         # Merge main into current branch
```

## 🎨 Design System Quick Reference

### Colors
```dart
// Primary colors
Colors.purple[600]           // Amethyst Purple
Colors.orange[50]            // Background Highlighted
Colors.grey[900]             // Primary Text
Colors.grey[600]             // Davy's Gray
Colors.yellow[600]           // Progress Bar Selected
```

### Typography
```dart
// Headings
AppHeadingTextStyles.h1      // Large heading
AppHeadingTextStyles.h2      // Medium heading
AppHeadingTextStyles.h3      // Small heading

// Body text
AppOSTextStyles.regular      // Regular text
AppOSTextStyles.medium       // Medium weight
AppOSTextStyles.semibold     // Semibold weight
```

### Common Widgets
```dart
// Background
FoxxBackground()             // Standard background

// Cards
NeumorphicOptionCard()       // Selectable option card
GlassCardDecoration()        // Glass morphism effect

// Buttons
ElevatedButton()             // Primary button
TextButton()                 // Secondary button
```

## 🔍 Debugging Tips

### Common Issues & Solutions

1. **Build Fails**
```bash
flutter clean
flutter pub get
flutter run
```

2. **Hot Reload Not Working**
```bash
flutter run --hot
# Or restart the app
```

3. **Dependency Conflicts**
```bash
flutter pub deps
flutter pub upgrade --major-versions
```

4. **iOS Build Issues**
```bash
cd ios
pod install
cd ..
flutter run
```

5. **Android Build Issues**
```bash
cd android
./gradlew clean
cd ..
flutter run
```

### Debugging Tools
```dart
// Print debugging
print('Debug: $variable');

// Logger (recommended)
Logger().d('Debug message');
Logger().i('Info message');
Logger().w('Warning message');
Logger().e('Error message');

// Breakpoints in VS Code/Android Studio
// Set breakpoints in your code and run in debug mode
```

## 📱 Platform-Specific Notes

### Android
- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 33 (Android 13)
- Build tools: 33.0.0

### iOS
- Minimum iOS: 12.0
- Target iOS: 16.0
- Xcode: 14.0+

### Web
- Chrome 90+
- Firefox 88+
- Safari 14+

## 🚀 Performance Tips

1. **Widget Optimization**
```dart
// Use const constructors
const MyWidget()

// Use const for static data
const List<String> items = ['item1', 'item2'];

// Avoid unnecessary rebuilds
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCubit, MyState>(
      buildWhen: (previous, current) {
        // Only rebuild when specific conditions are met
        return previous.someProperty != current.someProperty;
      },
      builder: (context, state) {
        return YourWidget();
      },
    );
  }
}
```

2. **Image Optimization**
```dart
// Use appropriate image formats
// SVG for icons and simple graphics
// WebP for photos
// PNG for transparency needed

// Lazy loading for lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Image.network(
      items[index].imageUrl,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return CircularProgressIndicator();
      },
    );
  },
)
```



