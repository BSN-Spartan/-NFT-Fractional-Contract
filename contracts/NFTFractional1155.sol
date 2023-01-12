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
     * @dev 拆分NFT
     * 
     * Requirements: 
     * - `待拆分的NFT的Owner必须为sender，并且已经授权给该合约` 
     * 
     * @param  erc721address 需要拆分的NFT合约地址
     * @param  erc721tokenId 需要拆分的NFT Token ID
     * @param  amount 拆分的份额
     * @param  data data
     * 
     */
    function fractional(address erc721address, uint256 erc721tokenId, uint256 amount,bytes memory data) public {

        require(amount>0,"amount must greater than zero");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        IERC721 erc721 = IERC721(erc721address);

        erc721.transferFrom(_msgSender(),  address(this), erc721tokenId);
        require(erc721.ownerOf(erc721tokenId)==address(this),"check failed");

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
     * @dev 组合NFT，并转移给执行地址
     * 
     * Requirements: 
     * - `sender拥有该Token的所有份额` 
     * - `` 
     * @param  to 组合后的NFT转移地址
     * @param  tokenId 组合的token Id
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
     * @param  tokenId 查询的Token ID
     * 
     * @return 该token的总数 
     */
    function totalSupply(uint256 tokenId) external view returns (uint256) {
        
        require(_erc721[tokenId].used ,"Invalid token");

        return _erc721[tokenId].amount;
    
    }

    /**
     * @dev  查询NFT所对应的Token ID
     * 
     * Requirements: 
     * - `` 
     * - `` 
     * @param  erc721address NFT 合约地址
     * @param  erc721tokenId NFT ID
     * 
     * @return  token ID
     */
    function NFTOf (address erc721address,uint256 erc721tokenId) external view returns(uint256) {
        
        require(_tokens[erc721address][erc721tokenId].used,"Invalid NFT");

        return _tokens[erc721address][erc721tokenId].tokenId;
    }

    /**
     * @dev 查询Token对应的NFT的合约地址以及TokenID 
     * 
     * @param  tokenId 查询的Token ID
     * 
     * @return  NFT的合约地址以及ID 
     */
    function tokenOf (uint256 tokenId) external view returns(address,uint256) {
        
        require(_erc721[tokenId].used,"Invalid token");

        return (address(_erc721[tokenId].erc721), _erc721[tokenId].tokenId);
    }




}