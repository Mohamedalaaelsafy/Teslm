

class User {
  final String name;
  final String email;
  final String phonenumber;
  final num heartbeat;
  final List<UserHistory> userHistory;

  const User(
      {this.name,
      this.email,
      this.phonenumber,
      this.heartbeat,
      this.userHistory});

  User.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap["User"]["name"],
        email = jsonMap["User"]["email"],
        phonenumber = jsonMap["User"]["phoneNumber"],
        heartbeat = jsonMap["User"]["heartBeat"],
        userHistory = (jsonMap['User']['user_history'] as List)
            .map((i) => UserHistory.fromJson(i))
            .toList();
}

class UserHistory {
  final num heartbeat;
  final String date;

  const UserHistory(this.heartbeat, this.date);

  UserHistory.fromJson(Map jsonMap)
      : heartbeat = jsonMap['heart_Beat'],
        date = jsonMap['Date'];
}
