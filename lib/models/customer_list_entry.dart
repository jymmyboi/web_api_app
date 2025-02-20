class CustomerListEntry {
  final String code;
  final String name;
  final String telephone1;
  final String telephone2;
  final bool isActive;
  final String physicalSuburb;
  final String physicalState;
  final String physicalPostCode;
  final String physicalCountry;
  final int id;

  CustomerListEntry(
      this.code,
      this.name,
      this.telephone1,
      this.telephone2,
      this.isActive,
      this.physicalSuburb,
      this.physicalState,
      this.physicalPostCode,
      this.physicalCountry,
      this.id);

  CustomerListEntry.fromJson(Map<String, dynamic> json)
      : code = json['Code'] as String,
        name = json['Name'] as String,
        telephone1 = json['Telephone1'] as String,
        telephone2 = json['Telephone2'] as String,
        isActive = json['IsActive'] as bool,
        physicalSuburb = json['PhysicalSuburb'] as String,
        physicalState = json['PhysicalState'] as String,
        physicalPostCode = json['PhysicalPostCode'] as String,
        physicalCountry = json['PhysicalCountry'] as String,
        id = json['Id'] as int;

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'telephone1': telephone1,
        'telephone2': telephone2,
        'isActive': isActive,
        'physicalSuburb': physicalSuburb,
        'physicalState': physicalState,
        'physicalPostCode': physicalPostCode,
        'physicalCountry': physicalCountry,
        'id': id
      };
}
