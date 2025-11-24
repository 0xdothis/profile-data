// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Profile} from "../src/Profile.sol";

contract CounterTest is Test {
    Profile public profile;

    function setUp() public {
        profile = new Profile();
    }

    function test_updateProfileIfDifferent_behavior() public {
        profile.setProfile("Sam", 20);
        bool res1 = profile.updateProfileIfDifferent("Sam", 20);
        bool res2 = profile.updateProfileIfDifferent("Peace", 20);
        bool res3 = profile.updateProfileIfDifferent("John", 25);

        assertEq(res1, false);
        assertEq(res2, true);

        assertEq(res3, true);
    }
}
