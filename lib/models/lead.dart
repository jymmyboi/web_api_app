class Lead {
  final String code;
  final String description;
  final String name;
  final String createdOn;
  final double probability;
  final double foreignEstimatedValue;
  final String campaign;
  final String opportunityStage;
  final String salesSource;
  final String salesProcess;
  final String salesCategory;
  final String customer;
  final String currency;
  final String salesRepresentative;
  final String industry;
  final String territory;
  final List<dynamic> extendedProperties;
  final int id;

  Lead(
      this.code,
      this.description,
      this.name,
      this.createdOn,
      this.probability,
      this.foreignEstimatedValue,
      this.campaign,
      this.opportunityStage,
      this.salesSource,
      this.salesProcess,
      this.salesCategory,
      this.customer,
      this.currency,
      this.salesRepresentative,
      this.industry,
      this.territory,
      this.extendedProperties,
      this.id);

  Lead.fromJson(Map<String, dynamic> json)
      : code = json['Code'] as String,
        description = json['Description'] as String,
        name = json['Name'] as String,
        createdOn = json['CreatedOn'] as String,
        probability = json['Probability'] as double,
        foreignEstimatedValue = json['ForeignEstimatedValue'] as double,
        campaign = json['Campaign'] as String,
        opportunityStage = json['OpportunityStage'] as String,
        salesSource = json['SalesSource'] as String,
        salesProcess = json['SalesProcess'] as String,
        salesCategory = json['SalesCategory'] as String,
        customer = json['Customer'] as String,
        currency = json['Currency'] as String,
        salesRepresentative = json['SalesRepresentative'] as String,
        industry = json['Industry'] as String,
        territory = json['Territory'] as String,
        extendedProperties = json['ExtendedProperties'] as List<dynamic>,
        id = json['Id'] as int;

  Map<String, dynamic> toJson() => {
        'code': code,
        'description': description,
        'name': name,
        'createdOn': createdOn,
        'probability': probability,
        'foreignEstimatedValue': foreignEstimatedValue,
        'campaign': campaign,
        'opportunityStage': opportunityStage,
        'salesSource': salesSource,
        'salesProcess': salesProcess,
        'salesCategory': salesCategory,
        'customer': customer,
        'currency': currency,
        'salesRepresentative': salesRepresentative,
        'industry': industry,
        'territory': territory,
        'extendedProperties': extendedProperties,
        'id': id
      };
}
