#!/bin/bash

CPROG="32_or_64bit_test.c"

# Define the C program and save it to a file
cat <<EOF > $CPROG
#include <stdio.h>

int main() {
    // Check if the machine is capable of running 64-bit code
    #ifdef __x86_64__
        printf("This machine supports 64-bit code.\\n");
    #else
        printf("This machine does not support 64-bit code.\\n");
    #endif

    return 0;
}
EOF

# Compile 32-bit version
gcc -m32 -o 32bit_test $CPROG -arch i386 2>/dev/null

if [ $? -eq 0 ]; then
  echo "Executing 32bit_test"
  ./32bit_test
  MESSAGE="32"
else
  echo "Error compiling $CPROG using -m32 bit option.. trying the 64 bit test"
fi

# Compile 64-bit version
gcc -o 64bit_test $CPROG -arch x86_64 2>/dev/null

if [ $? -eq 0 ]; then
  echo "Executing 64bit_test"
  ./64bit_test
  MESSAGE="${MESSAGE} 64"
else
  echo "Error compiling ${CPROG}"
fi

echo "Done compiling .. supports ${MESSAGE}"
