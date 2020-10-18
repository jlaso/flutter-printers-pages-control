import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import '../models/printer.dart';

/// the current time, in “seconds since the epoch”
int currentTimeInSeconds() {
  var ms = (new DateTime.now()).millisecondsSinceEpoch;
  return (ms / 1000).round();
}


class PrinterStatus {

  PrinterStatus(this.printer){
    totalPages = 0;
    serialNumber = "";
  }

  Printer printer;
  int totalPages;
  String serialNumber;

  Future<http.Response> getData(String type) {
    var url = "";
    if (type == "product-config") {
      url = "/DevMgmt/ProductConfigDyn.xml";
    }else if (type == "product-usage") {
      url = "/DevMgmt/ProductUsageDyn.xml";
    }
    return http.get("http://" + printer.url + url);
  }

  Future<void> update() async {
    var response = await getData("product-usage");
    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      totalPages = int.parse(
          document.getElement("pudyn:ProductUsageDyn", namespace: null)
          .getElement("pudyn:PrinterSubunit", namespace: null)
          .getElement("dd:TotalImpressions", namespace: null).text);
    }
    var response2 = await getData("product-config");
    if (response2.statusCode == 200) {
      final document2 = XmlDocument.parse(response2.body);
      serialNumber = document2.getElement("prdcfgdyn2:ProductConfigDyn", namespace: null)
          .getElement("prdcfgdyn:ProductInformation", namespace: null)
          .getElement("dd:SerialNumber", namespace: null).text;
    }
  }

}

