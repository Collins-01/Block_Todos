# Block~Todos
A Blockchain powered Task Manager/Todo List  application that runs on the Ethereum Network.


## Tools
 - `Ganache v2.5.4` Enables running the Ethereum Blockchain on your local computer. 

- `Flutter v2.5` Mobile Application Development.

- `Solidity` Programming Language for writting smart contracts that runs on the Ethereum network.

- `Truffle  v5.5.22 ` Compiling and Migrations of the Smart Contracts. It's a development framework for Ethereum

- `Remix`  An Online code editor for writting and testing etheruem smart contracts. `remix.ethereum.org`



## Libraries 

- `web3dart` Used for connecting our mobile application to the Ethereum Blockchain.

- `http` It is generally used to make network requests when building our flutter applications. But here, it is a required argument for the Web3Client Library.

- `web_socket_channel` Used to send and recieve data, to and from the Ethereum smart contract.

- `Equatable` Used Comparing Objects in Dart.

- `rxdart` Used in this Project for Data Layer and Domain Layer StateManagement.

- `flutter_bloc`  Used  for Presentation Layer State  Managements. Listens and Reacts to events from our BLOC.

- `bloc` Used for handling Business Logics for here presentation layer.



## Structure

`project/contracts` -> Contains Smart contracts

`project/lib`   -> Contains all Flutter codes for this project.

`project/migrations` -> Contains the Migrations Scripts(JS).


`project/src/abis` -> Contains the abis for this project




### Instructions
 To run this project on your computer, please ensure  you have the tools listed above.

 Go to `lib/core/core_constants.dart` and add your secret key, and your localhost + your desired port number. I am using `7545` in this project.

 If you edited any of the smart contracts files, go to your terminal and open the path to the project, then run `truffle migrate --reset`
