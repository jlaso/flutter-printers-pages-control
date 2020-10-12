import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import '../models/printer.dart';

class PrinterStatus {

  PrinterStatus(this.printer);

  Printer printer;
  int totalPages;
  String serialNumber;

  Future<bool> update() async {
    final url = PrinterStatus.getUrl(printer);
    if (url == null) return false;
    final response = await http.get("http://" + printer.url + "/" + url);
    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      totalPages = int.parse(
          document.getElement("pudyn:ProductUsageDyn", namespace: null)
          .getElement("pudyn:PrinterSubunit", namespace: null)
          .getElement("dd:TotalImpressions", namespace: null).text);
      return true;
    }
    return false;
  }

  static String getUrl(Printer p) {
    switch (p.name) {
      case "Envy 5540":
        {
          return "DevMgmt/ProductUsageDyn.xml";
        }
      default:
        return null;
    }
  }
}

// void main() {
//   final p = Printer("Envy 5540", "192.168.1.47");
//   var ps = PrinterStatus(p);
//   ps.update().then((value) {
//     print(ps.totalPages);
//   });
// }
