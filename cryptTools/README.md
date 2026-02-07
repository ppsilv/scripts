# The TRIPLE-DES for C code


The 3des code code was grab from someone that I cannot remember, if somebody knows
who is the guy please let me know to give his credit.


This program version can only encrypt/decrypt data with

lenght of 32 bytes ascii or 16 bytes hexadecimal,

it is possible to generate a key from 3 components and

generate its KCV.         

Usage: 3des <command> <options>
  
Example:
  
encrypt \t%s -e --key <key value> --data <data value>
  
decrypt \t%s -d --key <key value> --data <data value>
  
key kcv \t%s -K --key <key value> 
  
generate key \t%s -g --comp1 <comp1 value> --comp2 <comp2 value> --comp3 <comp3 value>

Commands:
-e  -----------> The flag to encrypt data.
  
-d  -----------> The flag to decrypt data.
  
-K  -----------> The flag to generate a key KCV.
  
-g  -----------> The flag to generate a key.
  
-U  -----------> This option shows program usage .
  
-H  -----------> This option shows this help .
  

Options:
-V <value> ------> The value of 100 turn on debug.       
  
--data <value> --> The Data to be encrypted or decrypted.     
  
--key <value> ---> The key to encrypt or decrypt data.       
  
--comp1 <value> -> The component #1 to generate a key. 
  
--comp2 <value> -> The component #2 to generate a key.   
  
--comp3 <value> -> The component #3 to generate a key.           
