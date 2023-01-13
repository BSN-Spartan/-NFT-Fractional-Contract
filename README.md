# Fractional NFT

## What is NFT Fractionalization?

By calling the Fractional NFT smart contract (F-NFT contract), ERC-721-based NFT works can be fractionalized into multiple ERC-20/ERC-1155 tokens, and their ownership is also split for easy transfer and trading purposes.
In short, the NFT fractionalization process is equivalent to "asset redistribution", but this process changes the standard of the asset (from ERC-721 to ERC-20/ERC-1155).

## Why fractional NFT?

Lack of liquidity has become a pressing issue of the NFT market.

Currently, prices for popular NFT collectibles are high and it is not easy to find the right buyer quickly, while regular investors who wish to own these NFTs find it difficult to enter due to the high prices. As a result, sellers cannot get off the NFTs while potential buyers cannot get in, and the needs of both buyers and sellers cannot be met.

By calling the F-NFT contract, the NFT ownership can be shared, and retail investors can jointly own an NFT work. This can lower their entry barrier and inject more liquidity into the secondary NFT market.

At the same time, artists as well as NFT creators can easily tokenize fractional ownership of their works and get benefits without fully selling them.

## Fractional NFT Contract Design

NFTs can be fractionalized by ERC-20 and ERC-1155 contracts. The methods in the contract include NFT fractionalization/composition, ERC-20/ERC-1155 standard methods, NFT query and other methods.

> For the permissions of the contract and the process of minting NFTs and account authorization, the NFT owner should be clearly defined. 
> Contracts do not have administrative privileges and cannot be actively destroyed.


### ERC-20 Standard Fractional NFT Contract

A single ERC-721 NFT is authorized to the contract, and the contract generates ERC-20 tokens by inheriting the ERC-20 standard. A contract can only support the fractionalization of one NFT, and the contract will be reset after the NFT is composed.

#### Fractionalize the NFT

1. The NFT owner authorizes the NFT to the F-NFT contract.
2. The NFT owner calls the initialization method to set the symbol, the total number of NFT fractions (tokens). Then, fractionalize the authorized NFT.
3. The F-NFT contract transfers the authorized NFT to itself, minting tokens to the NFT owner according to the input parameters.

#### Transfer NFT Fractions
Inherit the standard method of ERC-20.

#### Compose the NFT
Accounts that own all tokens can compose the NFT and reset the F-NFT contract.

#### Query the NFT
Query the ERC-721 contract address and token ID of the NFT associated with the ERC-20 token.

### ERC-20 Standard Fractional NFT Contract
Multiple ERC-721 NFTs can be authorized to this contract, and the contract generates ERC-1155 tokens by inherits the ERC-1155 standard. Different NFTs can be fractionalized into different ERC-1155 tokens in one contract.

#### Fractionalize the NFT
1. The NFT owner authorizes the NFT to the F-NFT contract.
2. The NFT owner calls fractional method to generate ERC-1155 tokens to fractionalize the authorized NFTs.
3. The F-NFT contract transfers the authorized NFT to itself and generates the corresponding ERC-1155 tokens to the NFT owner according to the input parameters.


#### Transfer NFT Fractions
Inherit the standard method of ERC-1155.

#### Compose the NFT
Accounts that own all ERC-1155 tokens can compose the NFT and burn the ERC-1155 tokens.

#### Query the NFT
Query the ERC-721 contract address and token ID of the NFT associated with the ERC-1155 token.
