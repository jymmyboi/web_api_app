import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sham_app/services/base_service.dart';

class LeadService {
  final BaseService baseService = BaseService();
  Logger logger = Logger();
  Future<String?> getMyLeads() async {
    logger.d({baseService.baseUrl});
    http.Request request = http.Request(
        'GET', Uri.parse('${baseService.baseUrl!}/CRM/MyLeadInfoList'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      logger.d(responseString);
      return responseString;
    } else {
      logger.e(
          "Failure to get leads ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> getLead(int leadId) async {
    http.Request request = http.Request(
        'GET', Uri.parse('${baseService.baseUrl}/CRM/Lead/$leadId'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to get lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> deleteLead(int leadId) async {
    http.Request request = http.Request(
        'DELETE', Uri.parse('${baseService.baseUrl}/CRM/Lead/$leadId'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 204) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to delete lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> convertLead(int leadId) async {
    http.Request request = http.Request(
        'POST', Uri.parse('${baseService.baseUrl}/CRM/Lead/$leadId/Convert'));
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

  Future<String?> closeLead(int leadId) async {
    http.Request request = http.Request(
        'POST', Uri.parse('${baseService.baseUrl}/CRM/Lead/$leadId/Close'));
    request.headers
        .addAll({'Authorization': 'Bearer ${baseService.accessToken}'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to close lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }

  Future<String?> editLead(
      int leadId,
      String leadCode,
      String leadDescription,
      int leadCurrencyId,
      int? leadSalesSourceId,
      int? leadSalesCategoryId,
      int? leadSalesProcessId,
      int? leadStageId,
      String leadName,
      String leadDetails) async {
    http.Request request =
        http.Request('POST', Uri.parse('${baseService.baseUrl}/CRM/Lead'));
    request.headers.addAll({
      'Authorization': 'Bearer ${baseService.accessToken}',
      'Content-Type': 'application/json',
    });
    request.body =
        '''{\r\n    "Id": $leadId,\r\n    "Code": "$leadCode",\r\n    "Description": "$leadDescription",\r\n    "CurrencyId": $leadCurrencyId,\r\n    "SalesSourceId": $leadSalesSourceId,\r\n    "SalesCategoryId": $leadSalesCategoryId,\r\n    "SalesProcessId": $leadSalesProcessId,\r\n    "LeadStageId": $leadStageId,\r\n    "Name": "$leadName",\r\n    "Details": "$leadDetails"\r\n}''';
    logger.d(request.body);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      return responseString;
    } else {
      logger.e(
          "Failure to edit lead ${response.statusCode} | ${response.reasonPhrase}");
      return null;
    }
  }
}
