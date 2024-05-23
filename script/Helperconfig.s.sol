// Deploy mocks when we are on local anvil chain
// keep track contract addresses on different chains
// Example -:
// SEPOLIA ETH/USD
// MAINNET ETH/USD,etc.

// SPDX-License-Identifier:GPL-3.0
pragma solidity>=0.5.0<0.9.0;
import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/mockV3Aggregator.sol";
contract Helperconfig is Script{



 struct Networkconfig{
    address pricefeed;
 }

 uint8 public constant DECIMALS=8;
 int256 public constant INITIAL_PRICE=10e8;

 Networkconfig public ActiveNetworkConfig;

 constructor(){
    if(block.chainid==11155111){
        ActiveNetworkConfig=getsepoliaethconfig();
    }
    else{
       ActiveNetworkConfig=getanvilethconfig();
    }
 }


 function getsepoliaethconfig() public pure returns(Networkconfig memory){
    Networkconfig memory sepoliaethconfig= Networkconfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    return sepoliaethconfig;
 }
 function getmainnetethconfig() public pure returns(Networkconfig memory){
    Networkconfig memory mainnetethconfig= Networkconfig(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    return mainnetethconfig;
 }

 function getanvilethconfig() public returns(Networkconfig memory){
    // deploy the mock(dummy contract) and returns its address
    if(ActiveNetworkConfig.pricefeed!=address(0)){
        return ActiveNetworkConfig;
    }
    vm.startBroadcast();
    MockV3Aggregator mockpricefeed= new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
    vm.stopBroadcast();
    Networkconfig memory anvilethconfig= Networkconfig(address(mockpricefeed));
    return anvilethconfig;
 }
}