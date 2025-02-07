import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sham_app/services/base_service.dart';

class OpportunityService {
  final BaseService baseService = BaseService();
  Logger logger = Logger();
  Future<String?> getMyOpportunities() async {
    http.Request request = http.Request(
        'GET', Uri.parse('${baseService.baseUrl!}/CRM/MyOpportunityInfoList'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to get opportunities ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> getOpportunity(int opportunityId) async {
    http.Request request = http.Request('GET',
        Uri.parse('${baseService.baseUrl}/CRM/Opportunity/$opportunityId'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to get opportunity ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> lostOpportunity(int opportunityId) async {
    http.Request request = http.Request(
        'POST',
        Uri.parse(
            '${baseService.baseUrl}/CRM/Opportunity/$opportunityId/Lost'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to lose lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> wonOpportunity(int opportunityId) async {
    http.Request request = http.Request('POST',
        Uri.parse('${baseService.baseUrl}/CRM/Opportunity/$opportunityId/Won'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to win lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> convertOpportunity(int opportunityId) async {
    http.Request request = http.Request(
        'POST',
        Uri.parse(
            '${baseService.baseUrl}/CRM/Opportunity/$opportunityId/ConvertToActiveLead'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to convert lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> editOpportunity(
      int opportunityId,
      String opportunityCode,
      String opportunityDescription,
      int opportunityCurrencyId,
      int? opportunitySalesSourceId,
      int? opportunitySalesCategoryId,
      int? opportunitySalesProcessId,
      int? opportunityLeadStageId,
      String opportunityName,
      String opportunityDetails) async {
    http.Request request = http.Request(
        'POST', Uri.parse('${baseService.baseUrl}/CRM/Opportunity'));
    request.headers.addAll({
      'Authorization': 'Bearer ${baseService.accessToken}',
      'Content-Type': 'application/json',
    });
    request.body =
        '''{\r\n    "Id": $opportunityId,\r\n    "Code": "$opportunityCode",\r\n    "Description": "$opportunityDescription",\r\n    "CurrencyId": $opportunityCurrencyId,\r\n    "SalesSourceId": $opportunitySalesSourceId,\r\n    "SalesCategoryId": $opportunitySalesCategoryId,\r\n    "SalesProcessId": $opportunitySalesProcessId,\r\n    "LeadStageId": $opportunityLeadStageId,\r\n    "Name": "$opportunityName",\r\n    "Details": "$opportunityDetails"\r\n}''';
    logger.d(request.body);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to edit Opportunity ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }
}
