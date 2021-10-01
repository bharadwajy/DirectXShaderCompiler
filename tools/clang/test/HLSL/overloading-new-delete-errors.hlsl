// RUN: %clang_cc1 -fsyntax-only -Wno-unused-value -ffreestanding -verify -enable-operator-overloading %s
// RUN: %clang_cc1 -fsyntax-only -Wno-unused-value -ffreestanding -verify -HV 2021 %s

// This test checks that when we overload new or delete operator
// dxcompiler generates error and no crashes are observed.

struct S
{
    float foo;
    void * operator new(int size) { // expected-error {{overloading 'operator new' is not allowed}} expected-error {{pointers are unsupported in HLSL}}
        return (void *)0; // expected-error {{pointers are unsupported in HLSL}} expected-error {{cannot convert from 'literal int' to 'void *'}} expected-warning {{'operator new' should not return a null pointer unless it is declared 'throw()'}}
    }
    void operator delete(void *ptr) { // expected-error {{overloading 'operator delete' is not allowed}} expected-error {{pointers are unsupported in HLSL}}
        (void) ptr;
    }
};

void main() {
    S *a = new S(); // expected-error {{'new' is a reserved keyword in HLSL}} expected-error {{pointers are unsupported in HLSL}}
    delete a; // expected-error {{'delete' is a reserved keyword in HLSL}}
}