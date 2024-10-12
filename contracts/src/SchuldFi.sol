// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract SchuldFi is Ownable, ERC721 {
    using SafeERC20 for IERC20;
    using Strings for uint256;

    error InvalidAmount();
    error TokenNotWhiteListed();

    struct NFTDetails {
        uint256 id;
        address token;
        uint256 shares;
    }

    uint256 public totalSupply;
    address public vault;
    mapping(address token => bool isWhitelisted) public tokenWhitelist;
    mapping(uint256 nftId => NFTDetails nftDetails) public nftDetailsMap; 
    mapping(address token => uint256 tokenShares) public tokenSharesMap;

    modifier notZeroAmount(uint256 amount) {
        if(amount==0) {
            revert InvalidAmount();
        }
        _;
    }

    modifier isWhitelistedToken(address token) {
        if(!tokenWhitelist[token]) {
            revert TokenNotWhiteListed();
        }
        _;
    }


    constructor(address _owner, address _vault) Ownable(_owner) ERC721("SchuldFi lpNFT", "SCHD-LPNFT" ) {
        vault = _vault;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

    function addLiquidity() external payable notZeroAmount(msg.value) {
        _addLiquidity(address(0), msg.value);
    }

    function addLiquidity(address _token, uint256 _amount) external notZeroAmount(_amount) isWhitelistedToken(_token) {
        _addLiquidity(_token, _amount);
    }

    function removeLiquidity(uint256 _tokenId, uint256 _amount) external notZeroAmount(_amount) isWhitelistedToken(_token) {
        address owner = _ownerOf(_tokenId);
        _checkAuthorized(owner, _msgSender(), _tokenId);
        _removeLiquidity(_tokenId, _amount);
    }

    function _addLiquidity(address _token, uint256 _amount) internal {
        totalSupply = totalSupply+1;
        NFTDetails storage nft = nftDetailsMap[totalSupply];
        nft.id = totalSupply;
        nft.token = _token;
        nft.amount = _amount;
        
        _mint(_msgSender(), totalSupply);
        IERC20(_token).safeTransferFrom(_msgSender(), address(this), _amount);
        IERC20(_token).safeTransfer(vault, _amount);
    }

    function _removeLiquidity(uint256 _tokenId, uint256 _amount) internal {
        
    }
}