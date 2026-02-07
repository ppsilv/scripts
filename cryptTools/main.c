#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "utils.h" 
#include <unistd.h>
#include <getopt.h>

#define DEBUG 100                                                      


void banner()
{
	printf("                                                                   -----        \n");
	printf("*****  ****   *****  *** *     *   *  *****     *****  *****  ****   *****  ***** \n");
	printf("*   *  *   *  *       *  *     *   *  *   *     *      *   *  *   *  *   *  *   * \n");
	printf("*   *  *   *  *       *  *     *   *  *   *     *      *   *  *   *  *   *  *   * \n");
	printf("*****  *   *  *****   *  *     *   *  *****     ****   *   *  *   *  *****  *   * \n");
	printf("*      *   *      *   *  *     *   *  *   *     *      *   *  *   *  *   *  *   * \n");
	printf("*      *   *      *   *  *     *   *  *   *     *      *   *  *   *  *   *  *   * \n");
	printf("*      ****   *****  *** *****  ***   *   *     *      *****  ****   *   *  ***** \n");
	printf("\n\n");
	printf("                          *****      *  *****              \n");
	printf("                          *         *   *        *     *   \n");
	printf("                          *        *    *        *     *   \n");
	printf("                          *        *    *      ***** ***** \n");
	printf("                          *        *    *        *     *   \n");
	printf("                          *       *     *        *     *   \n");
	printf("                          *****  *      *****              \n");
	printf("\n\n");
}

void _usage(uint8_t * arg)
{
	printf("\n\n\n\n\n\n\n\n\n\n");
	banner();
    printf("Usage: %s <options> \n",arg);
}
void usage(uint8_t * arg)
{
	_usage(arg);
    printf("Options: \n");
    printf("-e = Encrypt data\n");    
    printf("-d = Decrypt data\n");    
    printf("-D value = Data to be encrypt/decrypt\n");    
    printf("-c = Calculate key kcv\n");
    printf("-k value = Key to encrypt/decrypt\n");
    printf("-g = Generate a key from componentes\n");
    printf("--compX value = X is the component number\n"); 
    exit(0);
}

static int Verbose = 0; 
static int verbose_flag=0;
static int encrypt_flag=0;
static int decrypt_flag=0;
static int kcv_flag=0;
static int keygen_flag=0;
static uint64_t data[2]={0,0};
uint64_t key[3] ={0,0,0}; //{0x853f31351e51cd9c, 0x5222c28e408bf2a3, 0x853f31351e51cd9c};
static uint8_t comp1[16]={0};
static uint8_t comp2[16]={0};
static uint8_t comp3[16]={0};


void help(uint8_t *opt)
{
    if( strlen(opt) == 0 ){
        printf("Version %s %s %s\n",version,comp_data,comp_hour);
        printf("This program version can only encrypt/decrypt data with\n");
        printf("lenght of 32 bytes ascii or 16 bytes hexadecimal,\n");
        printf("it is possible to generate a key from 3 components and\n");
        printf("generate its KCV.\n");          
    }else{
        _usage(opt);
        printf("Example:\n");
        printf("\t encrypt \t%s -e --key <key value> --data <data value>\n",opt);
        printf("\t decrypt \t%s -d --key <key value> --data <data value>\n",opt);
        printf("\t key kcv \t%s -K --key <key value> \n",opt);
        printf("\t generate key \t%s -g --comp1 <comp1 value> --comp2 <comp2 value> --comp3 <comp3 value>\n",opt);
    }
    printf("\nCommands:\n");
    printf("-e  -----------> The flag to encrypt data.\n");
    printf("-d  -----------> The flag to decrypt data.\n");
    printf("-K  -----------> The flag to generate a key KCV.\n");
    printf("-g  -----------> The flag to generate a key.\n");
    printf("-U  -----------> This option shows program usage .\n");
    printf("-H  -----------> This option shows this help .\n");
    printf("\nOptions:\n");
    printf("-V <value> ----> The value of 100 turn on debug.\n");           
    printf("--data <value> --> The Data to be encrypted or decrypted.\n");           
    printf("--key <value> ---> The key to encrypt or decrypt data.\n");           
    printf("--comp1 <value> -> The component #1 to generate a key.\n");           
    printf("--comp2 <value> -> The component #2 to generate a key.\n");           
    printf("--comp3 <value> -> The component #3 to generate a key.\n");           
          
}


int threat_args(int argc, const char * argv[])
{
    char str[2]={0};
    if( argc == 1){
        help(argv[0]);
        exit(1);
    }
    while (1){
      static struct option long_options[] =
        {
          /* These options set a flag. */
          {"verbose", no_argument,   &verbose_flag, 1},
          {"e",   no_argument,       &encrypt_flag, 1},
          {"d",   no_argument,       &decrypt_flag, 1},
          {"K",   no_argument,       &kcv_flag, 1},
          {"g",   no_argument,       &keygen_flag, 1},
          /* These options don’t set a flag.We distinguish them by their indices. */
          {"U",   no_argument,       0, 'U'},
          {"H",   no_argument,       0, 'H'},
          {"V",      required_argument, 0, 'V'},
          {"data",   required_argument, 0, 'D'},
          {"key",    required_argument, 0, 'k'},
          {"comp1",  required_argument, 0, '1'},
          {"comp2",  required_argument, 0, '2'},
          {"comp3",  required_argument, 0, '3'},
          {0, 0, 0, 0}
        };
      /* getopt_long stores the option index here. */
      int option_index = 0,c;

      c = getopt_long (argc, (char * const*)argv, "edKgHUD:k:1:2:3:V:", long_options, &option_index);

      /* Detect the end of the options. */
      if (c == -1)
        break;

      switch (c)
        {
        case 0:
          /* If this option set a flag, do nothing else now. */
          if (long_options[option_index].flag != 0)
            break;
          if ( Verbose == DEBUG) printf ("option %s", long_options[option_index].name);
          if (optarg)
            if ( Verbose == DEBUG) printf (" with arg %s", optarg);
          if ( Verbose == DEBUG) printf ("\n");
          break;
        case 'U':
            help(argv[0]);
            break;
        case 'H':
            help(str);
            break;
        case 'e':
          if ( Verbose == DEBUG) puts ("option -e\n");
          encrypt_flag = 1;
          break;

        case 'd':
          if ( Verbose == DEBUG) puts ("option -d\n");
          decrypt_flag = 1;
          break;

        case 'K':
          if ( Verbose == DEBUG) puts ("option -K\n");
          kcv_flag = 1;
          break;

        case 'g':
          if ( Verbose == DEBUG) puts ("option -g\n");
          keygen_flag = 1;
          break;

        case 'V':
            Verbose = atoi (optarg);
            break;
        case 'D':{
            uint8_t ckey[32+1];
            if ( Verbose == DEBUG) printf ("option -D with value `%s'\n", optarg);
            if( strlen(optarg) > 32 ){
                printf("Data lenght is so huge...\n");
                exit(1);
            }
            if( strlen(optarg) > 16 ){
                memcpy(ckey,&optarg[16],16);
                ckey[16] = '\0';
                data[1] = strtoull(ckey, NULL, 16);
                //printf("Data[2] %llx\n",key[1]);
            }
            memcpy(ckey,optarg,16);
            ckey[16] = '\0';
            data[0] = strtoull(ckey, NULL, 16);
            if ( Verbose == DEBUG) printf("Data[0] %llx\n",data[0]);
            if( data[1] != 0 ){
                if ( Verbose == DEBUG) printf("Data[1] %llx\n",data[1]);
            }
          }
          break;

        case 'k':{
            uint8_t ckey[32+1];
            
            if ( Verbose == DEBUG) printf ("option -k with value `%s'\n", optarg);
            memcpy(ckey,optarg,16);
            ckey[16] = '\0';
            key[0] = strtoull(ckey, NULL, 16);
            if ( Verbose == DEBUG) printf("key[0] %llx\n",key[0]);
            memcpy(ckey,&optarg[16],16);
            ckey[16] = '\0';
            key[1] = strtoull(ckey, NULL, 16);
            if ( Verbose == DEBUG) printf("key[1] %llx\n",key[1]);
            key[2]=key[0];
            if ( Verbose == DEBUG) printf("key[2] %llx\n",key[2]);
            }
          break;

        case '1':
          if ( Verbose == DEBUG) printf ("option -comp1 with value `%s'\n", optarg);
          str2bin(comp1,optarg);
          if ( Verbose == DEBUG) print(comp1,16);    
          break;
       
        case '2':
          if ( Verbose == DEBUG) printf ("option -comp2 with value `%s'\n", optarg);
          str2bin(comp2,optarg);
          if ( Verbose == DEBUG) print(comp2,16);    
          break;

        case '3':
          if ( Verbose == DEBUG) printf ("option -comp3 with value `%s'\n", optarg);
          str2bin(comp3,optarg);
          if ( Verbose == DEBUG) print(comp3,16);    
          break;

        case '?':
          /* getopt_long already printed an error message. */
          break;

        default:
          abort ();
        }
    }

  /* Print any remaining command line arguments (not options). */
  if (optind < argc)
    {
      printf ("non-option ARGV-elements: ");
      while (optind < argc)
        printf ("%s ", argv[optind++]);
      putchar ('\n');
    }
    if ( encrypt_flag ){
        printf("Encrypted data: ");
    }
  
}      
void verifica_key()
{
    if( key[0] == 0 ){
        printf("Give a key to get done\n");
        exit(1);
    }        
}
void verifica_data()
{
    if( data == 0 ){
        printf("Give data to encrypt\n");
        exit(1);
    }        
}
void verifica_comp()
{
    if( (strlen(comp1) == 0) || (strlen(comp2) == 0) || (strlen(comp3) == 0) ){
        printf("All 3 components are needed to process key generator...\n");
        exit(1);
    }
}
int main(int argc, const char * argv[])
{
    threat_args(argc, argv);
    
    if ( encrypt_flag == 1){
        verifica_data();
        verifica_key();
        tdes_encrypt(data[0]);
        tdes_encrypt(data[1]);
    }else if ( decrypt_flag == 1 ){
        verifica_data();
        verifica_key();
        tdes_decrypt(data[0]);
        tdes_decrypt(data[1]);
    }else if( kcv_flag == 1 ){
        verifica_key();
        get_key_kcv();
    }else if( keygen_flag == 1 ){
        verifica_comp();
        gendKey(comp1,comp2,comp3, 16);
    }        
    printf("\n");
}

