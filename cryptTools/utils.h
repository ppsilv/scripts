#ifndef __UTILS_H__
#define __UTILS_H__
#include <inttypes.h>

#define comp_data __DATE__
#define comp_hour __TIME__
#define version "1.0.0"

extern uint64_t key[3];

extern void str2bin(uint8_t * ret,uint8_t * str);
extern void gendKey(uint8_t xc1[], uint8_t xc2[], uint8_t xc3[], uint32_t size);
extern uint64_t tdes_encrypt(uint64_t input);
extern uint64_t tdes_decrypt(uint64_t input);
extern uint32_t get_key_kcv();
extern uint64_t des(uint64_t input, uint64_t key,   char mode);
extern void print(uint8_t xxc1[], uint8_t size);


#endif

