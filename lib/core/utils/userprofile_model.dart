// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserModel userProfileFromJson(String str) => UserModel.fromJson(json.decode(str));

String userProfileToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String? userName;
    String? gender;
    int? age;
    int? weight;
    int? height;
    String? ethnicity;
    String? address;
    String? householdIncomeRange;
    List<String>? healthConcerns;
    List<String>? healthHistory;
    String? medicationsOrSupplementsIndicator;
    List<String>? medicationsOrSupplements;
    List<String>? currentStageInLife;
    List<String>? moodEnergyCognativeSupport;
    List<String>? gutAndImmuneSupport;
    List<String>? overTheCounterMedications;
    List<String>? vitaminsAndSupplements;
    List<String>? herbalAndAdaptogens;
    bool? privacyPolicyAccepted;
    bool? sixteenAndOver;
    bool? isActive;
    List<String>? denPrivacy;
    String? profileIconUrl;
    String? role;
    int? accountId;
    String? userUniqueId;
    DateTime? createdAt;
    DateTime? updatedAt;

    UserModel({
        this.userName,
        this.gender,
        this.age,
        this.weight,
        this.height,
        this.ethnicity,
        this.address,
        this.householdIncomeRange,
        this.healthConcerns,
        this.healthHistory,
        this.medicationsOrSupplementsIndicator,
        this.medicationsOrSupplements,
        this.currentStageInLife,
        this.moodEnergyCognativeSupport,
        this.gutAndImmuneSupport,
        this.overTheCounterMedications,
        this.vitaminsAndSupplements,
        this.herbalAndAdaptogens,
        this.privacyPolicyAccepted,
        this.sixteenAndOver,
        this.isActive,
        this.denPrivacy,
        this.profileIconUrl,
        this.role,
        this.accountId,
        this.userUniqueId,
        this.createdAt,
        this.updatedAt,
    });

    UserModel copyWith({
        String? userName,
        String? gender,
        int? age,
        int? weight,
        int? height,
        String? ethnicity,
        String? address,
        String? householdIncomeRange,
        List<String>? healthConcerns,
        List<String>? healthHistory,
        String? medicationsOrSupplementsIndicator,
        List<String>? medicationsOrSupplements,
        List<String>? currentStageInLife,
        List<String>? moodEnergyCognativeSupport,
        List<String>? gutAndImmuneSupport,
        List<String>? overTheCounterMedications,
        List<String>? vitaminsAndSupplements,
        List<String>? herbalAndAdaptogens,
        bool? privacyPolicyAccepted,
        bool? sixteenAndOver,
        bool? isActive,
        List<String>? denPrivacy,
        String? profileIconUrl,
        String? role,
        int? accountId,
        String? userUniqueId,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        UserModel(
            userName: userName ?? this.userName,
            gender: gender ?? this.gender,
            age: age ?? this.age,
            weight: weight ?? this.weight,
            height: height ?? this.height,
            ethnicity: ethnicity ?? this.ethnicity,
            address: address ?? this.address,
            householdIncomeRange: householdIncomeRange ?? this.householdIncomeRange,
            healthConcerns: healthConcerns ?? this.healthConcerns,
            healthHistory: healthHistory ?? this.healthHistory,
            medicationsOrSupplementsIndicator: medicationsOrSupplementsIndicator ?? this.medicationsOrSupplementsIndicator,
            medicationsOrSupplements: medicationsOrSupplements ?? this.medicationsOrSupplements,
            currentStageInLife: currentStageInLife ?? this.currentStageInLife,
            moodEnergyCognativeSupport: moodEnergyCognativeSupport ?? this.moodEnergyCognativeSupport,
            gutAndImmuneSupport: gutAndImmuneSupport ?? this.gutAndImmuneSupport,
            overTheCounterMedications: overTheCounterMedications ?? this.overTheCounterMedications,
            vitaminsAndSupplements: vitaminsAndSupplements ?? this.vitaminsAndSupplements,
            herbalAndAdaptogens: herbalAndAdaptogens ?? this.herbalAndAdaptogens,
            privacyPolicyAccepted: privacyPolicyAccepted ?? this.privacyPolicyAccepted,
            sixteenAndOver: sixteenAndOver ?? this.sixteenAndOver,
            isActive: isActive ?? this.isActive,
            denPrivacy: denPrivacy ?? this.denPrivacy,
            profileIconUrl: profileIconUrl ?? this.profileIconUrl,
            role: role ?? this.role,
            accountId: accountId ?? this.accountId,
            userUniqueId: userUniqueId ?? this.userUniqueId,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userName: json["user_name"],
        gender: json["gender"],
        age: json["age"],
        weight: json["weight"],
        height: json["height"],
        ethnicity: json["ethnicity"],
        address: json["address"],
        householdIncomeRange: json["household_income_range"],
        healthConcerns: json["health_concerns"] == null ? [] : List<String>.from(json["health_concerns"]!.map((x) => x)),
        healthHistory: json["health_history"] == null ? [] : List<String>.from(json["health_history"]!.map((x) => x)),
        medicationsOrSupplementsIndicator: json["medications_or_supplements_indicator"],
        medicationsOrSupplements: json["medications_or_supplements"] == null ? [] : List<String>.from(json["medications_or_supplements"]!.map((x) => x)),
        currentStageInLife: json["current_stage_in_life"] == null ? [] : List<String>.from(json["current_stage_in_life"]!.map((x) => x)),
        moodEnergyCognativeSupport: json["mood_energy_cognative_support"] == null ? [] : List<String>.from(json["mood_energy_cognative_support"]!.map((x) => x)),
        gutAndImmuneSupport: json["gut_and_immune_support"] == null ? [] : List<String>.from(json["gut_and_immune_support"]!.map((x) => x)),
        overTheCounterMedications: json["over_the_counter_medications"] == null ? [] : List<String>.from(json["over_the_counter_medications"]!.map((x) => x)),
        vitaminsAndSupplements: json["vitamins_and_supplements"] == null ? [] : List<String>.from(json["vitamins_and_supplements"]!.map((x) => x)),
        herbalAndAdaptogens: json["herbal_and_adaptogens"] == null ? [] : List<String>.from(json["herbal_and_adaptogens"]!.map((x) => x)),
        privacyPolicyAccepted: json["privacy_policy_accepted"],
        sixteenAndOver: json["sixteen_and_over"],
        isActive: json["is_active"],
        denPrivacy: json["den_privacy"] == null ? [] : List<String>.from(json["den_privacy"]!.map((x) => x)),
        profileIconUrl: json["profile_icon_url"],
        role: json["role"],
        accountId: json["account_id"],
        userUniqueId: json["user_unique_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "user_name": userName,
        "gender": gender,
        "age": age,
        "weight": weight,
        "height": height,
        "ethnicity": ethnicity,
        "address": address,
        "household_income_range": householdIncomeRange,
        "health_concerns": healthConcerns == null ? [] : List<dynamic>.from(healthConcerns!.map((x) => x)),
        "health_history": healthHistory == null ? [] : List<dynamic>.from(healthHistory!.map((x) => x)),
        "medications_or_supplements_indicator": medicationsOrSupplementsIndicator,
        "medications_or_supplements": medicationsOrSupplements == null ? [] : List<dynamic>.from(medicationsOrSupplements!.map((x) => x)),
        "current_stage_in_life": currentStageInLife == null ? [] : List<dynamic>.from(currentStageInLife!.map((x) => x)),
        "mood_energy_cognative_support": moodEnergyCognativeSupport == null ? [] : List<dynamic>.from(moodEnergyCognativeSupport!.map((x) => x)),
        "gut_and_immune_support": gutAndImmuneSupport == null ? [] : List<dynamic>.from(gutAndImmuneSupport!.map((x) => x)),
        "over_the_counter_medications": overTheCounterMedications == null ? [] : List<dynamic>.from(overTheCounterMedications!.map((x) => x)),
        "vitamins_and_supplements": vitaminsAndSupplements == null ? [] : List<dynamic>.from(vitaminsAndSupplements!.map((x) => x)),
        "herbal_and_adaptogens": herbalAndAdaptogens == null ? [] : List<dynamic>.from(herbalAndAdaptogens!.map((x) => x)),
        "privacy_policy_accepted": privacyPolicyAccepted,
        "sixteen_and_over": sixteenAndOver,
        "is_active": isActive,
        "den_privacy": denPrivacy == null ? [] : List<dynamic>.from(denPrivacy!.map((x) => x)),
        "profile_icon_url": profileIconUrl,
        "role": role,
        "account_id": accountId,
        "user_unique_id": userUniqueId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
