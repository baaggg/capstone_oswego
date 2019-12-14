//ui8Adjust will be the number we have to change to get to 1ms, 1.5ms, and 2ms.

#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/debug.h"
#include "driverlib/pwm.h"
#include "driverlib/pin_map.h"
#include "inc/hw_gpio.h"
#include "driverlib/rom.h"
#include "inc/hw_ints.h"
#include "inc/hw_types.h"
#include "driverlib/interrupt.h"
#include "driverlib/uart.h"

// 55Hz as base frequency to control the servo
#define PWM_FREQUENCY 55

volatile uint8_t ui8Adjust;
volatile uint8_t ui8AdjustL;
volatile uint8_t ui8AdjustR;
volatile uint32_t ui32Load;
volatile uint32_t ui32PWMClock;


void EnUART()
{


    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART1);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);

    GPIOPinConfigure(GPIO_PB0_U1RX);
    GPIOPinConfigure(GPIO_PB1_U1TX);
    GPIOPinTypeUART(GPIO_PORTB_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    UARTConfigSetExpClk(UART1_BASE, SysCtlClockGet(), 9600,
            (UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE));
}


void motors(void)
{
    // 83 is the center position to create a 1.5mS pulse
    ui8Adjust = 83;

    // Divides the clock by 64 to run PWM clock at 625kHz
    SysCtlPWMClockSet(SYSCTL_PWMDIV_64);
    // Enable PWM 1
    SysCtlPeripheralEnable(SYSCTL_PERIPH_PWM1);
    // Enable Port D for PWM output
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);
    // Port D pin 0 (PD0)
    GPIOPinTypePWM(GPIO_PORTD_BASE, GPIO_PIN_1);
    GPIOPinTypePWM(GPIO_PORTD_BASE, GPIO_PIN_0);
    GPIOPinConfigure(GPIO_PD1_M1PWM1);
    GPIOPinConfigure(GPIO_PD0_M1PWM0);

    /*------------------------------------------------------------------------------*/

    ui32PWMClock = SysCtlClockGet() / 64;
    // Divide PWM clock by desired frequency to get the count
    // Subtract one because down counter counts down to 0
    ui32Load = (ui32PWMClock / PWM_FREQUENCY) - 1;
    // Configure PWM1 generator 0 as a down counter
    PWMGenConfigure(PWM1_BASE, PWM_GEN_0, PWM_GEN_MODE_DOWN);
    // Load the count value
    PWMGenPeriodSet(PWM1_BASE, PWM_GEN_0, ui32Load);
    // Sets the pulse width
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_1, ui8Adjust * ui32Load / 1000);
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_0, ui8Adjust * ui32Load / 1000);
    // PWM module 1 generator 0 enabled as an output
    PWMOutputState(PWM1_BASE, PWM_OUT_1_BIT, true);
    PWMOutputState(PWM1_BASE, PWM_OUT_0_BIT, true);
    // PWM module 1 generator 0 enabled to run
    PWMGenEnable(PWM1_BASE, PWM_GEN_0);

}

void goStraight()
{
    motors();
    ui8Adjust = 75;
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_1, ui8Adjust * ui32Load / 1000);
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_0, ui8Adjust * ui32Load / 1000);
}

void stop()
{
    motors();
    ui8Adjust = 83;
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_1, ui8Adjust * ui32Load / 1000);
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_0, ui8Adjust * ui32Load / 1000);
}

void goBack()
{
    motors();
    ui8Adjust = 90;
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_1, ui8Adjust * ui32Load / 1000);
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_0, ui8Adjust * ui32Load / 1000);
}

void turnRight()
{
    motors();
    ui8AdjustL = 92;
    ui8AdjustR = 74;
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_1, ui8AdjustR * ui32Load / 1000);
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_0, ui8AdjustL * ui32Load / 1000);
}

void turnLeft()
{
    motors();
    ui8AdjustL = 74;
    ui8AdjustR = 92;
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_1, ui8AdjustR * ui32Load / 1000);
    PWMPulseWidthSet(PWM1_BASE, PWM_OUT_0, ui8AdjustL * ui32Load / 1000);
}

void UARTInput(void)
{
    char command = UARTCharGet(UART1_BASE);
    if (command == 'g')
    {
        goStraight();
        SysCtlDelay(20000000);
        stop();
        UARTCharPut(UART1_BASE, 'x'); // echo character on terminal
    }
    else if (command == 'r')
    {

        turnRight();
        SysCtlDelay(21000000);
        stop();
        UARTCharPut(UART1_BASE, command); // echo character
    }
    else if (command == 'l')
    {
        turnLeft();
        SysCtlDelay(21000000);
        stop();
        UARTCharPut(UART1_BASE, command); // echo character
    }
    else if (command == 'b')
    {
        goBack();
        SysCtlDelay(20000000);
        stop();
        UARTCharPut(UART1_BASE, 'y'); // echo character
    }
    else if (command == 's')
    {
        stop();
        UARTCharPut(UART1_BASE, command); // echo character
    }
}
void main(void)
{
    SysCtlClockSet(SYSCTL_SYSDIV_5 | SYSCTL_USE_PLL | SYSCTL_OSC_MAIN | SYSCTL_XTAL_16MHZ);
    EnUART();

    while (1)
    {
        UARTInput();

        while (UARTCharsAvail(UART1_BASE)){
            UARTCharGet(UART1_BASE);
        }
    }
}

