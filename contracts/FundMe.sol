//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "./PriceConverter.sol";

error FundMe__NotOwner();

/** @title A contract for crowd funding
 *  @author Sudipto Naskar
 * @notice This is a demo sample contract for learning
 * @dev This implements price feed as our library
*/
contract FundMe {
    // Type Declaration
    using PriceConverter for uint256;
    
    // State Variables
    uint256 public constant MIN_USD = 50 * 1e18;
    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;
    address private immutable i_owner;    
    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    constructor(address s_priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(s_priceFeedAddress);
    }

    // receive() external payable {
    //     fund();
    // }

    // fallback() external payable {
    //     fund();
    // }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MIN_USD, "Didn't send enough");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner() {
        /*starting index, ending index, step amount */
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Transfer Failed");
        
    }

    function cheaperWithdraw() public payable onlyOwner{
        address[] memory funders = s_funders;
        // mappings can't be in memory, sorry!
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
                s_funders = new address[](0);

        (bool success, ) = i_owner.call{
            value: address(this).balance
        }("");
        require(success, "Transfer Failed");
    }
    function getOwner() public view returns(address ) {
        return i_owner;
    }
    function getFunders(uint256 index) public view returns(address) {
        return s_funders[index];
    }
    function getAddressToAmountFunded(address funder)public view returns(uint256) {
        return s_addressToAmountFunded[funder];
    }
    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
    }
