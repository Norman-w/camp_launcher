// namespace wechatServer.model;
//
// public class PlayerInfo
// {
//   public long? Id { get; set; }
// public string? WechatOpenId { get; set; }
// public string? GameStartGuid { get; set; }
// }
class PlayerInfo {
  int? id;
  String? wechatOpenId;
  String? gameStartGuid;

  PlayerInfo({
    this.id,
    this.wechatOpenId,
    this.gameStartGuid,
  });

  PlayerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wechatOpenId = json['wechatOpenId'];
    gameStartGuid = json['gameStartGuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wechatOpenId'] = this.wechatOpenId;
    data['gameStartGuid'] = this.gameStartGuid;
    return data;
  }
}
