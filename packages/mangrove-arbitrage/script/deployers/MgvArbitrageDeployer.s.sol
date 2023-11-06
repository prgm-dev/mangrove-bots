// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {Deployer} from "@mgv/script/lib/Deployer.sol";
import {MgvArbitrage} from "@mgv/arbitrage/src/MgvArbitrage.sol";
import {IMangrove} from "@mgv/src/IMangrove.sol";

contract MgvArbitrageDeployer is Deployer {
  MgvArbitrage public mgvArb;

  function run() public {
    innerRun({admin: envAddressOrName("CHIEF", broadcaster()), mgv: envAddressOrName("MGV", "Mangrove")});
    outputDeployment();
  }

  function innerRun(address admin, address mgv) public {
    broadcast();
    mgvArb = new MgvArbitrage(IMangrove(payable(mgv)), admin);
    fork.set("MgvArbitrage", address(mgvArb));
    smokeTest(admin, mgv);
  }

  function smokeTest(address admin, address mgv) public view {
    require(mgvArb.admin() == admin, "Wrong admin address");
    require(address(mgvArb.mgv()) == mgv, "Wrong mgv address");
    require(fork.get("MgvArbitrage") != address(0), "MgvArbitrage address not set");
    require(fork.get("MgvArbitrage") == address(mgvArb), "MgvArbitrage address not correct");
  }
}
