//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//import {PriceConverter} from "./PriceConverter.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    //minimum USD to send
    uint256 public minimumUSD = 5 * 10**18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minimumUSD,
            "didn't send enough ETH"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] =
            addressToAmountFunded[msg.sender] +
            msg.value;

        //1e18 wei == 1 ETH
        /*        require(
            getConversionRate(msg.value) >= minimumUSD,
            "didn't send enough ETH"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] =
            addressToAmountFunded[msg.sender] +
            msg.value;

            */
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //Reset the array
        funders = new address[](0);

        //Method 1 --> transfer
        //payable(msg.sender).transfer(address(this).balance);

        //Method 2 --> send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "failed to send Ether");

        //Method 3 --> call
        (
            bool callSuccess, /* bytes memory dataReturned*/

        ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "failed to call");
    }

    modifier onlyOwner() {
        //require(msg.sender == owner, "only owner can call this function");
        //This (_;) represents the rest of the code, you can either put it before so the modifier executes after the code of after

        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    function showUSDBalance() public view returns (uint256) {
        // Get the current balance of the contract in ETH (in wei)
        uint256 ethBalance = address(this).balance;

        // Convert the ETH balance to USD using the getConversionRate function from PriceConverter
        uint256 usdBalance = ethBalance.getConversionRate();

        // Return the balance in USD
        return usdBalance;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // function getPrice() public view returns (uint256) {
    //     //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //     //ABI

    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //         0x694AA1769357215DE4FAC081bf1f309aDC325306
    //     );
    //     //I could have (,int256 price,,,) as I only care about price
    //     (
    //         ,
    //         /*uint80 roundId*/
    //         int256 price, /*uint256 startedAt*/ /*uint256 timestamp*/
    //         ,
    //         ,

    //     ) = /*uint80 answered*/

    //         priceFeed.latestRoundData();
    //     //price --> price of ETH in terms of USD
    //     return uint256(price * 1e10);
    // }

    // function getConversionRate(uint256 ETHAmount)
    //     public
    //     view
    //     returns (uint256)
    // {
    //     uint256 ethPrice = getPrice();
    //     uint256 ethAmountInUSD = (ethPrice * ETHAmount) / 1e18;

    //     return ethAmountInUSD;
    // }

    // function getVersion() public view returns (uint256) {
    //     return
    //         AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
    //             .version();
    // }
}

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        );
        //I could have (,int256 price,,,) as I only care about price
        (
            ,
            /*uint80 roundId*/
            int256 price, /*uint256 startedAt*/ /*uint256 timestamp*/
            ,
            ,

        ) = /*uint80 answered*/

            priceFeed.latestRoundData();
        //price --> price of ETH in terms of USD
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ETHAmount)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ETHAmount) / 1e18;

        return ethAmountInUSD;
    }

    function getVersion() internal view returns (uint256) {
        return
            AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF)
                .version();
    }
}
