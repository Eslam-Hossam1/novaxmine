class CoinWalletResponseModel {
  final bool? success;
  final String? message;
  final List<CoinWalletModel>? data;

  CoinWalletResponseModel({this.success, this.message, this.data});

  factory CoinWalletResponseModel.fromJson(Map<String, dynamic> json) {
    return CoinWalletResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CoinWalletModel.fromJson(item))
          .toList(),
    );
  }
}

class CoinWalletModel {
  final int? id;
  final String? network;
  final String? standard;
  final String? walletAddress;
  final String? tokenContract;
  final int? tokenDecimals;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  CoinWalletModel({
    this.id,
    this.network,
    this.standard,
    this.walletAddress,
    this.tokenContract,
    this.tokenDecimals,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CoinWalletModel.fromJson(Map<String, dynamic> json) {
    return CoinWalletModel(
      id: json['id'] as int?,
      network: json['network'] as String?,
      standard: json['standard'] as String?,
      walletAddress: json['wallet_address'] as String?,
      tokenContract: json['token_contract'] as String?,
      tokenDecimals: json['token_decimals'] is int
          ? json['token_decimals'] as int
          : int.tryParse(json['token_decimals']?.toString() ?? ''),
      isActive: json['is_active'] is int
          ? json['is_active'] as int
          : int.tryParse(json['is_active']?.toString() ?? ''),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
