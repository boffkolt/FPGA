

#include <stdio.h>
//#include "system.h"
#include <sys/alt_irq.h>
#include "sys/alt_sys_wrappers.h"
#include "altera_avalon_pio_regs.h"

int main(void)
{
int leds =0;




   while (1)
 {

    printf("\nHello from NIOS II from CODELITE");


     IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE, leds);

     usleep(1000000);    									   // wait for 1 sec


     if (leds >15)
     {leds = 0;}
     else
     {leds = leds+1;}


  }
   return 0;
}
