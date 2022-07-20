import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

mixin TodosRepositoryImpleMixin {
  Future<void> getAbi(
      {required String abiCode,
      required String address,
      EthereumAddress? contractAddress}) async {
    String abiFileString =
        await rootBundle.loadString('src/abis/BlockTodos.json');
    final decoded = jsonDecode(abiFileString) as Map<String, dynamic>;
    abiCode = jsonEncode(decoded['abi']);
    final hex = decoded['networks']['5777']['address'];
    address = hex;
    contractAddress = EthereumAddress.fromHex(hex);
  }

  Future<void> getCredentials(
      {required String address,
      required Credentials credentials,
      EthereumAddress? ownAddress}) async {
    credentials = EthPrivateKey.fromHex(address);
    ownAddress = await credentials.extractAddress();
  }
}
