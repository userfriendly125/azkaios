class PaystackResponse {
  PaystackResponse({
    bool? status,
    String? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  PaystackResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Data? _data;

  bool? get status => _status;

  String? get message => _message;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    String? authorizationUrl,
    String? accessCode,
    String? reference,
  }) {
    _authorizationUrl = authorizationUrl;
    _accessCode = accessCode;
    _reference = reference;
  }

  Data.fromJson(dynamic json) {
    _authorizationUrl = json['authorization_url'];
    _accessCode = json['access_code'];
    _reference = json['reference'];
  }

  String? _authorizationUrl;
  String? _accessCode;
  String? _reference;

  String? get authorizationUrl => _authorizationUrl;

  String? get accessCode => _accessCode;

  String? get reference => _reference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['authorization_url'] = _authorizationUrl;
    map['access_code'] = _accessCode;
    map['reference'] = _reference;
    return map;
  }
}
