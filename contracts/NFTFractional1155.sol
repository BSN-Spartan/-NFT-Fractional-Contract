// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract TokenFractional1155 is ERC1155 {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;


    struct erc721token {
        
        bool used;

        IERC721 erc721;

        uint256 tokenId;

        uint256 amount;
    }

    mapping (uint256 =>  erc721token) _erc721;

    struct tokenInfo {
        bool used;
        uint256 tokenId;
    }
    mapping (address=>mapping (uint256 => tokenInfo)) _tokens;

    event Fractional(address indexed erc721, address indexed spender, uint256 erctokenId, uint256 tokenId, uint256 amount);

    event Compose (address indexed sender,uint256 tokenId,address indexed to);

    constructor() ERC1155("") {}

    /**
     * @dev NFT fractionalization
     * 
     * Requirements: 
     * - `The owner of the NFT must be the sender, and has already set approval to this contract for NFT fractionalization.`
     * 
     * @param  erc721address - the address of erc-721 contract that mints the NFT
     * @param  erc721tokenId - the NFT ID
     * @param  amount - the number of tokens (NFT fractions)
     * @param  data data
     * 
     */
    function fractional(address erc721address, uint256 erc721tokenId, uint256 amount,bytes memory data) public {

        require(amount>0,"The number of tokens must be greater than 0");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        IERC721 erc721 = IERC721(erc721address);

        erc721.transferFrom(_msgSender(),  address(this), erc721tokenId);
        require(erc721.ownerOf(erc721tokenId)==address(this),"Failed to transfer the ownership of the NFT");

        _erc721[tokenId].erc721 =  erc721;
        _erc721[tokenId].tokenId = erc721tokenId;
        _erc721[tokenId].used = true;
        _erc721[tokenId].amount = amount;

        _tokens[erc721address][erc721tokenId].used = true;
        _tokens[erc721address][erc721tokenId].tokenId = tokenId;

        address sender = _msgSender();

        _mint(sender, tokenId, amount, data);

        emit Fractional(erc721address, _msgSender(),erc721tokenId, tokenId, amount);
    }

    /**
     * @dev Compose the tokens (NFT fractions)
     * 
     * Requirements: 
     * - `The sender owns all tokens (NFT fractions)`  
     * @param  to - the address to which the composed NFT will be transferred
     * @param  tokenId - the token ID of the NFT fractions
     * 
     */
    function compose(address to,uint256 tokenId) public {

        require(_erc721[tokenId].amount > 0,"Invalid token");

        address sender = _msgSender();
        
        uint256 amount = this.totalSupply(tokenId);

        require(this.balanceOf(sender,tokenId) == amount,"Not owning all the tokens");

        _erc721[tokenId].erc721.transferFrom(address(this), to, _erc721[tokenId].tokenId);
        
        _burn(sender, tokenId, amount);

        _erc721[tokenId].used = false ;
        _erc721[tokenId].amount = 0 ;

        emit Compose(sender, tokenId ,to);
    }



    /**
     * @dev  
     * 
     * Requirements: 
     * - `` 
     * - `` 
     * @param  tokenId - the token ID of NFT fractions
     * 
     * @return  the total number of tokens (NFT fractions)
     */
    function totalSupply(uint256 tokenId) external view returns (uint256) {
        
        require(_erc721[tokenId].used ,"Invalid token");

        return _erc721[tokenId].amount;
    
    }

    /**
     * @dev  Query the Token ID corresponding to the NFT
     * 
     * Requirements: 
     * - `` 
     * - `` 
     * @param  erc721address - the address of erc-721 contract that mints the NFT
     * @param  erc721tokenId - NFT ID
     * 
     * @return  token ID
     */
    function NFTOf (address erc721address,uint256 erc721tokenId) external view returns(uint256) {
        
        require(_tokens[erc721address][erc721tokenId].used,"Invalid NFT");

        return _tokens[erc721address][erc721tokenId].tokenId;
    }

    /**
     * @dev Query the Token ID and its corresponding address of the erc-721 contract 
     * 
     * @param  tokenId - Token ID
     * 
     * @return  token ID and the address of the erc-721 contract
     */
    function tokenOf (uint256 tokenId) external view returns(address,uint256) {
        
        require(_erc721[tokenId].used,"Invalid token");

        return (address(_erc721[tokenId].erc721), _erc721[tokenId].tokenId);
    }




}