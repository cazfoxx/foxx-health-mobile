class UserProfileConstants {
  // User Profile Data
  static String? userName;
  static String? gender;
  static int? age;
  static double? weight;
  static double? height;
  static String? ethnicity;
  static String? address;
  
  // Additional Profile Data
  static String? householdIncomeRange;
  static List<String>? healthConcerns;
  static List<String>? healthHistory;
  static String? medicationsOrSupplementsIndicator;
  static List<String>? medicationsOrSupplements;
  static List<String>? currentStageInLife;
  static List<String>? moodEnergyCognitiveSupport;
  static List<String>? gutAndImmuneSupport;
  static List<String>? overTheCounterMedications;
  static List<String>? vitaminsAndSupplements;
  static List<String>? herbalAndAdaptogens;
  static bool? privacyPolicyAccepted;
  static bool? sixteenAndOver;
  static bool? isActive;
  static int? accountId;
  static String? userUniqueId;
  static String? createdAt;
  static String? updatedAt;

  /// Update user profile data
  static void updateProfileData({
    String? userName,
    String? gender,
    int? age,
    double? weight,
    double? height,
    String? ethnicity,
    String? address,
    String? householdIncomeRange,
    List<String>? healthConcerns,
    List<String>? healthHistory,
    String? medicationsOrSupplementsIndicator,
    List<String>? medicationsOrSupplements,
    List<String>? currentStageInLife,
    List<String>? moodEnergyCognitiveSupport,
    List<String>? gutAndImmuneSupport,
    List<String>? overTheCounterMedications,
    List<String>? vitaminsAndSupplements,
    List<String>? herbalAndAdaptogens,
    bool? privacyPolicyAccepted,
    bool? sixteenAndOver,
    bool? isActive,
    int? accountId,
    String? userUniqueId,
    String? createdAt,
    String? updatedAt,
  }) {
    if (userName != null) UserProfileConstants.userName = userName;
    if (gender != null) UserProfileConstants.gender = gender;
    if (age != null) UserProfileConstants.age = age;
    if (weight != null) UserProfileConstants.weight = weight;
    if (height != null) UserProfileConstants.height = height;
    if (ethnicity != null) UserProfileConstants.ethnicity = ethnicity;
    if (address != null) UserProfileConstants.address = address;
    if (householdIncomeRange != null) UserProfileConstants.householdIncomeRange = householdIncomeRange;
    if (healthConcerns != null) UserProfileConstants.healthConcerns = healthConcerns;
    if (healthHistory != null) UserProfileConstants.healthHistory = healthHistory;
    if (medicationsOrSupplementsIndicator != null) UserProfileConstants.medicationsOrSupplementsIndicator = medicationsOrSupplementsIndicator;
    if (medicationsOrSupplements != null) UserProfileConstants.medicationsOrSupplements = medicationsOrSupplements;
    if (currentStageInLife != null) UserProfileConstants.currentStageInLife = currentStageInLife;
    if (moodEnergyCognitiveSupport != null) UserProfileConstants.moodEnergyCognitiveSupport = moodEnergyCognitiveSupport;
    if (gutAndImmuneSupport != null) UserProfileConstants.gutAndImmuneSupport = gutAndImmuneSupport;
    if (overTheCounterMedications != null) UserProfileConstants.overTheCounterMedications = overTheCounterMedications;
    if (vitaminsAndSupplements != null) UserProfileConstants.vitaminsAndSupplements = vitaminsAndSupplements;
    if (herbalAndAdaptogens != null) UserProfileConstants.herbalAndAdaptogens = herbalAndAdaptogens;
    if (privacyPolicyAccepted != null) UserProfileConstants.privacyPolicyAccepted = privacyPolicyAccepted;
    if (sixteenAndOver != null) UserProfileConstants.sixteenAndOver = sixteenAndOver;
    if (isActive != null) UserProfileConstants.isActive = isActive;
    if (accountId != null) UserProfileConstants.accountId = accountId;
    if (userUniqueId != null) UserProfileConstants.userUniqueId = userUniqueId;
    if (createdAt != null) UserProfileConstants.createdAt = createdAt;
    if (updatedAt != null) UserProfileConstants.updatedAt = updatedAt;
  }

  /// Clear all profile data
  static void clearProfileData() {
    userName = null;
    gender = null;
    age = null;
    weight = null;
    height = null;
    ethnicity = null;
    address = null;
    householdIncomeRange = null;
    healthConcerns = null;
    healthHistory = null;
    medicationsOrSupplementsIndicator = null;
    medicationsOrSupplements = null;
    currentStageInLife = null;
    moodEnergyCognitiveSupport = null;
    gutAndImmuneSupport = null;
    overTheCounterMedications = null;
    vitaminsAndSupplements = null;
    herbalAndAdaptogens = null;
    privacyPolicyAccepted = null;
    sixteenAndOver = null;
    isActive = null;
    accountId = null;
    userUniqueId = null;
    createdAt = null;
    updatedAt = null;
  }

  /// Get user's display name
  static String getDisplayName() {
    return userName ?? 'User';
  }

  /// Get user's age as string
  static String getAgeString() {
    return age?.toString() ?? 'N/A';
  }

  /// Get user's weight as string
  static String getWeightString() {
    return weight?.toString() ?? 'N/A';
  }

  /// Get user's height as string
  static String getHeightString() {
    return height?.toString() ?? 'N/A';
  }

  /// Check if user has completed basic profile
  static bool hasBasicProfile() {
    return userName != null && 
           gender != null && 
           age != null && 
           weight != null && 
           height != null && 
           ethnicity != null && 
           address != null;
  }
}
