#include <iostream>
#include <sys/time.h>

#define N 1000000

using namespace std;

float scalar_mult_cpp(float *vec1, float *vec2, int n)
{
    float res = 0;
    for (int i = 0; i < n / 4; i++) res += vec1[i] * vec2[i];
}

float scalar_mult_asm(float *vec1, float *vec2, int n)
{
    float res = 0;
    n /= 4;
    __asm__
            (
            "pxor %%xmm0, %%xmm0\n"
            "mult:\n"
            "movups (%%rsi), %%xmm1\n"
            "movups (%%rdi), %%xmm2\n"
            "mulps %%xmm2, %%xmm1\n"
            "haddps %%xmm1, %%xmm1\n"
            "haddps %%xmm1, %%xmm1\n"
            "addps %%xmm1, %%xmm0\n"
            "add $0x10,%%rsi\n"
            "add $0x10,%%rdi\n"
            "loop mult\n"
            :"=Yz"(res)
            :"S"(vec1), "D"(vec2), "c"(n)
            );
    return res;
}

int main()
{
    float arr1[] = { 1, 2, 3, 4, 1, 2, 3, 4 }, arr2[] = { 5, 6, 7, 8, 5, 6, 7, 8 };
    struct timeval start, end;
    float res = 0;

    gettimeofday(&start, nullptr);
    for (size_t i = 0; i < N; i++) res = scalar_mult_asm(arr1, arr2, 8);
    gettimeofday(&end, nullptr);
    cout << "asm: " << end.tv_usec - start.tv_usec << " usec" << endl;

    gettimeofday(&start, nullptr);
    for (size_t i = 0; i < N; i++) res = scalar_mult_cpp(arr1, arr2, 8);
    gettimeofday(&end, nullptr);
    cout << "cpp: " << end.tv_usec - start.tv_usec << " usec" << endl;

    return 0;
}
