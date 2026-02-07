#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "utils.h"

static kcv_create_flag = 0;

static uint8_t char2bin(uint8_t  ch)
{
    if( ( ch >= 0x30 ) && ( ch <= 0x39 ) ){
        return(ch - 0x30);
    }
    switch(ch){
        case 'A':
        case 'a':
            return(10);
        case 'B':
        case 'b':
            return(11);
        case 'C':
        case 'c':
            return(12);
        case 'D':
        case 'd':
            return(13);
        case 'E':
        case 'e':
            return(14);
        case 'F':
        case 'f':
            return(15);
    }
}

void str2bin(uint8_t * ret,uint8_t * str)
{
    uint32_t i,j;
    
    for(i = 0,j=0; i < strlen(str) ; i+=2,j++){
        *(ret+j) = ( (char2bin(*(str+i))) << 4) | ( (char2bin(*(str+i+1))) & 0x0F );
    }
}

void gendKey(uint8_t xc1[], uint8_t xc2[], uint8_t xc3[], uint32_t size)        
{
    uint32_t i;
    uint8_t by1,by2,by3;
    uint8_t result[16];
    for(i = 0; i < size; i++){
        by1 = xc1[i];        
        by2 = xc2[i];        
        by3 = xc3[i];
        result[i] =  (by1 ^ by2 ^ by3);               
    }
    print(result,16);
}       

uint64_t tdes_encrypt(uint64_t input)
{
    uint64_t result = input;
    if( (input == 0) && (kcv_create_flag == 0) ) return 0;
    result = des(result, key[0], 'e');
    result = des(result, key[1], 'd');
    result = des(result, key[2], 'e');
    if( kcv_create_flag == 0 )
        printf("%llx",result);
    return result;
}

uint64_t tdes_decrypt(uint64_t input)
{
    uint64_t result = input;
    if( (input == 0)  ) return 0;
    result = des(result, key[2], 'd');
    result = des(result, key[1], 'e');
    result = des(result, key[0], 'd');
    
    printf("%llx",result);
    return result;
}

uint32_t get_key_kcv()
{
    uint64_t result,input = 0x0000000000000000;
    uint32_t halfresult;
    kcv_create_flag = 1;
    result = tdes_encrypt(input);
    halfresult = result >> 40;    
    printf ("key kcv: %06x\n", halfresult);
    kcv_create_flag = 0;
 
}
 
void print(uint8_t xxc1[], uint8_t size)
{
uint32_t i;
    for(i=0; i < size; i++){
        printf("%02X",xxc1[i]);
    }
    printf("\n");

}



