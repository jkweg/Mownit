#include <stdio.h>
#include <gsl/gsl_ieee_utils.h>

int main() {
    float x = 1.0e-36f;
    
    
    for(int i = 0; i < 15; i++) {
        printf("%-23.15e ", x);
        
        gsl_ieee_printf_float(&x);

        printf("\n");

        x = x / 2.0f; 
    }
    
    return 0;
}