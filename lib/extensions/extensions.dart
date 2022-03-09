extension AkoulaStringExtention on String {
  String removeExeptionWord() {
    return this.replaceAll('Exception:', "");
  }
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}