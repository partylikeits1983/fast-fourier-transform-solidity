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

    function log2(uint256 N) internal pure returns (uint256) {
        uint256 k = N;
        uint256 i = 0;
        while (k > 0) {
            k >>= 1;
            i++;
        }
        return i - 1;
    }

    function reverse(uint256 N, uint256 n) internal pure returns (uint256) {
        uint256 j = 0;
        uint256 p = 0;
        for (j = 1; j <= log2(N); j++) {
            if (n & (1 << (log2(N) - j)) > 0) {
                p |= 1 << (j - 1);
            }
        }
        return p;
    }

    function ordina(Num_Complex.Complex[] memory f1, uint256 N) internal pure {
        require(f1.length >= N, "Array length is less than N");

        Num_Complex.Complex[] memory f2 = new Num_Complex.Complex[](N);
        for (uint256 i = 0; i < N; i++) {
            uint256 revIndex = reverse(N, i);
            f2[i] = f1[revIndex];
        }
        for (uint256 j = 0; j < N; j++) {
            f1[j] = f2[j];
        }
    }

    function testBasicFFT() public {
        Num_Complex.Complex[] memory input = new Num_Complex.Complex[](4);
        input[0] = num_complex.wrap(sd(1e18), sd(0)); // 1 + 0i
        input[1] = num_complex.wrap(sd(0), sd(1e18)); // 0 + 1i
        input[2] = num_complex.wrap(sd(-1e18), sd(0)); // -1 + 0i
        input[3] = num_complex.wrap(sd(0), sd(-1e18)); // 0 - 1i

        int sampleStep = 1e18;
        
        Num_Complex.Complex[] memory output = fft.fft(input, 4, sampleStep);

        int256[4] memory expectedRealPart;
        int256[4] memory expectedImaginaryPart;

        expectedRealPart[0] = 0;
        expectedRealPart[1] = 4e18;
        expectedRealPart[2] = 0;
        expectedRealPart[3] = 0;

        expectedImaginaryPart[0] = 0;
        expectedImaginaryPart[1] = 0;
        expectedImaginaryPart[2] = 0;
        expectedImaginaryPart[3] = 0;

        for (uint256 i = 0; i < 4; i++) {
            (SD59x18 re, SD59x18 im) = num_complex.unwrap(output[i]);
            assertEq(re.unwrap(), expectedRealPart[i]);
            assertEq(im.unwrap(), expectedImaginaryPart[i]);
        }
    }
}
