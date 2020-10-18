import '../utils/printer_status.dart';

class PagesLeft {
  int currentMonth;
  int accumulated;

  PagesLeft(this.currentMonth, this.accumulated);
}

class Printer {
  int id;
  String name;
  String url;
  String planName;
  int pagesPlan = 1;
  int pagesAccum = 0;
  int pagesCurr = 0;
  int invoicingDay = 1;
  int lastGrandTotal = 0;
  int lastDayChecked = 0;

  Printer(this.name, this.url, [ this.id ]){
    status = PrinterStatus(this);
  }

  PrinterStatus status;

  PagesLeft pagesLeft() {
    var currentMonth = pagesPlan - (status.totalPages - lastGrandTotal);
    var accumulated = pagesAccum;

    return PagesLeft(currentMonth, accumulated);
  }

  static const models = <String>["Envy 5540", "Envy 3383"];

  factory Printer.fromMap(Map<String, dynamic> v){
    var p = Printer(v["name"], v["url"], v["id"]);
    p.pagesAccum = v["pages_accum"];
    p.invoicingDay = v["invoicing_day"];
    p.pagesCurr = v["pages_curr"];
    p.pagesPlan = v["pages_plan"];
    p.planName = v["plan_name"];
    p.lastDayChecked = v["last_day_checked"];
    p.lastGrandTotal = v["last_grand_total"];
    return p;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "url": url,
      "plan_name": planName,
      "pages_plan": pagesPlan,
      "pages_curr": pagesCurr,
      "pages_accum": pagesAccum,
      "invoicing_day": invoicingDay,
      "last_day_checked": lastDayChecked,
      "last_grand_total": lastGrandTotal,
    };
  }

}