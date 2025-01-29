class ActivityListEntry {
  final String activityNumber;
  final String subject;
  final String userName;
  final String category;
  final String status;
  final String priority;
  final int prioritySortOrder;
  final int activityType;
  final String activityTypeName;
  final String party;
  final String partyType;
  final String? startedOn;
  final String createdBy;
  final String createdOn;
  final String lastModifiedBy;
  final String lastModifiedOn;
  final int id;

  ActivityListEntry(
      this.activityNumber,
      this.subject,
      this.userName,
      this.category,
      this.status,
      this.priority,
      this.prioritySortOrder,
      this.activityType,
      this.activityTypeName,
      this.party,
      this.partyType,
      this.startedOn,
      this.createdBy,
      this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.id);

  ActivityListEntry.fromJson(Map<String, dynamic> json)
      : activityNumber = json['ActivityNumber'] as String,
        subject = json['Subject'] as String,
        userName = json['UserName'] as String,
        category = json['Category'] as String,
        status = json['Status'] as String,
        priority = json['Priority'] as String,
        prioritySortOrder = json['PrioritySortOrder'] as int,
        activityType = json['ActivityType'] as int,
        activityTypeName = json['ActivityTypeName'] as String,
        party = json['Party'] as String,
        partyType = json['PartyType'] as String,
        startedOn = json['StartedOn'] as String?,
        createdBy = json['CreatedBy'] as String,
        createdOn = json['CreatedOn'] as String,
        lastModifiedBy = json['LastModifiedBy'] as String,
        lastModifiedOn = json['LastModifiedOn'] as String,
        id = json['Id'] as int;

  Map<String, dynamic> toJson() => {
        'activityNumber': activityNumber,
        'subject': subject,
        'userName': userName,
        'category': category,
        'status': status,
        'priority': priority,
        'prioritySortOrder': prioritySortOrder,
        'activityType': activityType,
        'activityTypeName': activityTypeName,
        'party': party,
        'partyType': partyType,
        'startedOn': startedOn,
        'createdBy': createdBy,
        'createdOn': createdOn,
        'lastModifiedBy': lastModifiedBy,
        'lastModifiedOn': lastModifiedOn,
        'id': id
      };
}
