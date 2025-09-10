class FilterModel {
    List<BettypeFilter>? bettypeFilter;
    List<ListFilter>? listFilter;

    FilterModel({
        this.bettypeFilter,
        this.listFilter,
    });

    factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
        bettypeFilter: json["bettype_filter"] == null ? [] : List<BettypeFilter>.from(json["bettype_filter"]!.map((x) => BettypeFilter.fromJson(x))),
        listFilter: json["list_filter"] == null ? [] : List<ListFilter>.from(json["list_filter"]!.map((x) => ListFilter.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "bettype_filter": bettypeFilter == null ? [] : List<dynamic>.from(bettypeFilter!.map((x) => x.toJson())),
        "list_filter": listFilter == null ? [] : List<dynamic>.from(listFilter!.map((x) => x.toJson())),
    };
}

class BettypeFilter {
    int? si;
    List<Btl>? btl;

    BettypeFilter({
        this.si,
        this.btl,
    });

    factory BettypeFilter.fromJson(Map<String, dynamic> json) => BettypeFilter(
        si: json["si"],
        btl: json["btl"] == null ? [] : List<Btl>.from(json["btl"]!.map((x) => Btl.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "si": si,
        "btl": btl == null ? [] : List<dynamic>.from(btl!.map((x) => x.toJson())),
    };
}

class Btl {
    int? bt;
    int? egi;
    String? btn;

    Btl({
        this.bt,
        this.egi,
        this.btn,
    });

    factory Btl.fromJson(Map<String, dynamic> json) => Btl(
        bt: json["bt"],
        egi: json["egi"],
        btn: json["btn"],
    );

    Map<String, dynamic> toJson() => {
        "bt": bt,
        "egi": egi,
        "btn": btn,
    };
}

class ListFilter {
    int? lfid;
    String? name;
    String? icon;
    String? iconHl;
    int? type;
    int? m;
    int? ic;
    int? hot;
    int? ivs;

    ListFilter({
        this.lfid,
        this.name,
        this.icon,
        this.iconHl,
        this.type,
        this.m,
        this.ic,
        this.hot,
        this.ivs,
    });

    factory ListFilter.fromJson(Map<String, dynamic> json) => ListFilter(
        lfid: json["lfid"],
        name: json["name"],
        icon: json["icon"],
        iconHl: json["icon_hl"],
        type: json["type"],
        m: json["m"],
        ic: json["ic"],
        hot: json["hot"],
        ivs: json["ivs"],
    );

    Map<String, dynamic> toJson() => {
        "lfid": lfid,
        "name": name,
        "icon": icon,
        "icon_hl": iconHl,
        "type": type,
        "m": m,
        "ic": ic,
        "hot": hot,
        "ivs": ivs,
    };
}
