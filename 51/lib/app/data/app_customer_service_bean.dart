class AppCustomerServiceBean {
  String iconPath; //图标
  String name; //名字
  String? contactAddress; //联系地址

  AppCustomerServiceBean({
    required this.iconPath,
    required this.name,
    this.contactAddress,
  });
}
