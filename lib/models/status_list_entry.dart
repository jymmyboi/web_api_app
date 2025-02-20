class StatusListEntry {
  final String code;
  final String description;
  final int openStatus;
  final bool caseFileActive;
  final bool activityActive;
  final bool jobActive;
  final bool serviceActive;
  final List<int> caseCategoryIds;
  final int id;

  StatusListEntry(
      this.code,
      this.description,
      this.openStatus,
      this.caseFileActive,
      this.activityActive,
      this.jobActive,
      this.caseCategoryIds,
      this.id,
      this.serviceActive);

  StatusListEntry.fromJson(Map<String, dynamic> json)
      : code = json['Code'] as String,
        description = json['Description'] as String,
        openStatus = json['OpenStatus'] as int,
        caseFileActive = json['CaseFileActive'] as bool,
        activityActive = json['ActivityActive'] as bool,
        jobActive = json['JobActive'] as bool,
        serviceActive = json['ServiceActive'] as bool,
        caseCategoryIds = json['CaseCategoryIds'] as List<int>,
        id = json['Id'] as int;

  Map<String, dynamic> toJson() => {
        'code': code,
        'description': description,
        'openStatus': openStatus,
        'caseFileActive': caseFileActive,
        'activityActive': activityActive,
        'jobActive': jobActive,
        'serviceActive': serviceActive,
        'caseCategoryIds': caseCategoryIds,
        'id': id
      };
}
