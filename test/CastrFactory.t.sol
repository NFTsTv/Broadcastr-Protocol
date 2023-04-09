// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {CastrFactory} from "src/upgradeables/CastrFactory.sol";
import {Castr} from "src/upgradeables/Castr.sol";

contract CastrFactoryTest is Test {
    CastrFactory castrFactory;
    Castr castr;

    function setUp() public {
        castr = new Castr();
        castrFactory = new CastrFactory(address(castr));
    }

    function test_createCastr() public {
        address newCastr = castrFactory.createCastr("baseTokenURI", "name", "description", false, 1, 1);
        console.log(newCastr.CastrName());
    }
}
