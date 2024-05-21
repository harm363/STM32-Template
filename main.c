int i = 0;
int off = 5;

#include <stm32f10x_rcc.h>
#include <stm32f10x_usart.h>

#ifdef USE_FULL_ASSERT
void assert_failed(uint8_t* file, uint32_t line)
{
/* Infinite loop /
/ Use GDB to find out why we're here */
while (1);
}
#endif


void inc(void){
  i += off;
}


int main(void){
  USART_InitTypeDef test;
  USART_StructInit( &test);
  USART_Init(USART1,&test);

  while (1) {
    inc();
  }
}

