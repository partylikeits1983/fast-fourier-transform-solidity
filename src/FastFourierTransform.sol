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

contract FastFourierTransform is Num_Complex {
    int256 private constant PI = 3141592653589793238;

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

    function transform(Num_Complex.Complex[] memory f, uint256 N)
        internal
        view
        returns (Num_Complex.Complex[] memory)
    {
        ordina(f, N);

        Num_Complex.Complex[] memory W = new Num_Complex.Complex[](N / 2);

        // Using fromPolar to initialize W[1] with polar coordinates
        {
            SD59x18 r = sd(1e18); // Radius = 1
            SD59x18 T = sd(PI * -2).div(sd(int256(N) * 1e18)); // Angle = -2 * PI / N

            W[1] = fromPolar(r, T);
        }

        W[0] = Num_Complex.Complex({re: sd(1e18), im: sd(0)});

        for (uint256 i = 2; i < N / 2; i++) {
            console.log("HERE");
            console.logInt(W[1].re.unwrap());
            console.logInt(W[1].im.unwrap());

            console.logInt(int256(i * 1e18));

            W[i] = pow(W[1], sd(int256(i * 1e18)));
        }

        uint256 n = 1;
        uint256 a = N / 2;

        for (uint256 j = 0; j < log2(N); j++) {
            for (uint256 i = 0; i < N; i++) {
                if ((i & n) == 0) {
                    Num_Complex.Complex memory temp = f[i];
                    Num_Complex.Complex memory Temp = mul(W[(i * a) % (n * a)], f[i + n]);

                    f[i] = add(temp, Temp); // Update with return value
                    f[i + n] = sub(temp, Temp); // Update with return value
                }
            }
            n *= 2;
            a /= 2;
        }

        return f;
    }

    function fft(Num_Complex.Complex[] memory f, uint256 N, int256 d)
        public
        view
        returns (Num_Complex.Complex[] memory)
    {
        f = transform(f, N);

        for (uint256 i = 0; i < N; i++) {
            f[i].re = f[i].re.mul(sd(d));
            f[i].im = f[i].im.mul(sd(d));
        }
        return f;
    }
}
