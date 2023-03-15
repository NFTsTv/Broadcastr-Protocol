// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import {CastrFactory} from "src/CastrFactory.sol";

contract CastrFactoryTest is Test {
    CastrFactory factory;

    function setUp() public {
        factory = new CastrFactory();
    }
}
