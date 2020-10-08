class BankAccount {
  num id;
  String accountNumber, bankName, ibanNumber;
  BankAccount({this.id, this.accountNumber, this.bankName, this.ibanNumber});

  factory BankAccount.fromJson(json) {
    return BankAccount(
        id: json['id'],
        accountNumber: json['account_number'],
        bankName: json['bank_name'],
        ibanNumber: json['iban_number']);
  }
}
