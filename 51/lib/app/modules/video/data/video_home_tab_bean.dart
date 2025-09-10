class VideoHomeTabBean {
  VideoHomeTabBean({
    this.tid,
    this.id,
    this.type,
    this.url,
    this.name,
    this.title,
    this.onlyTopic,
  });

  VideoHomeTabBean.fromJson(dynamic json) {
    tid = json['tid'];
    id = json['id'];
    type = json['type'];
    url = json['url'];
    name = json['name'];
    title = json['title'];
    onlyTopic = json['only_topic'];
  }
  num? tid;
  int? id;
  String? type;
  String? url;
  String? name;
  String? title;
  String? onlyTopic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tid'] = tid;
    map['id'] = id;
    map['type'] = type;
    map['url'] = url;
    map['name'] = name;
    map['title'] = title;
    map['only_topic'] = onlyTopic;
    return map;
  }

  @override
  String toString() {
    return 'VideoHomeTabBean{tid: $tid, id: $id, type: $type, url: $url, name: $name, title: $title, onlyTopic: $onlyTopic}';
  }
}
