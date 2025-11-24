// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Profile} from "../src/Profile.sol";

contract CounterScript is Script {
    Profile public profile;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        profile = new Profile();

        vm.stopBroadcast();
    }
}
