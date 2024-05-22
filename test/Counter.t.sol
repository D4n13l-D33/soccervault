// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SoccerVault} from "../src/vault.sol";
import {SoccerNft} from "../src/Soccernft.sol";
import {SoccerERC20} from "../src/Soccertoken.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CounterTest is Test {
    SoccerVault vault;
    SoccerNft nft;
    SoccerERC20 token;
    address owner = 0x866391DDcBFC0776Bb295699A095D6d26760C733;
    address user = 0xE0597973e8105aC58A9E6652577135dF4e9a5da4;
    
    function setUp() public {
        vm.startPrank(owner);
        nft = new SoccerNft();
        token = new SoccerERC20();
        vault = new SoccerVault(address(token),address(nft));

        nft.mintNFT("soccer", owner);
        IERC721(address(nft)).approve(address(vault), 1);

        IERC20(address(token)).transfer(user, 1000000);
        vm.stopPrank();

        vm.startPrank(user);
        IERC20(address(token)).approve(address(vault), 10000000000000);
        vm.stopPrank();
    }

    function test_executebBid() public {
        vm.startPrank(owner);
        vault.createListing(address(nft), 1, 1000, 80);
        vault.executeListing(1);
        vault.createBid(1);
        vm.stopPrank();

        vm.startPrank(user);
        vault.placeBid(1, 100000);
        vm.stopPrank();

        vm.startPrank(owner);
        vault.executeBid(1);
    }
}
