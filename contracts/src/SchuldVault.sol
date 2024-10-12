// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SchuldVault is Ownable {
    error AlreadyInitialized();
    error NotAllowed();

    bool public initialized = false;
    address public schuldFi;

    modifier onlyProtocol() {
        if(msg.sender != schuldFi) {
            revert NotAllowed();
        }
        _;
    }

    constructor(address _owner) Ownable(_owner) {}

    function initialize(address _schuldFi) external onlyOwner() {
        if(initialized) {
            revert AlreadyInitialized();
        }
        schuldFi = _schuldFi;
    }

    function withdraw(address _token, uint256 _amount) external onlyProtocol() {

    }
}