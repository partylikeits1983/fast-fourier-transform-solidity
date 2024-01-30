#include <complex>
#include <iostream>
#define MAX 200

using namespace std;

#define M_PI 3.1415926535897932384

int log2(int N) {
  int k = N, i = 0;
  while (k) {
    k >>= 1;
    i++;
  }
  return i - 1;
}

int reverse(int N, int n) {
  int j, p = 0;
  for (j = 1; j <= log2(N); j++) {
    if (n & (1 << (log2(N) - j)))
      p |= 1 << (j - 1);
  }
  return p;
}

void ordina(complex<double> *f1, int N) {
  complex<double> f2[MAX];
  for (int i = 0; i < N; i++)
    f2[i] = f1[reverse(N, i)];
  for (int j = 0; j < N; j++)
    f1[j] = f2[j];
}

void transform(complex<double> *f, int N) {
  ordina(f, N);
  complex<double> *W =
      (complex<double> *)malloc(N / 2 * sizeof(complex<double>));
  W[1] = polar(1., -2. * M_PI / N);
  W[0] = 1;

  for (int i = 2; i < N / 2; i++) {
    W[i] = pow(W[1], i);
  }

  int n = 1;
  int a = N / 2;

  for (int j = 0; j < log2(N); j++) {
    for (int i = 0; i < N; i++) {
      if (!(i & n)) {
        complex<double> temp = f[i];
        complex<double> Temp = W[(i * a) % (n * a)] * f[i + n];

        f[i] = temp + Temp;
        f[i + n] = temp - Temp;
      }
    }
    n *= 2;
    a = a / 2;
  }
  free(W);
}

void FFT(complex<double> *f, int N, double d) {
  transform(f, N);
  for (int i = 0; i < N; i++)
    f[i] *= d;
}

int main() {
  // Hardcoded array of complex numbers
  std::complex<double> vec[] = {
      std::complex<double>(1, 0),  // 1 + 0i
      std::complex<double>(0, 1),  // 0 + 1i
      std::complex<double>(-1, 0), // -1 + 0i
      std::complex<double>(0, -1)  // 0 - 1i
  };

  int n = sizeof(vec) / sizeof(vec[0]);
  double d = 1; // Sampling step

  FFT(vec, n, d);
  cout << "FFT Result" << endl;
  for (int j = 0; j < n; j++)
    cout << vec[j] << endl;

  return 0;
}
