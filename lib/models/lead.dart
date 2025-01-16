class Lead {
  final String? closedOn;
  final String code;
  final String description;
  final int? customerId;
  final int? territoryId;
  final int? industryId;
  final int? campaignId;
  final int? salesCategoryId;
  final int? salesProcessId;
  final int? salesSourceId;
  final int? leadStageId;
  final int? salesRepresentativeId;
  final int currencyId;
  final String name;
  final String tradingName;
  final String telephone;
  final String mobile;
  final String email;
  final String website;
  final String physicalStreet;
  final String physicalSuburb;
  final String physicalState;
  final String physicalPostCode;
  final String physicalCountry;
  final String postalStreet;
  final String postalSuburb;
  final String postalState;
  final String postalPostCode;
  final String postalCountry;
  final int numberOfEmployees;
  final double budgetValue;
  final double foreignBudgetValue;
  final double estimatedValue;
  final double foreignEstimatedValue;
  final double? actualValue;
  final double? foreignActualValue;
  final String? estimatedCompletion;
  final String? convertedOn;
  final int? salesOwnerId;
  final int? assignedToId;
  final String details;
  final int stageType;
  final bool isAutomatic;
  final List<dynamic> documents;
  final List<dynamic> activities;
  final List<dynamic> caseFiles;
  final List<dynamic> extendedProperties;
  final String createdBy;
  final String creationDateTime;
  final String lastModifiedBy;
  final String lastModifiedDateTime;
  final int id;

  Lead(
      this.closedOn,
      this.code,
      this.description,
      this.customerId,
      this.territoryId,
      this.industryId,
      this.campaignId,
      this.salesCategoryId,
      this.salesProcessId,
      this.salesSourceId,
      this.leadStageId,
      this.salesRepresentativeId,
      this.currencyId,
      this.name,
      this.tradingName,
      this.telephone,
      this.mobile,
      this.email,
      this.website,
      this.physicalStreet,
      this.physicalSuburb,
      this.physicalState,
      this.physicalPostCode,
      this.physicalCountry,
      this.postalStreet,
      this.postalSuburb,
      this.postalState,
      this.postalPostCode,
      this.postalCountry,
      this.numberOfEmployees,
      this.budgetValue,
      this.foreignBudgetValue,
      this.estimatedValue,
      this.foreignEstimatedValue,
      this.actualValue,
      this.foreignActualValue,
      this.estimatedCompletion,
      this.convertedOn,
      this.salesOwnerId,
      this.assignedToId,
      this.details,
      this.stageType,
      this.isAutomatic,
      this.documents,
      this.activities,
      this.caseFiles,
      this.extendedProperties,
      this.createdBy,
      this.creationDateTime,
      this.lastModifiedBy,
      this.lastModifiedDateTime,
      this.id);

  Lead.fromJson(Map<String, dynamic> json)
      : closedOn = json['ClosedOn'] as String?,
        code = json['Code'] as String,
        description = json['Description'] as String,
        customerId = json['CustomerId'] as int?,
        territoryId = json['TerritoryId'] as int?,
        industryId = json['IndustryId'] as int?,
        campaignId = json['CampaignId'] as int?,
        salesCategoryId = json['SalesCategoryId'] as int?,
        salesProcessId = json['SalesProcessId'] as int?,
        salesSourceId = json['SalesSourceId'] as int?,
        leadStageId = json['LeadStageId'] as int?,
        salesRepresentativeId = json['SalesRepresentativeId'] as int?,
        currencyId = json['CurrencyId'] as int,
        name = json['Name'] as String,
        tradingName = json['TradingName'] as String,
        telephone = json['Telephone'] as String,
        mobile = json['Mobile'] as String,
        email = json['Email'] as String,
        website = json['Website'] as String,
        physicalStreet = json['PhysicalStreet'] as String,
        physicalSuburb = json['PhysicalSuburb'] as String,
        physicalState = json['PhysicalState'] as String,
        physicalPostCode = json['PhysicalPostCode'] as String,
        physicalCountry = json['PhysicalCountry'] as String,
        postalStreet = json['PostalStreet'] as String,
        postalSuburb = json['PostalSuburb'] as String,
        postalState = json['PostalState'] as String,
        postalPostCode = json['PostalPostCode'] as String,
        postalCountry = json['PostalCountry'] as String,
        numberOfEmployees = json['NumberOfEmployees'] as int,
        budgetValue = json['BudgetValue'] as double,
        foreignBudgetValue = json['ForeignBudgetValue'] as double,
        estimatedValue = json['EstimatedValue'] as double,
        foreignEstimatedValue = json['ForeignEstimatedValue'] as double,
        actualValue =
            json['ActualValue'] != null ? json['ActualValue'] as double : null,
        foreignActualValue = json['ForeignActualValue'] != null
            ? json['ForeignActualValue'] as double
            : null,
        estimatedCompletion = json['EstimatedCompletion'] as String?,
        convertedOn = json['ConvertedOn'] as String?,
        salesOwnerId = json['SalesOwnerId'] as int?,
        assignedToId = json['AssignedToId'] as int?,
        details = json['Details'] as String,
        stageType = json['StageType'] as int,
        isAutomatic = json['IsAutomatic'] as bool,
        documents = json['Documents'] as List<dynamic>,
        activities = json['Activities'] as List<dynamic>,
        caseFiles = json['CaseFiles'] as List<dynamic>,
        extendedProperties = json['ExtendedProperties'] as List<dynamic>,
        createdBy = json['CreatedBy'] as String,
        creationDateTime = json['CreationDateTime'] as String,
        lastModifiedBy = json['LastModifiedBy'] as String,
        lastModifiedDateTime = json['LastModifiedDateTime'] as String,
        id = json['Id'] as int;

  Map<String, dynamic> toJson() => {
        'closedOn': closedOn,
        'code': code,
        'description': description,
        'customerId': customerId,
        'territoryId': territoryId,
        'industryId': industryId,
        'campaignId': campaignId,
        'salesCategoryId': salesCategoryId,
        'salesProcessId': salesProcessId,
        'salesSourceId': salesSourceId,
        'leadStageId': leadStageId,
        'salesRepresentativeId': salesRepresentativeId,
        'currencyId': currencyId,
        'name': name,
        'tradingName': tradingName,
        'telephone': telephone,
        'mobile': mobile,
        'email': email,
        'website': website,
        'physicalStreet': physicalStreet,
        'physicalSuburb': physicalSuburb,
        'physicalState': physicalState,
        'physicalPostCode': physicalPostCode,
        'physicalCountry': physicalCountry,
        'postalStreet': postalStreet,
        'postalSuburb': postalSuburb,
        'postalState': postalState,
        'postalPostCode': postalPostCode,
        'postalCountry': postalCountry,
        'numberOfEmployees': numberOfEmployees,
        'budgetValue': budgetValue,
        'foreignBudgetValue': foreignBudgetValue,
        'estimatedValue': estimatedValue,
        'foreignEstimatedValue': foreignEstimatedValue,
        'actualValue': actualValue,
        'foreignActualValue': foreignActualValue,
        'estimatedCompletion': estimatedCompletion,
        'convertedOn': convertedOn,
        'salesOwnerId': salesOwnerId,
        'assignedToId': assignedToId,
        'details': details,
        'stageType': stageType,
        'isAutomatic': isAutomatic,
        'documents': documents,
        'activities': activities,
        'caseFiles': caseFiles,
        'extendedProperties': extendedProperties,
        'createdBy': createdBy,
        'creationDateTime': creationDateTime,
        'lastModifiedBy': lastModifiedBy,
        'lastModifiedDateTime': lastModifiedDateTime,
        'id': id
      };
}
