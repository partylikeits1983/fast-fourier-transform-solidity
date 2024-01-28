// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title num_complex_solidity
/// @dev COMPLEX MATH FUNCTIONS
/// @author Alexander John Lee
/// @notice Solidity contract offering basic complex number functionalility

import {SD59x18, sd} from "@prb/math/src/SD59x18.sol";
import {UD60x18, ud} from "@prb/math/src/UD60x18.sol";

import "./Trigonometry.sol";

import "./Complex.sol";

import "forge-std/console.sol";

contract FastFourierTransform {
    Num_Complex num_complex;

    int256 private constant PI = 3141592653589793238;

    function reverseBits(uint256 x, uint256 n) private pure returns (uint256) {
        uint256 rev = 0;
        for (uint256 i = 0; i < n; ++i) {
            if ((x & (1 << i)) != 0) {
                rev |= 1 << (n - 1 - i);
            }
        }
        return rev;
    }

    function fft(Num_Complex.Complex[] memory x, uint256 n) public view returns (Num_Complex.Complex[] memory) {
        uint256 log2n = ud(n * 1e18).log2().unwrap() / 1e18;

         for (uint256 i = 0; i < n; ++i) {
            uint256 rev = reverseBits(i, log2n);
            if (i < rev) {
                (x[i], x[rev]) = (x[rev], x[i]);
            }
        }

         for (uint256 s = 1; s <= log2n; ++s) {
            uint256 m = 1 << s;
            SD59x18 mTheta = sd(-2 * PI).div(sd(int256(m)));
            Num_Complex.Complex memory wm = Num_Complex.Complex({
                re: sd(Trigonometry.cos(uint256(mTheta.unwrap()))),
                im: sd(Trigonometry.sin(uint256(mTheta.unwrap())))
            });

             for (uint256 k = 0; k < n; k += m) {
                Num_Complex.Complex memory w = Num_Complex.Complex({re: sd(1e18), im: sd(0)});

                for (uint256 j = 0; j < (ud(m).div(ud(2e18)).unwrap() / 1e18); ++j) {
                    Num_Complex.Complex memory t = num_complex.mul(w, x[k + j + m / 2]);
                    Num_Complex.Complex memory u = x[k + j];

                    x[k + j] = num_complex.add(u, t);
                    x[k + j + m / 2] = num_complex.sub(u, t);

                    w = num_complex.mul(w, wm);
                }
            }
        }
        return x;
    }
}
