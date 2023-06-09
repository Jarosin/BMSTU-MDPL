#include "measure.h"

#define N 100000

using namespace std;

typedef void (*float_funk)(float, float);
typedef void (*double_funk)(double, double);

long measure_float_funk(float a, float b, float_funk f);
long measure_double_funk(double a, double b, double_funk  f);

void sin_measure(float pi);

void measure_arif()
{
    float fa = 2, fb = 3;
    double da = 2, db = 3;

    cout << "Sum" << endl;
    cout << "float:" << "\tcpp: " << measure_float_funk(fa, fb, float_sum_cpp) << "\t asm: " << measure_float_funk(fa, fb, float_sum_ams) << endl;
    cout << "double:" << "\tcpp: " << measure_double_funk(da, db, double_sum_cpp) << "\t asm: " << measure_double_funk(da, db, double_sum_ams) << endl;
    cout << endl;

    cout << "Mult" << endl;
    cout << "float:" << "\tcpp: " << measure_float_funk(fa, fb, float_mult_cpp) << "\t asm: " << measure_float_funk(fa, fb, float_mult_ams) << endl;
    cout << "double:" << "\tcpp: " << measure_double_funk(da, db, double_mult_cpp) << "\t asm: " << measure_double_funk(da, db, double_mult_ams) << endl;
    cout << endl << endl;
}

void measure_sin()
{
    float pi_1 = 3.14, pi_2 = 3.141596;
    float a = 2, result = 0;

    cout << "sin(pi)" << endl;
    sin_measure(pi_1);
    sin_measure(pi_2);

    asm("fldpi\n"
        "fstps %0\n"
            : "=m"(result)
            );
    sin_measure(result);
    cout << endl;

    cout << "sin(pi/2)" << endl;
    sin_measure(pi_1 / 2.0);
    sin_measure(pi_2 / 2.0);

    a = 2.0;
    asm("flds %1\n"
        "fldpi\n"
        "fdivp\n"
        "fstps %0\n"
            : "=m"(result)
            : "m"(a)
            );
    sin_measure(result);
    cout << endl;
}

long measure_float_funk(float a, float b, float_funk f)
{
    struct timeval start, end;
    gettimeofday(&start, nullptr);
    for (size_t i = 0; i < N; i++) f(a, b);
    gettimeofday(&end, nullptr);
    return end.tv_usec - start.tv_usec;
}

long measure_double_funk(double a, double b, double_funk f)
{
    struct timeval start, end;
    gettimeofday(&start, nullptr);
    for (size_t i = 0; i < N; i++) f(a, b);
    gettimeofday(&end, nullptr);
    return end.tv_usec - start.tv_usec;
}


void sin_measure(float pi)
{
    cout << "pi = " << pi << endl;
    cout << "cpp: " << sin_cpp(pi) << "\tasm: " << sin_asm(pi) << endl;
}
