// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Vault {
    mapping(address => uint) public balances;

    /// @dev Store ETH in the contract.
    function store() payable public {
        balances[msg.sender]+=msg.value;
    }
    
    /// @dev Redeem your ETH.
    function redeem() public {
        uint temp = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.call{value: temp}("");
    }
}

// The simple fix here is to store the balance associated with msg.sender in a temporary variable,
// and then update the balance in our mapping BEFORE the transfer takes place. This prevents the malicious contract
// to create any sort of Reentrancy attack to our main contract.

// The second solution can be to use a function modifier on our redeem() function to avoid the possible Reentrancy exploit.