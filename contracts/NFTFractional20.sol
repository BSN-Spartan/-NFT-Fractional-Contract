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
     * @dev NFT fractionalization 
     * 
     * @param  erc721 - the address of erc-721 contract that mints the NFT
     * @param  tokenId - the NFT ID
     * @param  amount - the number of the tokens (NFT fractions)
     * 
     */
    function fractional(address erc721, uint256 tokenId, uint256 amount) public onlyOwner {
        
        require(!_inited,"The contract is already in use");

        require(amount > 0,"The number of tokens must be greater than 0");

        _erc721 = IERC721(erc721);
        
        require(_erc721.ownerOf(tokenId)==_msgSender(),"The caller must be the owner of the NFT");
        
        _erc721.transferFrom(_msgSender(),  address(this), tokenId);

        require(_erc721.ownerOf(tokenId)==address(this),"Failed to transfer the ownership of the NFT");

        _tokenId = tokenId;

        _mint(_msgSender(), amount);

        _inited = true;

        emit Fractional(erc721, _msgSender(), tokenId, amount);

    }

    /**
     * @dev Compose the tokens (NFT fractions)
     * 
     * Requirements: 
     * - `` 
     * - `` 
     * @param to - the address to which the composed NFT will be transferred
     */
    function compose(address to) public {

        require(to !=address(0),"to cannot be 0 address");

        address sender = _msgSender();

        require(this.balanceOf(sender) == this.totalSupply(),"Not owning all tokens");

        _erc721.transferFrom(address(this), to, _tokenId);

        //selfdestruct(payable(to));

        _burn(sender, this.totalSupply());
        _inited = false ;
        emit Compose(sender, to);

    }

    function token() public view returns(address,uint256) {
        require(_inited,"The NFT is not initialized");
        return (address(_erc721),_tokenId);
    }
    
}