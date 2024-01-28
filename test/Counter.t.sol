// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Num_Complex} from "../src/Complex.sol";

import { SD59x18, sd } from "@prb/math/src/SD59x18.sol";

contract CounterTest is Test {
    Num_Complex public num_complex;

    function setUp() public {
        num_complex = new Num_Complex();
    }

    function test_add() public {
        SD59x18 n1re = sd(1e18);
        SD59x18 n1im = sd(1e18);

        SD59x18 n2re = sd(1e18);
        SD59x18 n2im = sd(1e18);

        Num_Complex.Complex memory n1 = num_complex.wrap(n1re, n1im);
        Num_Complex.Complex memory n2 = num_complex.wrap(n2re, n2im);

        Num_Complex.Complex memory result = num_complex.add(n1, n2);

        (SD59x18 resRE, SD59x18 resIM) = num_complex.unwrap(result);
        assertEq(resRE.unwrap(), 2e18);
        assertEq(resIM.unwrap(), 2e18);

    }

    function test_sub() public {
        SD59x18 n1re = sd(1e18);
        SD59x18 n1im = sd(1e18);

        SD59x18 n2re = sd(1e18);
        SD59x18 n2im = sd(1e18);

        Num_Complex.Complex memory n1 = num_complex.wrap(n1re, n1im);
        Num_Complex.Complex memory n2 = num_complex.wrap(n2re, n2im);

        Num_Complex.Complex memory result = num_complex.sub(n1, n2);

        (SD59x18 resRE, SD59x18 resIM) = num_complex.unwrap(result);
        assertEq(resRE.unwrap(), 0);
        assertEq(resIM.unwrap(), 0);
    }

    function test_mul() public {
        SD59x18 n1re = sd(2e18);
        SD59x18 n1im = sd(2e18);

        SD59x18 n2re = sd(2e18);
        SD59x18 n2im = sd(2e18);

        Num_Complex.Complex memory n1 = num_complex.wrap(n1re, n1im);
        Num_Complex.Complex memory n2 = num_complex.wrap(n2re, n2im);

        Num_Complex.Complex memory result = num_complex.mul(n1, n2);

        (SD59x18 resRE, SD59x18 resIM) = num_complex.unwrap(result);
        assertEq(resRE.unwrap(), 0);
        assertEq(resIM.unwrap(), 8e18);
    }

    function test_div() public {
        SD59x18 n1re = sd(2e18);
        SD59x18 n1im = sd(2e18);

        SD59x18 n2re = sd(2e18);
        SD59x18 n2im = sd(2e18);

        Num_Complex.Complex memory n1 = num_complex.wrap(n1re, n1im);
        Num_Complex.Complex memory n2 = num_complex.wrap(n2re, n2im);

        Num_Complex.Complex memory result = num_complex.div(n1, n2);

        (SD59x18 resRE, SD59x18 resIM) = num_complex.unwrap(result);
        assertEq(resRE.unwrap(), 1e18);
        assertEq(resIM.unwrap(), 2e18);
    }

    function test_sqrt() public {
        SD59x18 n1re = sd(2e18);
        SD59x18 n1im = sd(2e18);

        Num_Complex.Complex memory n1 = num_complex.wrap(n1re, n1im);

        Num_Complex.Complex memory result = num_complex.sqrt(n1);

        (SD59x18 resRE, SD59x18 resIM) = num_complex.unwrap(result);
        assertEq(resRE.unwrap(), 1e18);
        assertEq(resIM.unwrap(), 2e18);
    }


    function testFuzz_SetNumber(uint256 x) public {
        // num_complex.setNumber(x);
        // assertEq(num_complex.number(), x);
    }
}
