class UserModel {
  String? uid;
  String? phone;
  String? email;
  String? name;
  int? balance;
  int? deposit;
  int? withdrawals;
  int? received;
  int? sent;

  UserModel({
    this.uid,
    this.phone,
    this.email,
    this.name,
    this.balance,
    this.deposit,
    this.withdrawals,
    this.received,
    this.sent
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      phone: map['phone'],
      email: map['email'],
      name: map['name'],
      balance: map['balance'],
      deposit: map['deposit'],
      withdrawals: map['withdrawals'],
      received: map['received'],
      sent: map['sent'],
    );
  }
  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
      'email': email,
      'name': name,
      'balance': balance,
      'deposit': deposit,
      'withdrawals': withdrawals,
      'received': received,
      'sent': sent,
    };
  }
}
