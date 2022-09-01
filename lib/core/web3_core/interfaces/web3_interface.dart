import 'package:web3dart/web3dart.dart';

abstract class Web3Interface {
  //
  Future<void> initialise();
  Web3Client? get web3client;
  Credentials? get credentials;
  EthereumAddress? get ethereumAddress;
  Future<void> getAbi();
  Future<void> getCredentials();
  String? get abiCode;
  EthereumAddress? get contractAddress;
}

abstract class Web3Repository extends Web3Interface {}

abstract class Web3Service extends Web3Interface {}
