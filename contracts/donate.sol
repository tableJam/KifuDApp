// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
contract Donate is Ownable{
    using SafeMath for uint;
    string public name;
    string public url;
    string public discription;
    uint256 public goalAmount;
    address payable public beneficialy;
    uint public sumOfDoneated;
    uint public totalDoneted;
    struct Donation{    
        uint amount;
        uint date;
    }
    mapping(address => Donation[]) private _senderAndamount;


    event changeBeneficialy(address payable indexed oldOne, address payable newOne);
    event DoneDonate(address indexed sender, uint amount);

    constructor(string memory _name, string memory _url,string memory _discription,address payable _beneficialy, address _custodian){
        name = _name;
        url = _url;
        discription = _discription;
        goalAmount = 100;
        beneficialy = _beneficialy;
        transferOwnership(_custodian);
    }

    function setBeneficialy(address payable _newBeneficialy) public onlyOwner{
        emit changeBeneficialy(beneficialy,_newBeneficialy);
        beneficialy = _newBeneficialy;
    }

    function getMyCountOfDonate() public view returns (uint[] memory dates, uint[] memory values) {
        uint len = sumOfDoneated;
        dates = new uint[](len);
        values = new uint[](len);
        for(uint i;i<len;i++) {
            Donation storage curr =  _senderAndamount[msg.sender][i];
            dates[i] = curr.date;
            values[i] = curr.amount;
        }
        return (dates,values);
    }

    function donate() public payable {
        totalDoneted.add(msg.value);
        sumOfDoneated += 1;
        Donation memory newDonation = Donation({
            amount: msg.value,
            date: block.timestamp
        });
        _senderAndamount[msg.sender].push(newDonation);
        emit DoneDonate(msg.sender, msg.value);
    }

    function withdraw() public payable{
        uint balance = address(this).balance;
        beneficialy.transfer(balance);
        totalDoneted = 0;
    }

    fallback() external payable{
        totalDoneted.add(msg.value);
        sumOfDoneated ++;
    }
    receive() external payable{
        totalDoneted.add(msg.value);
        sumOfDoneated ++;
    }
    
}