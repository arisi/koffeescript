#include "koffeescript.h"

int xxxx=1;                                       // pellejuttu:3   : int xxxx=1
int pelle(int c) {                                // test:6         : int pelle =(int c) ->
  return printf  ( "tadaa %d\n",c );              // test:7         :   printf "tadaa %d\n",c
}

int main(int argc,char **argv) {                  // test:9         : int main = (int argc,char **argv) ->
  if (argc<2||false) {                            // test:10        :   if argc<2 or false
    printf  ( "EI ARGUMENNTTIA\n" );              // test:11        :     printf "EI ARGUMENNTTIA\n"
    exit(-1);                                     // test:12        :     exit(-1)
    }
  int x=atoi(argv[1]);                            // test:13        :   int x=atoi(argv[1])
  int y=(1);                                      // test:14        :   int y=:pellekoodi
  for (y=0;y<10;y++) {                            // test:15        :   for y=0;y<10;y++
    printf  ( "LUUPPI %d\n", y );                 // test:16        :     printf "LUUPPI %d\n", y
    if ((y>4)&&(y<9)) {                           // test:17        :     if (y>4) and (y<9)
      printf  ( "kohta loppuu luuppi\n" );        // test:18        :       printf "kohta loppuu luuppi\n"
    }
    }
  if (x>10) {                                     // test:19        :   if x>10
    printf("iso\n") ;                             // test:20        :     printf("iso\n") 
    if (x>100) {                                  // test:21        :     if x>100
      printf  ( "TOSI ISO\n" );                   // test:22        :       printf "TOSI ISO\n"
      if (x>1000) {                               // test:23        :       if x>1000
        printf  ( "HIMUTOSI ISO\n" );             // test:24        :         printf "HIMUTOSI ISO\n"
    }
    }
  } else if (x>5) {                               // test:25        :   else if x>5
    printf  ( "keskikoko\n" );                    // test:26        :     printf "keskikoko\n"
    printf  ( "keskikoko\n" );                    // test:27        :     printf "keskikoko\n"
  } else {                                        // test:28        :   else
    printf  ( "pieni\n"   );                      // test:29        :     printf "pieni\n"  
    }
  return pelle((1));                              // test:30        :   pelle(:pellekoodi)
}

;
