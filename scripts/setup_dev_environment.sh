#!/bin/bash

# Foxx Health Development Environment Setup Script
# This script helps new developers set up their development environment

set -e

echo "🚀 Setting up Foxx Health Development Environment..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
check_flutter() {
    print_status "Checking Flutter installation..."
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        print_success "Flutter is installed: $FLUTTER_VERSION"
    else
        print_error "Flutter is not installed. Please install Flutter first:"
        echo "Visit: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
}

# Check if Dart is installed
check_dart() {
    print_status "Checking Dart installation..."
    if command -v dart &> /dev/null; then
        DART_VERSION=$(dart --version | head -n 1)
        print_success "Dart is installed: $DART_VERSION"
    else
        print_error "Dart is not installed. Please install Dart first."
        exit 1
    fi
}

# Check if Git is installed
check_git() {
    print_status "Checking Git installation..."
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        print_success "Git is installed: $GIT_VERSION"
    else
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
}

# Install Flutter dependencies
install_dependencies() {
    print_status "Installing Flutter dependencies..."
    flutter pub get
    print_success "Dependencies installed successfully"
}

# Check for Firebase configuration files
check_firebase_config() {
    print_status "Checking Firebase configuration..."
    
    if [ -f "android/app/google-services.json" ]; then
        print_success "Android Firebase config found"
    else
        print_warning "Android Firebase config not found"
        echo "Please download google-services.json from Firebase Console and place it in android/app/"
    fi
    
    if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
        print_success "iOS Firebase config found"
    else
        print_warning "iOS Firebase config not found"
        echo "Please download GoogleService-Info.plist from Firebase Console and place it in ios/Runner/"
    fi
}

# Run Flutter doctor
run_flutter_doctor() {
    print_status "Running Flutter doctor..."
    flutter doctor
}

# Check for environment files
check_env_files() {
    print_status "Checking environment files..."
    
    if [ -f ".env" ]; then
        print_success ".env file found"
    else
        if [ -f ".env.example" ]; then
            print_warning ".env file not found, but .env.example exists"
            echo "Please copy .env.example to .env and configure your environment variables"
        else
            print_warning "No environment files found"
        fi
    fi
}

# Setup Git hooks (if needed)
setup_git_hooks() {
    print_status "Setting up Git hooks..."
    
    # Create .git/hooks directory if it doesn't exist
    mkdir -p .git/hooks
    
    # Create pre-commit hook for code formatting
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running pre-commit checks..."
flutter format lib/
flutter analyze
EOF
    
    chmod +x .git/hooks/pre-commit
    print_success "Git hooks configured"
}

# Create useful aliases
create_aliases() {
    print_status "Creating useful development aliases..."
    
    # Add aliases to .bashrc or .zshrc
    SHELL_RC=""
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    fi
    
    if [ -n "$SHELL_RC" ]; then
        # Check if aliases already exist
        if ! grep -q "foxxhealth" "$SHELL_RC"; then
            cat >> "$SHELL_RC" << 'EOF'

# Foxx Health Development Aliases
alias foxx-run='flutter run'
alias foxx-test='flutter test'
alias foxx-build='flutter build'
alias foxx-clean='flutter clean && flutter pub get'
alias foxx-format='flutter format lib/'
alias foxx-analyze='flutter analyze'
alias foxx-doctor='flutter doctor'
EOF
            print_success "Development aliases added to $SHELL_RC"
            print_warning "Please restart your terminal or run 'source $SHELL_RC' to use the aliases"
        else
            print_success "Development aliases already exist"
        fi
    else
        print_warning "Could not find .bashrc or .zshrc to add aliases"
    fi
}

# Main setup function
main() {
    echo "Starting setup process..."
    echo ""
    
    # Check prerequisites
    check_flutter
    check_dart
    check_git
    
    echo ""
    
    # Install dependencies
    install_dependencies
    
    echo ""
    
    # Check configurations
    check_firebase_config
    check_env_files
    
    echo ""
    
    # Setup development tools
    setup_git_hooks
    create_aliases
    
    echo ""
    
    # Run Flutter doctor
    run_flutter_doctor
    
    echo ""
    echo "=================================================="
    print_success "Setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Configure Firebase (if not already done)"
    echo "2. Set up your environment variables"
    echo "3. Run 'flutter run' to start the app"
    echo "4. Check the ONBOARDING.md file for detailed information"
    echo ""
    echo "Useful commands:"
    echo "- foxx-run: Start the app"
    echo "- foxx-test: Run tests"
    echo "- foxx-format: Format code"
    echo "- foxx-analyze: Analyze code"
    echo ""
    print_success "Welcome to Foxx Health! 🚀"
}

# Run the setup
main "$@"
