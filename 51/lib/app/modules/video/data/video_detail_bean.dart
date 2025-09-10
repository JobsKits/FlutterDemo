//视频详情的实体类
class VideoDetailBean {
  VideoDetailBean({
    this.id,
    // this.videoId,
    this.title,
    this.label,
    this.uploadThumb,
    this.thumb,
    this.author,
    this.createDate,
    this.checkDate,
    this.status,
    this.gifurl,
    this.href,
    this.href1,
    this.href2,
    this.origin,
    this.comments,
    this.likes,
    this.collection,
    this.iscoding,
    this.classify,
    this.watchtimes,
    this.downloadTimes,
    this.duration,
    this.sort,
    this.touristTime,
    this.downloadAddress,
    this.downloadAddress1,
    this.downloadAddress2,
    this.isDownloadable,
    this.filestorekey,
    this.years,
    this.region,
    this.backstageThumb,
    this.operatedBy,
    this.tags,
    this.desc,
    this.point,
    this.prev,
    this.next,
    this.isLike,
  });

  VideoDetailBean.fromJson(dynamic json) {
    id = json['id'];
    // videoId = json['video_id'];
    title = json['title'];
    label = json['label'];
    uploadThumb = json['upload_thumb'];
    thumb = json['thumb'];
    author = json['author'];
    createDate = json['create_date'];
    checkDate = json['check_date'];
    status = json['status'];
    gifurl = json['gifurl'];
    href = json['href'];
    href1 = json['href_1'];
    href2 = json['href_2'];
    origin = json['origin'];
    comments = json['comments'];
    likes = json['likes'];
    collection = json['collection'];
    iscoding = json['iscoding'];
    classify = json['classify'];
    watchtimes = json['watchtimes'];
    downloadTimes = json['download_times'];
    duration = json['duration'];
    sort = json['sort'];
    touristTime = json['tourist_time'];
    downloadAddress = json['download_address'];
    downloadAddress1 = json['download_address_1'];
    downloadAddress2 = json['download_address_2'];
    isDownloadable = json['is_downloadable'];
    filestorekey = json['filestorekey'];
    years = json['years'];
    region = json['region'];
    backstageThumb = json['backstage_thumb'];
    operatedBy = json['operated_by'];
    tags = json['tags'];
    desc = json['desc'];
    point = json['point'];
    prev = json['prev'] != null ? Prev.fromJson(json['prev']) : null;
    next = json['next'] != null ? Next.fromJson(json['next']) : null;
    isLike = json['is_like'];
  }
  int? id;
  // String? videoId;
  String? title;
  String? label;
  String? uploadThumb;
  String? thumb;
  String? author;
  String? createDate;
  String? checkDate;
  int? status;
  String? gifurl;
  String? href;
  String? href1;
  String? href2;
  int? origin;
  int? comments;
  int? likes;
  int? collection;
  int? iscoding;
  String? classify;
  int? watchtimes;
  int? downloadTimes;
  String? duration;
  int? sort;
  int? touristTime;
  String? downloadAddress;
  String? downloadAddress1;
  String? downloadAddress2;
  int? isDownloadable;
  String? filestorekey;
  String? years;
  String? region;
  String? backstageThumb;
  String? operatedBy;
  String? tags;
  String? desc;
  double? point;
  Prev? prev;
  Next? next;
  int? isLike;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    // map['video_id'] = videoId;
    map['title'] = title;
    map['label'] = label;
    map['upload_thumb'] = uploadThumb;
    map['thumb'] = thumb;
    map['author'] = author;
    map['create_date'] = createDate;
    map['check_date'] = checkDate;
    map['status'] = status;
    map['gifurl'] = gifurl;
    map['href'] = href;
    map['href_1'] = href1;
    map['href_2'] = href2;
    map['origin'] = origin;
    map['comments'] = comments;
    map['likes'] = likes;
    map['collection'] = collection;
    map['iscoding'] = iscoding;
    map['classify'] = classify;
    map['watchtimes'] = watchtimes;
    map['download_times'] = downloadTimes;
    map['duration'] = duration;
    map['sort'] = sort;
    map['tourist_time'] = touristTime;
    map['download_address'] = downloadAddress;
    map['download_address_1'] = downloadAddress1;
    map['download_address_2'] = downloadAddress2;
    map['is_downloadable'] = isDownloadable;
    map['filestorekey'] = filestorekey;
    map['years'] = years;
    map['region'] = region;
    map['backstage_thumb'] = backstageThumb;
    map['operated_by'] = operatedBy;
    map['tags'] = tags;
    map['desc'] = desc;
    map['point'] = point;
    if (prev != null) {
      map['prev'] = prev?.toJson();
    }
    if (next != null) {
      map['next'] = next?.toJson();
    }
    map['is_like'] = isLike;
    return map;
  }
}

class Next {
  Next({
    this.id,
    // this.videoId,
    this.title,
    this.label,
    this.uploadThumb,
    this.thumb,
    this.author,
    this.createDate,
    this.checkDate,
    this.status,
    this.gifurl,
    this.href,
    this.href1,
    this.href2,
    this.origin,
    this.comments,
    this.likes,
    this.collection,
    this.iscoding,
    this.classify,
    this.watchtimes,
    this.downloadTimes,
    this.duration,
    this.sort,
    this.touristTime,
    this.downloadAddress,
    this.downloadAddress1,
    this.downloadAddress2,
    this.isDownloadable,
    this.filestorekey,
    this.years,
    this.region,
    this.backstageThumb,
    this.operatedBy,
    this.tags,
    this.desc,
    this.point,
    this.prev,
    this.next,
    this.isLike,
  });

  Next.fromJson(dynamic json) {
    id = json['id'];
    // videoId = json['video_id'];
    title = json['title'];
    label = json['label'];
    uploadThumb = json['upload_thumb'];
    thumb = json['thumb'];
    author = json['author'];
    createDate = json['create_date'];
    checkDate = json['check_date'];
    status = json['status'];
    gifurl = json['gifurl'];
    href = json['href'];
    href1 = json['href_1'];
    href2 = json['href_2'];
    origin = json['origin'];
    comments = json['comments'];
    likes = json['likes'];
    collection = json['collection'];
    iscoding = json['iscoding'];
    classify = json['classify'];
    watchtimes = json['watchtimes'];
    downloadTimes = json['download_times'];
    duration = json['duration'];
    sort = json['sort'];
    touristTime = json['tourist_time'];
    downloadAddress = json['download_address'];
    downloadAddress1 = json['download_address_1'];
    downloadAddress2 = json['download_address_2'];
    isDownloadable = json['is_downloadable'];
    filestorekey = json['filestorekey'];
    years = json['years'];
    region = json['region'];
    backstageThumb = json['backstage_thumb'];
    operatedBy = json['operated_by'];
    tags = json['tags'];
    desc = json['desc'];
    point = json['point'];
    prev = json['prev'];
    next = json['next'];
    isLike = json['is_like'];
  }
  int? id;
  // String? videoId;
  String? title;
  String? label;
  String? uploadThumb;
  String? thumb;
  String? author;
  String? createDate;
  String? checkDate;
  int? status;
  String? gifurl;
  String? href;
  String? href1;
  String? href2;
  int? origin;
  int? comments;
  int? likes;
  int? collection;
  int? iscoding;
  String? classify;
  int? watchtimes;
  int? downloadTimes;
  String? duration;
  int? sort;
  int? touristTime;
  String? downloadAddress;
  String? downloadAddress1;
  String? downloadAddress2;
  int? isDownloadable;
  String? filestorekey;
  String? years;
  String? region;
  String? backstageThumb;
  String? operatedBy;
  String? tags;
  String? desc;
  double? point;
  dynamic prev;
  dynamic next;
  int? isLike;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    // map['video_id'] = videoId;
    map['title'] = title;
    map['label'] = label;
    map['upload_thumb'] = uploadThumb;
    map['thumb'] = thumb;
    map['author'] = author;
    map['create_date'] = createDate;
    map['check_date'] = checkDate;
    map['status'] = status;
    map['gifurl'] = gifurl;
    map['href'] = href;
    map['href_1'] = href1;
    map['href_2'] = href2;
    map['origin'] = origin;
    map['comments'] = comments;
    map['likes'] = likes;
    map['collection'] = collection;
    map['iscoding'] = iscoding;
    map['classify'] = classify;
    map['watchtimes'] = watchtimes;
    map['download_times'] = downloadTimes;
    map['duration'] = duration;
    map['sort'] = sort;
    map['tourist_time'] = touristTime;
    map['download_address'] = downloadAddress;
    map['download_address_1'] = downloadAddress1;
    map['download_address_2'] = downloadAddress2;
    map['is_downloadable'] = isDownloadable;
    map['filestorekey'] = filestorekey;
    map['years'] = years;
    map['region'] = region;
    map['backstage_thumb'] = backstageThumb;
    map['operated_by'] = operatedBy;
    map['tags'] = tags;
    map['desc'] = desc;
    map['point'] = point;
    map['prev'] = prev;
    map['next'] = next;
    map['is_like'] = isLike;
    return map;
  }

  @override
  String toString() {
    return 'Next{id: $id, title: $title, label: $label, uploadThumb: $uploadThumb, thumb: $thumb, author: $author, createDate: $createDate, checkDate: $checkDate, status: $status, gifurl: $gifurl, href: $href, href1: $href1, href2: $href2, origin: $origin, comments: $comments, likes: $likes, collection: $collection, iscoding: $iscoding, classify: $classify, watchtimes: $watchtimes, downloadTimes: $downloadTimes, duration: $duration, sort: $sort, touristTime: $touristTime, downloadAddress: $downloadAddress, downloadAddress1: $downloadAddress1, downloadAddress2: $downloadAddress2, isDownloadable: $isDownloadable, filestorekey: $filestorekey, years: $years, region: $region, backstageThumb: $backstageThumb, operatedBy: $operatedBy, tags: $tags, desc: $desc, point: $point, prev: $prev, next: $next, isLike: $isLike}';
  }
}

class Prev {
  Prev({
    this.id,
    // this.videoId,
    this.title,
    this.label,
    this.uploadThumb,
    this.thumb,
    this.author,
    this.createDate,
    this.checkDate,
    this.status,
    this.gifurl,
    this.href,
    this.href1,
    this.href2,
    this.origin,
    this.comments,
    this.likes,
    this.collection,
    this.iscoding,
    this.classify,
    this.watchtimes,
    this.downloadTimes,
    this.duration,
    this.sort,
    this.touristTime,
    this.downloadAddress,
    this.downloadAddress1,
    this.downloadAddress2,
    this.isDownloadable,
    this.filestorekey,
    this.years,
    this.region,
    this.backstageThumb,
    this.operatedBy,
    this.tags,
    this.desc,
    this.point,
    this.prev,
    this.next,
    this.isLike,
  });

  Prev.fromJson(dynamic json) {
    id = json['id'];
    // videoId = json['video_id'];
    title = json['title'];
    label = json['label'];
    uploadThumb = json['upload_thumb'];
    thumb = json['thumb'];
    author = json['author'];
    createDate = json['create_date'];
    checkDate = json['check_date'];
    status = json['status'];
    gifurl = json['gifurl'];
    href = json['href'];
    href1 = json['href_1'];
    href2 = json['href_2'];
    origin = json['origin'];
    comments = json['comments'];
    likes = json['likes'];
    collection = json['collection'];
    iscoding = json['iscoding'];
    classify = json['classify'];
    watchtimes = json['watchtimes'];
    downloadTimes = json['download_times'];
    duration = json['duration'];
    sort = json['sort'];
    touristTime = json['tourist_time'];
    downloadAddress = json['download_address'];
    downloadAddress1 = json['download_address_1'];
    downloadAddress2 = json['download_address_2'];
    isDownloadable = json['is_downloadable'];
    filestorekey = json['filestorekey'];
    years = json['years'];
    region = json['region'];
    backstageThumb = json['backstage_thumb'];
    operatedBy = json['operated_by'];
    tags = json['tags'];
    desc = json['desc'];
    point = json['point'];
    prev = json['prev'];
    next = json['next'];
    isLike = json['is_like'];
  }
  int? id;
  // String? videoId;
  String? title;
  String? label;
  String? uploadThumb;
  String? thumb;
  String? author;
  String? createDate;
  String? checkDate;
  int? status;
  String? gifurl;
  String? href;
  String? href1;
  String? href2;
  int? origin;
  int? comments;
  int? likes;
  int? collection;
  int? iscoding;
  String? classify;
  int? watchtimes;
  int? downloadTimes;
  String? duration;
  int? sort;
  int? touristTime;
  String? downloadAddress;
  String? downloadAddress1;
  String? downloadAddress2;
  int? isDownloadable;
  String? filestorekey;
  String? years;
  String? region;
  String? backstageThumb;
  String? operatedBy;
  String? tags;
  String? desc;
  double? point;
  dynamic prev;
  dynamic next;
  int? isLike;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    // map['video_id'] = videoId;
    map['title'] = title;
    map['label'] = label;
    map['upload_thumb'] = uploadThumb;
    map['thumb'] = thumb;
    map['author'] = author;
    map['create_date'] = createDate;
    map['check_date'] = checkDate;
    map['status'] = status;
    map['gifurl'] = gifurl;
    map['href'] = href;
    map['href_1'] = href1;
    map['href_2'] = href2;
    map['origin'] = origin;
    map['comments'] = comments;
    map['likes'] = likes;
    map['collection'] = collection;
    map['iscoding'] = iscoding;
    map['classify'] = classify;
    map['watchtimes'] = watchtimes;
    map['download_times'] = downloadTimes;
    map['duration'] = duration;
    map['sort'] = sort;
    map['tourist_time'] = touristTime;
    map['download_address'] = downloadAddress;
    map['download_address_1'] = downloadAddress1;
    map['download_address_2'] = downloadAddress2;
    map['is_downloadable'] = isDownloadable;
    map['filestorekey'] = filestorekey;
    map['years'] = years;
    map['region'] = region;
    map['backstage_thumb'] = backstageThumb;
    map['operated_by'] = operatedBy;
    map['tags'] = tags;
    map['desc'] = desc;
    map['point'] = point;
    map['prev'] = prev;
    map['next'] = next;
    map['is_like'] = isLike;
    return map;
  }

  @override
  String toString() {
    return 'Prev{id: $id, title: $title, label: $label, uploadThumb: $uploadThumb, thumb: $thumb, author: $author, createDate: $createDate, checkDate: $checkDate, status: $status, gifurl: $gifurl, href: $href, href1: $href1, href2: $href2, origin: $origin, comments: $comments, likes: $likes, collection: $collection, iscoding: $iscoding, classify: $classify, watchtimes: $watchtimes, downloadTimes: $downloadTimes, duration: $duration, sort: $sort, touristTime: $touristTime, downloadAddress: $downloadAddress, downloadAddress1: $downloadAddress1, downloadAddress2: $downloadAddress2, isDownloadable: $isDownloadable, filestorekey: $filestorekey, years: $years, region: $region, backstageThumb: $backstageThumb, operatedBy: $operatedBy, tags: $tags, desc: $desc, point: $point, prev: $prev, next: $next, isLike: $isLike}';
  }
}
