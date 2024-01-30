# Fast Fourier Transform in Solidity

## Description

This repository presents an implementation of the Fast Fourier Transform (FFT) algorithm written in Solidity, a crucial algorithm in the realm of digital signal processing.

The motivation behind creating this repository emerged from the desire to perform on-chain analysis of Uniswap TWAP (Time-Weighted Average Price) data using the FFT algorithm.


## Features

- **Efficient FFT Algorithm**: Optimized for minimal gas consumption in Ethereum smart contracts.

## Usage



### Test

```shell
forge test --match-contract FFTTest -vv
```

Running Basic FFT in C++
```shell
clang++ -o fft cpp/fft.cpp
./fmt
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

