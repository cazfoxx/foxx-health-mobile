enum HealthAssessmentScreen {
  /// Initial screen where user starts the health assessment
  initial,

  income,

  location,

  /// Privacy and security information screen
  privacyAndSecurity,

  /// Physical information input screen (height, weight, age)
  physicalInfo,

  /// Ethnicity selection screen
  ethnicity,

  /// Appointment type selection screen
  appointmentType,

  /// Pre-existing conditions input screen
  preExistingConditions,

  /// Health concerns input screen
  healthConcerns,

  /// Health goals input screen
  healthGoals,

  /// Area of concern selection screen
  areaOfConcern,

  /// Symptom tracker screen
  symptomTracker,

  /// Prescription and supplements screen
  prescriptionAndSupplements,

  /// Prepping assessment screen (loading)
  preppingAssessment,
}