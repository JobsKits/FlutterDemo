import 'package:flutter_bet/generated/l10n.dart';

/// 交易类型
class TransactionsType {
  final String enCode;

  const TransactionsType(this.enCode);

  static const deposits    = TransactionsType("Deposits");
  static const withdrawals = TransactionsType('Withdrawals');
  static const bets        = TransactionsType('Bets');
  static const other       = TransactionsType('Other');

  static const List<TransactionsType> allType = [
    TransactionsType.deposits,
    TransactionsType.withdrawals,
    // TransactionsType.bets,
    TransactionsType.other,
  ];

  String get title {
      switch (this) {
        case TransactionsType.deposits:
          return S.current.wallet_deposit;
        case TransactionsType.withdrawals:
          return S.current.vault_withdraw_money;
        case TransactionsType.bets:
          return S.current.tab_bar_order;
        case TransactionsType.other:
          return S.current.transactions_other;
      }
      return "";
  }

  String get isThDeposits {
      switch (this) {
        case TransactionsType.deposits:
          return S.current.detailscopy1;
        case TransactionsType.withdrawals:
          return S.current.detailscopy2;
      }
      return "";
  }
}

/// 交易状态类型
class TransactionsStateType {
  // 1：成功，2：失败，3，进行中
  final String apiCode;

  const TransactionsStateType(this.apiCode);

  static const all      = TransactionsStateType('');
  static const success  = TransactionsStateType('1');
  static const fail     = TransactionsStateType('2');
  static const progress = TransactionsStateType('3');

  static const List<TransactionsStateType> allType = [
    TransactionsStateType.all,
    TransactionsStateType.success,
    TransactionsStateType.fail,
    TransactionsStateType.progress,
  ];

  String get title {
    switch (this) {
      case TransactionsStateType.all:
        return S.current.sport_all;
      case TransactionsStateType.success:
        return S.current.success_pwd;
      case TransactionsStateType.fail:
        return S.current.transactions_detail_state_fail;
      case TransactionsStateType.progress:
        return S.current.random_text_963;
    }
    return "";
  }
}

/// 货币类型
class TransactionsCoinType {
  final String enCode;

  const TransactionsCoinType(this.enCode);

  static const banking = TransactionsCoinType('Banking');
  static const crypto = TransactionsCoinType('Crypto');

  static const List<TransactionsCoinType> allType = [
    TransactionsCoinType.banking,
    TransactionsCoinType.crypto,
  ];

  String get title {
    switch (this) {
      case TransactionsCoinType.banking:
        return S.current.banking_text;
      case TransactionsCoinType.crypto:
        return S.current.crypto_text;
    }
    return "";
  }
}