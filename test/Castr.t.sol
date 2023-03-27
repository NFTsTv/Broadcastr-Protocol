// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import {Castr} from "src/upgradeables/Castr.sol";

contract CastrTest is Test {
    Castr castr;

    function setUp() public {
        castr = new Castr();
        castr.initialize("https://example.com", "mariodev", "I dev stuff", false, 3, 1);
    }

    function test_SetUpState() public {
        assertEq(castr.baseTokenURI(), "https://example.com");
        assertEq(castr.CastrName(), "mariodev");
        assertEq(castr.description(), "I dev stuff");
        assertEq(castr.totalSupply(), 3);
        assertEq(castr.mintPrice(), 1);
    }

    function testSetTokenURI() public {
        castr.setTokenURI("https://example2.com");
        assertEq(castr.baseTokenURI(), "https://example2.com");
    }

    function test_RevertIf_NotOwner_SetTokenURI() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(address(1));
        castr.setTokenURI("https://example2.com");
    }

    // TODO: Figure out how to test non-existant tokenURI for some reason it doesn't work
    // function test_RevertIf_DoesntExist_TokenURI() public {
    //     vm.expectRevert("Token URI does not exist");
    //     castr.tokenURI(10);
    // }

    function testMint() public {
        castr.subscribe{value: 1 ether}(address(1));
        assertEq(castr.currentTokenId(), 1);
        assertEq(castr.balanceOf(address(1)), 1);
    }

    function testTokenIdIncrements() public {
        castr.subscribe{value: 1 ether}(address(1));
        castr.subscribe{value: 1 ether}(address(2));
        assertEq(castr.currentTokenId(), 2);
        assertEq(castr.balanceOf(address(1)), 1);
        assertEq(castr.balanceOf(address(2)), 1);
    }

    function test_RevertIf_NotEnoughValue_Mint() public {
        vm.expectRevert();
        vm.prank(address(2));
        castr.subscribe{value: 0.5 ether}(address(2));
    }

    function testMintAsOwner() public {
        castr.subscribe{value: 0 ether}(address(1));
        assertEq(castr.currentTokenId(), 1);
        assertEq(castr.balanceOf(address(1)), 1);
    }

    function testWithdraw() public {
        castr.withdrawPayments(payable(address(1)));
    }

    function test_RevertIf_NotOwner_Withdraw() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(address(1));
        castr.withdrawPayments(payable(address(1)));
    }
}
