// SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
import {Test,console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test{

   address USER =makeAddr("user");

    FundMe fundMe;

    modifier funded(){
      vm.prank(USER);
      fundMe.fund{value:1e18}();_;
    }
 function setUp() external{
  DeployFundMe deployfundme= new DeployFundMe();
  fundMe = deployfundme.run();
  vm.deal(USER, 1000 ether);
 }

  function testPriceFeedVersionIsAccurate() public view {
    uint256 version = fundMe.getVersion();
    console.log(version);
    assertEq(version, 4);
 }

 function testMINIMUM_USD() public view{
  assertEq(fundMe.MINIMUM_USD(),5e18);
 }

 function test_i_owner() public view{
    console.log(msg.sender);
    console.log(fundMe.i_owner());
    console.log(address(this));
    assertEq(fundMe.i_owner(), msg.sender/*msg.sender*/);
    // The fundMe contract is deployed by FundMeTest so FundMeTest is owner of the the contract fundMe and msg.sender is that address which is calling the function 
 }

 function testminethfails() public{
   vm.expectRevert();
   fundMe.fund();
 }

 function testfunddatastructuresupdated() public funded{   //using modifier
   // vm.prank(USER);// NEXT TRANSACTION IS DONE BY USER ADDRESS
   // fundMe.fund{value: 1e18}();
   uint amountfunded= fundMe.getamountwithaddress(/*address(this)*/USER);
   assertEq(amountfunded, 1e18);
 }

 function testfunderaddedtoarray() public funded{
   // vm.prank(USER);
   // fundMe.fund{value :1e18}();
   address funder=fundMe.getfunder(0);
   assertEq(USER, funder);
 }

 function testonlyownercanwithdraw() public funded{
   // vm.prank(USER);// NEXT TRANSACTION IS DONE BY USER ADDRESS
   // fundMe.fund{value: 1e18}();
   vm.expectRevert();
   vm.prank(USER);
   fundMe.withdraw();
 }

 function testwithdraw() public funded{
   // Arrange --> Act -->Assert
   // Arrange 
   uint starting_owner_balance= fundMe.i_owner().balance;
   uint starting_fundme_balance= address(fundMe).balance;
   // Act
   vm.prank(fundMe.i_owner());
   fundMe.withdraw();
   // Assert
   uint ending_owner_balance= fundMe.i_owner().balance;
   uint ending_fundme_balance= address(fundMe).balance; 
   assertEq(ending_fundme_balance,0);
   assertEq(starting_owner_balance+starting_fundme_balance,ending_owner_balance);
 }






}