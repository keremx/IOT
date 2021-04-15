
 
#include "Sensor.h"
#include "printf.h"
#define NEW_PRINTF_SEMANTICS


// FIRST IMPLEMENT THE COMPONENTS FOR CONFIGURATION AND ASSIGN THEM.
configuration SensorAppC {}
implementation {
  components MainC, SensorC as App; 
  components PrintfC; // FOR PRINTING THE RESULTS
  components LedsC; //FOR LEDS
  components ActiveMessageC; //FOR MESSAGE
  components SerialStartC;  // FOR STARTING THE FUNCTIONS LIKE PRINTF
       
  components new AMSenderC(AM_RADIO_SENSE_MSG); //SENDER COMPONENT
  components new AMReceiverC(AM_RADIO_SENSE_MSG); //RECEIVER COMPONENT
  components new TimerMilliC() as Timer_0; //FIRST TIMER COMPONENT
  components new TimerMilliC() as Timer_1; //SECOND TIMER COMPONENT
  components new TimerMilliC() as Timer_2; //THIRD TIMER COMPONENT
  components new SensirionSht11C();
  components new HamamatsuS10871TsrC() as LightC;
  
  App.Boot -> MainC.Boot; //FOR BOOTING THE PROGRAM
  App.TMP -> SensirionSht11C.Temperature; //ASSIGNING THE TEMPERATURE TO TMP
  App.HMD -> SensirionSht11C.Humidity;//ASSIGNING THE HUMIDITY TO HMD
  App.LGH -> LightC;  //ASSIGNING THE LIGHT TO LGH
  App.Receive -> AMReceiverC;  //SAME FOR OTHER COMPONENTS
  App.AMSend -> AMSenderC;
  App.RadioControl -> ActiveMessageC;
  App.Leds -> LedsC;
  App.Timer_0 -> Timer_0;
  App.Timer_1 -> Timer_1;
  App.Timer_2 -> Timer_2;
  App.Packet -> AMSenderC;
 
}
