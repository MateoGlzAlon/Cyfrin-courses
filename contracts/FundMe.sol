//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FundMe {
    //minimum USD to send
    uint256 public minimumUSD = 5;

    function fund() public payable {
        //1e18 wie == 1 ETH
        
        require(msg.value >= minimumUSD, "didn't send enough ETH");
    }

    function withdraw() public {}
}
