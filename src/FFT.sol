// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title num_complex_solidity
/// @dev COMPLEX MATH FUNCTIONS
/// @author Alexander John Lee
/// @notice Solidity contract offering basic complex number functionalility

import { SD59x18, sd } from "@prb/math/src/SD59x18.sol";
import { UD60x18, ud } from "@prb/math/src/UD60x18.sol";

import "./Trigonometry.sol";

import "./Complex.sol";

contract FastFourierTransform {

    int256 private constant PI = 3141592653589793238;
 

    function reverseBits(uint x, uint n) private pure returns (uint) {
        uint rev = 0;
        for (uint i = 0; i < n; ++i) {
            if ((x & (1 << i)) != 0) {
                rev |= 1 << (n - 1 - i);
            }
        }
        return rev;
    }

    function fft(Num_Complex.Complex[] memory x, uint n) public pure {
        uint log2n = ud(n).log2().unwrap();
        for (uint i = 0; i < n; ++i) {
            uint rev = reverseBits(i, log2n);
            if (i < rev) {
                (x[i], x[rev]) = (x[rev], x[i]);
            }
        }

        for (uint s = 1; s <= log2n; ++s) {
            uint m = 1 << s;
            SD59x18 mTheta = sd(-2 * PI).div(sd(int256(m)));
            Num_Complex.Complex memory wm = Num_Complex.Complex({ re: sd(Trigonometry.cos(uint(mTheta.unwrap()))), im: sd(Trigonometry.sin(uint(mTheta.unwrap()))) });

    for (uint k = 0; k < n; k += m) {
        Num_Complex.Complex memory w = Num_Complex.Complex({
            re: sd(1e18),  // 1.0 in SD59x18 format
            im: sd(0)      // 0.0 in SD59x18 format
        });

        for (uint j = 0; j < m / 2; ++j) {
            Num_Complex.Complex memory t = w.mul(x[k + j + m / 2]);
            Num_Complex.Complex memory u = x[k + j];

            x[k + j] = u.add(t);
            x[k + j + m / 2] = u.sub(t);

            w = w.mul(wm);  // Update the twiddle factor
        }
    }
        }
    }


}