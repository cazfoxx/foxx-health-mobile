# Symptom API Integration

This document describes the integration of the symptom search functionality with the FastAPI backend.

## Overview

The symptom search screen now fetches data from two API endpoints:
1. `/api/v1/symptom/` - Get all symptoms with pagination
2. `/api/v1/symptom/filter-group/{filter_group}` - Get symptoms filtered by category

## Files Created/Modified

### New Files
- `lib/features/data/services/symptom_service.dart` - API service for symptom data
- `lib/features/presentation/cubits/symptom_search/symptom_search_cubit.dart` - State management
- `lib/features/presentation/cubits/symptom_search/symptom_search_state.dart` - State definitions

### Modified Files
- `lib/features/presentation/screens/revamp/health_tracker/symptom_search_screen.dart` - Updated to use API data

## API Endpoints

### Get All Symptoms
```
GET /api/v1/symptom/?skip=0&limit=100
Authorization: Bearer <token>
```

Response format:
```json
[
  {
    "id": "SYMPTOM_ID",
    "info": {
      "id": "SYMPTOM_ID",
      "name": "Symptom Name",
      "filter_grouping": ["Period", "Behavioral Changes"],
      "body_parts": ["Pelvis", "Abdomen"],
      "tags": ["Sharp", "Severe"],
      "visual_insights": ["dot", "bar_graph"],
      "question_map": [
        {
          "question_id": "SEVERITY",
          "question_text": "Severity",
          "question_type": "multiple_choice",
          "question_options": [
            {
              "id": "0",
              "text": "0"
            }
          ],
          "is_starting_question": true,
          "question_description": null
        }
      ],
      "notes": "",
      "need_help_popup": false
    },
    "need_help_popup": false,
    "notes": ""
  }
]
```

### Get Symptoms by Filter Group
```
GET /api/v1/symptom/filter-group/{filter_group}?filter_group=Period&skip=0&limit=100
Authorization: Bearer <token>
```

Response format is the same as the "Get All Symptoms" endpoint.

Available filter groups:
- All (shows all symptoms without filtering)
- Period
- Behavioral Changes
- Body Image

## Features

### Pagination
- Loads 10 symptoms per page initially
- Infinite scroll to load more symptoms
- Automatic loading when user scrolls near bottom

### Search Functionality
- Real-time search through loaded symptoms
- Case-insensitive search
- Updates results as user types

### Filtering
- Default view shows all symptoms without any filter selected
- Filter by symptom categories (Period, Behavioral Changes, Body Image)
- "All" option clears filters and shows all symptoms
- Maintains pagination state for each filter

### State Management
- Uses Flutter Bloc/Cubit for state management
- Handles loading, error, and success states
- Provides retry functionality on errors

## Usage

```dart
// Navigate to symptom search screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SymptomSearchScreen(
      onSymptomsSelected: (selectedSymptoms) {
        // Handle selected symptoms
        print('Selected symptoms: $selectedSymptoms');
      },
    ),
  ),
);
```

## Error Handling

- Network errors are displayed with retry button
- Loading states show progress indicators
- Empty states show appropriate messages
- API errors are logged and displayed to user

## Authentication

The API calls use the existing authentication system:
- Token is automatically added via `AuthInterceptor`
- 401 errors trigger logout and redirect to login
- Token refresh is handled by the existing auth system
