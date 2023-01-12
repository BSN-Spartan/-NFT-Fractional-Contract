// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract TokenFractional20 is ERC20, Ownable {

    IERC721 private _erc721;

    uint256 private _tokenId;

    bool private _inited;

    event Fractional(address indexed erc721, address indexed spender, uint256 tokenId, uint256 amount);

    event Compose (address indexed sender,address indexed to);

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    /**
     * @dev NFT碎片化操作 
     * 
     * @param  erc721 需要碎片化的NFT合约地址
     * @param  tokenId 需要碎片化的NFT Token ID
     * @param  amount 碎片化之后的份额
     * 
     */
    function fractional(address erc721, uint256 tokenId, uint256 amount) public onlyOwner {
        
        require(!_inited,"contract only fractional once");

        require(amount > 0,"amount must greater than zero");

        _erc721 = IERC721(erc721);
        
        require(_erc721.ownerOf(tokenId)==_msgSender(),"caller must be NFT owner");
        
        _erc721.transferFrom(_msgSender(),  address(this), tokenId);

        require(_erc721.ownerOf(tokenId)==address(this),"check failed");

        _tokenId = tokenId;

        _mint(_msgSender(), amount);

        _inited = true;

        emit Fractional(erc721, _msgSender(), tokenId, amount);

    }

    /**
     * @dev 重新组合NFT 
     * 
     * Requirements: 
     * - `` 
     * - `` 
     * @param to 组合后的NFT转移的地址 
     */
    function compose(address to) public {

        require(to !=address(0),"to can not be zero address");

        address sender = _msgSender();

        require(this.balanceOf(sender) == this.totalSupply(),"Not owning all the tokens");

        _erc721.transferFrom(address(this), to, _tokenId);

        //selfdestruct(payable(to));

        _burn(sender, this.totalSupply());
        _inited = false ;
        emit Compose(sender, to);

    }

    function token() public view returns(address,uint256) {
        require(_inited,"NFT do not inited");
        return (address(_erc721),_tokenId);
    }
    
}