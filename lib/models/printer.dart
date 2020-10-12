class Printer {
  int id;
  String name;
  String url;
  String planName;
  int pagesPlan = 1;
  int pagesAccum = 0;
  int pagesCurr = 0;
  int invoicingDay = 1;

  Printer(this.name, this.url, [ this.id ]);

  static const models = <String>["Envy 5540", "Envy 3383"];

  factory Printer.fromMap(Map<String, dynamic> v){
    var p = Printer(v["name"], v["url"], v["id"]);
    p.pagesAccum = v["pages_accum"];
    p.invoicingDay = v["invoicing_day"];
    p.pagesCurr = v["pages_curr"];
    p.pagesPlan = v["pages_plan"];
    p.planName = v["plan_name"];
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
    };
  }

}