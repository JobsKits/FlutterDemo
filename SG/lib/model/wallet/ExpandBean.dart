class ExpandCardBean {
  int value;
  String headTitle;
  String? headIcon;
  bool? isOpen = false;
  bool showRadio = false;
  bool? showIcon= false;
  bool fiatCurrency;
  List<ExpandCardItem>? item;

  ExpandCardBean(
      {
        required this.value,
      required this.headTitle,
      this.headIcon,
      this.isOpen,
      required this.item,
      required this.showRadio,
      required this.fiatCurrency,
      this.showIcon});
}

class ExpandCardItem {
  ExpandCardItem(
      {required this.itemTitle,
      this.itemIcon,
      this.showCheckBox,
      this.showIcon,
      required this.itemId});

  int itemId;
  String? itemTitle;
  bool? showCheckBox = false;
  String? itemIcon;
  bool? showIcon;
}
