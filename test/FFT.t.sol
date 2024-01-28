// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Num_Complex} from "../src/Complex.sol";
import {FastFourierTransform} from "../src/FastFourierTransform.sol"; 

import {SD59x18, sd} from "@prb/math/src/SD59x18.sol";

import "forge-std/console.sol";

contract FFTTest is Test {
    Num_Complex public num_complex;
    FastFourierTransform public fft; 

    function setUp() public {
        num_complex = new Num_Complex();
        fft = new FastFourierTransform(); 
    }

    function testFFT() public {
        Num_Complex.Complex[] memory input = new Num_Complex.Complex[](4);
        input[0] = num_complex.wrap(sd(1e18), sd(0)); // 1 + 0i
        input[1] = num_complex.wrap(sd(0), sd(1e18)); // 0 + 1i
        input[2] = num_complex.wrap(sd(-1e18), sd(0)); // -1 + 0i
        input[3] = num_complex.wrap(sd(0), sd(-1e18)); // 0 - 1i
        console.log("HERE");

        Num_Complex.Complex[] memory output = fft.fft(input, 4);
    
        for (uint256 i = 0; i < 4; i++) {
            (SD59x18 re, SD59x18 im) = num_complex.unwrap(output[i]);
            console.log("OUTPUT");
            console.logInt(re.unwrap());
            console.logInt(im.unwrap());

            // Example assertions (you should replace these with actual expected values)
            // assertEq(re.unwrap(), expectedRealPart[i]);
            // assertEq(im.unwrap(), expectedImaginaryPart[i]);
        }
    }

    //  int256[4] expectedRealPart = [/* expected real parts */];
    // int256[4] expectedImaginaryPart = [/* expected imaginary parts */];
}
