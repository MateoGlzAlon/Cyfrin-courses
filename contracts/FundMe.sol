//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    //minimum USD to send
    uint256 public minimumUSD = 5 * 10 ** 18;

    address[] public funders;
    mapping(address funder => uint amountFunded) public addressToAmountFunded;

    function fund() public payable {
        //1e18 wei == 1 ETH

        require(
            getConversionRate(msg.value) >= minimumUSD,
            "didn't send enough ETH"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public {}

    function getPrice() public view returns (uint256) {
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        //I could have (,int256 price,,,) as I only care about price
        (
            ,
            /*uint80 roundId*/
            int256 price,
            ,
            ,

        ) = /*uint256 startedAt*/
            /*uint256 timestamp*/
            /*uint80 answered*/

            priceFeed.latestRoundData();
        //price --> price of ETH in terms of USD
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ETHAmount) public view returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ETHAmount) / 1e18;

        return ethAmountInUSD;
    }

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }
}
