class Cihaz {
  dynamic cihazKodu;

  Cihaz(this.cihazKodu);
}

extension StringExts on String {
  String toLowerCaseTr() {
    return replaceAll("I", "ı").replaceAll("Ç", "c").toLowerCase();
  }
}
