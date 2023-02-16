# Fractional NFT
[![Smart Contract](https://badgen.net/badge/smart-contract/Solidity/orange)](https://soliditylang.org/)

By calling the Fractional NFT smart contract (F-NFT contract), ERC-721-based NFT works can be fractionalized into multiple ERC-20/ERC-1155 tokens, and their ownership is also split for easy transfer and trading purposes.
In short, the NFT fractionalization process is equivalent to "asset redistribution", but this process changes the standard of the asset (from ERC-721 to ERC-20/ERC-1155).

## Prerequisite

Before using a smart contract, it is important to have a basic understanding of Ethereum and Solidity.
It is also necessary to understand [ERC20](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/a55b7d13722e7ce850b626da2313f3e66ca1d101/contracts/token/ERC20), [ERC721](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/a55b7d13722e7ce850b626da2313f3e66ca1d101/contracts/token/ERC721) and [ERC1155](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/a55b7d13722e7ce850b626da2313f3e66ca1d101/contracts/token/ERC1155) standards. Before deploying this contract, developers need the ability to deploy NFT contracts and generate NFTs.

## Overview

Lack of liquidity has become a pressing issue of the NFT market.

Currently, prices for popular NFT collectibles are high and it is not easy to find the right buyer quickly, while regular investors who wish to own these NFTs find it difficult to enter due to the high prices. As a result, sellers cannot get off the NFTs while potential buyers cannot get in, and the needs of both buyers and sellers cannot be met.

By calling the F-NFT contract, the NFT ownership can be shared, and retail investors can jointly own an NFT work. This can lower their entry barrier and inject more liquidity into the secondary NFT market.

At the same time, artists as well as NFT creators can easily tokenize fractional ownership of their works and get benefits without fully selling them.


## Usage



Get the smart contract from [GitHub](https://github.com/BSN-Spartan/NFT-Fractional-Contract/tree/main/contracts), or get the source code by command:

```
$ git clone https://github.com/BSN-Spartan/NFT-Fractional-Contract.git
```

For beginners, the contracts in this application can be deployed by the steps in [Spartan Quick Testing](https://www.spartan.bsn.foundation/main/quick-testing#step1).

In this application, there are three contracts: ERC-721, NFTFractional20 and NFTFractional1155. Follow steps below to deploy and use them:

1. Deploy ERC-721 contract.
2. Mint an ERC-721 NFT to a wallet address.
3. Deploy NFTFractional20/NFTFractional1155 contract.
4. The owner of the NFT (wallet address) calls approve() to authorize the address of NFTFractional20/NFTFractional1155 to operate the NFT.
5. The owner of NFTFractional20/NFTFractional1155 contract calls fractional() to break the NFT into smaller fragments (in the form of ERC-20/ERC-1155 tokens).
6. Several users can buy and hold these tokens to claim the ownership of a piece of this NFT.
7. Once a user holds all ERC-20/ERC-1155 tokens, he/she can call compose() in NFTFractional20/NFTFractional1155 contract to burn all tokens and transfer this entire NFT to his/her wallet address.

## Main Functions

### Fractionalization

Before calling this method, make sure that the contract has not performed this operation before and the NFT has been authorized to the address of the contract. Then, call fractional() to fragment the NFT. This method is only allowed to be called by the owner of the contract.

#### In `NFT-Fractional20` Contract:

```solidity
function fractional(address erc721, uint256 tokenId, uint256 amount) public onlyOwner
```

Data will not be returned after calling this function, but you can observe the following results after a successful call:

1. The Owner of the NFT becomes the address of this contract.
2. The number of the supplied tokens in this contract is the entered amount.

#### In `NFT-Fractional1155` Contract:

```
function fractional(address erc721address, uint256 erc721tokenId, uint256 amount,bytes memory data) public
```

Data will not be returned after calling this function, but you can observe the following results after a successful call:

1. The Owner of the NFT becomes the address of this contract.
2. You will get an ERC-1155 `Token` from this contract;
3. The balance of the ERC-1155 token in this contract is the entered amount；



> The difference between the two contracts is that the NFT-Fractional20 contract can only shard one NFT at a time, while the `NFT-Fractional1155` contract can shard multiple NFTs at the same time and use TokenId to differentiate each other.



### NFT Composition

Accounts that own all tokens can compose the NFT and reset the F-NFT contract.

If your account holds all tokens or the entire balances of the ERC-1155 token, then you can call this method to reassemble that NFT and send that NFT to your wallet address.

#### In `NFT-Fractional20` Contract:

```
function compose(address to) public 
```

Data will not be returned after calling this function, but you can observe the following results after a successful call:

1. Change the address of the NFT owner to `to`；
2. Reset the contract to the initial status；

#### In `NFT-Fractional1155` Contract:

```
function compose(address to,uint256 tokenId) public 
```

Data will not be returned after calling this function, but you can observe the following results after a successful call:

1. Change the address of the NFT owner to `to`;
2. The ERC-1155 token will be burnt.



## License

Spartan-NFT Contracts is released under the [Spartan License](https://github.com/BSN-Spartan/NFT/blob/main/LICENSE).
