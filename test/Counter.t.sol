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
        //owner deploys contract vm.startPrank lets you select the particular address you use to make a call
        vm.startPrank(owner);
        nft = new SoccerNft();
        token = new SoccerERC20();
        vault = new SoccerVault(address(token),address(nft));

        //owner mints nft to self
        nft.mintNFT("soccer", owner);

        //owner approves SoccerVault smart contract to spend nft token
        IERC721(address(nft)).approve(address(vault), 1);

        //owner transfers token to user
        IERC20(address(token)).transfer(user, 1000000);
        vm.stopPrank();

        //vm.startprank means we want to use user address to make the next calls
        vm.startPrank(user);

        // user approves SoccerVault contract to spend erc20 tokens
        IERC20(address(token)).approve(address(vault), 10000000000000);
        vm.stopPrank();
    }

    function test_executebBid() public {
        // you understand vm.startprank now
        vm.startPrank(owner);

        // owner creates listing
        vault.createListing(address(nft), 1, 1000, 80);

        // owner executes listing
        vault.executeListing(1);

        // owner creates bid
        vault.createBid(1);
        vm.stopPrank();

        //we are using user address to make the next call
        vm.startPrank(user);

        // user places bid
        vault.placeBid(1, 100000);
        vm.stopPrank();

        // owner executes bid
        vm.startPrank(owner);
        vault.executeBid(1);

        // owner withdraws funds
        vault.withdrawFunds(1000, 1);
    }
}
