#include <iostream>
#include <string.h>

// RDI, RSI, RDX (System V AMD64 ABI)
extern "C"
{
    void copy(char *dest, char *src, int len);
}

size_t asmstrlen(const char *str)
{
    size_t len;
    asm("mov RDI, %1\n"
        "mov RCX, -1\n" // переполняем rcx чтобы повторял до флага(по факту до бесконечности)
        "xor AL, AL\n" // 0 - код '\0'
        "REPNZ SCASB\n"
        "mov RAX, -1\n"
        "sub RAX, RCX\n" // RCX уменьшилось на кол-во байт в строке
        "dec RAX\n" // вычли лишний посчитанный нулевой терминатор
        "mov %0, RAX\n"
        : "=r"(len)
        : "r"(str)
        : "%rax", "%rdi", "%rcx");

    return len;
}

int main(void)
{
    char str[100];
    strcpy(str, "123456789");

    size_t len = asmstrlen(str);

    std::cout << "Len is: " << len << std::endl;

    char str2[100];
    strcpy(str2, "abc");

    copy(str + 2, str, 3);

    std::cout << "Destionation > source: " << str << std::endl;

    strcpy(str, "123456789");
    copy(str, str + 2, 3);

    std::cout << "Destination < source: " << str << std::endl;

    strcpy(str2, "123456789");
    copy(str, str2, 3);

    std::cout << "Destionation doesnt cross source: " << str << std::endl;
    return len;
}
