extension AkoulaStringExtention on String {
  String removeExeptionWord() {
    return this.replaceAll('Exception:', "");
  }
}