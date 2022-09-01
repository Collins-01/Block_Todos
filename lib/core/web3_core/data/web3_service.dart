import 'dart:convert';

import 'package:block_todos/core/core_constants.dart';
import 'package:block_todos/core/web3_core/interfaces/web3_interface.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Web3Service extends Web3Interface {
  Web3Client? _web3client;
  Credentials? _credentials;
  EthereumAddress? _ethereumAddress;
  EthereumAddress? _contractAddress;
  EthereumAddress? _ownAddress;
  String? _abiCode;
  String? _address;

  @override
  Future<void> initialise() async {
    try {
      _web3client =
          Web3Client(CoreConstants.rpcURL, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(CoreConstants.wsURL).cast<String>();
      });
    } catch (e) {
      //

    }
  }

  @override
  Web3Client? get web3client => _web3client;

  @override
  Credentials? get credentials => _credentials;

  @override
  EthereumAddress? get ethereumAddress => _ethereumAddress;

  @override
  Future<void> getAbi() async {
    try {
      String abiFileString =
          await rootBundle.loadString('src/abis/BlockTodos.json');
      final decoded = jsonDecode(abiFileString) as Map<String, dynamic>;
      _abiCode = jsonEncode(decoded['abi']);
      final hex = decoded['networks']['5777']['address'];
      _address = hex;
      _contractAddress = EthereumAddress.fromHex(hex);
    } catch (e) {
      //
    }
  }

  @override
  Future<void> getCredentials() async {
    try {
      if (_address != null) {
        _credentials = EthPrivateKey.fromHex(_address!);
        _ownAddress = await _credentials?.extractAddress();
      }
    } catch (e) {
      //
    }
  }

  @override
  String? get abiCode => _abiCode;

  @override
  EthereumAddress? get contractAddress => _contractAddress;
}

//Get Abi
// Get Credentials
//Get Deployed Contract
