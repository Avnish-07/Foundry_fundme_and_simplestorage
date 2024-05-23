// SPDX-License-Identifier:GPL-3.0
pragma solidity>=0.5.0<0.9.0;
import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {Helperconfig} from "../script/Helperconfig.s.sol";
contract DeployFundMe is Script{
    function run() external returns(FundMe){
        //  if we deploy contract before startbroadcast the its not a  real transaction 
        Helperconfig helperconfig = new Helperconfig();
        address pricefeedaddress= helperconfig.ActiveNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe= new FundMe(pricefeedaddress);
        vm.stopBroadcast();
        return fundMe;
    }

}