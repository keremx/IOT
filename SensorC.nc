 
#include "Timer.h"
#include "Sensor.h"
#include "printf.h"

// CALLING THE COMPONENTS AS INTERFACE 
module SensorC @safe(){
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli> as Timer_0;
    interface Timer<TMilli> as Timer_1;
    interface Timer<TMilli> as Timer_2;
    interface Packet;
    interface Read<uint16_t> as TMP;
    interface Read<uint16_t> as HMD;
    interface Read<uint16_t> as LGH;
    interface SplitControl as RadioControl;
  }
}
implementation {
// BOOTING THE PROGRAM
  message_t packet;
  bool locked = FALSE;
   
  event void Boot.booted() {
    call RadioControl.start();
  }
// SETTING THE TIMERS FOR 1 SECOND, 2 SECOND ,3 SECOND
  event void RadioControl.startDone(error_t err) {
    if (TOS_NODE_ID == 1) {
      call Timer_0.startPeriodic(1000);
      call Timer_1.startPeriodic(2000);
      call Timer_2.startPeriodic(3000);
    }
  }
  event void RadioControl.stopDone(error_t err) {}
 // FIRST TIMER FOR LIGHT 
  event void Timer_0.fired() {
    call LGH.read();
    
  }
//SECOND TIMER FOR HUMIDITY
  event void Timer_1.fired() {
    call HMD.read();
  
  }
// THIRDH TIMER FOR TEMPERATURE
  event void Timer_2.fired() {
    call TMP.read();

  }
// CHECKING LIGHT READING AND TOGLLE THE SENSOR
  event void LGH.readDone(error_t result, uint16_t data) {
    if (result != SUCCESS) {
        call LGH.read();
    }
    else {
      sensor_msg_t* rsm;

      rsm = (sensor_msg_t*)call Packet.getPayload(&packet, sizeof(sensor_msg_t));
      if (rsm == NULL) {
	return;
      }
      rsm->light = data;
      rsm->type = 1;
      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(sensor_msg_t)) == SUCCESS) {
	call Leds.led0Toggle();
      }
    }
  }
// CHECKING HUMIDITY READING AND TOGLLE THE SENSOR
 event void HMD.readDone(error_t result, uint16_t data) {
    if (result != SUCCESS) {
        call HMD.read();
    }
    else {
      sensor_msg_t* rsm;

      rsm = (sensor_msg_t*)call Packet.getPayload(&packet, sizeof(sensor_msg_t));
      if (rsm == NULL) {
	return;
      }
      rsm-> humidity = data;
      rsm->type = 2;
      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(sensor_msg_t)) == SUCCESS) {
	call Leds.led1Toggle();
      }
    }
  }
// CHECKING TEMPERATURE READING AND TOGLLE THE SENSOR
event void TMP.readDone(error_t result, uint16_t data) {
    if (result != SUCCESS) {
        call TMP.read();
    }
    else {
      sensor_msg_t* rsm;

      rsm = (sensor_msg_t*)call Packet.getPayload(&packet, sizeof(sensor_msg_t));
      if (rsm == NULL) {
	return;
      }
      rsm->temperature = data;
      rsm->type = 3;
      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(sensor_msg_t)) == SUCCESS) {
	call Leds.led2Toggle();
      }
    }
  }


  event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
      //printf("CHECK");
      //am_addr_t from = call Packet.source(bufPtr);
      sensor_msg_t* rsm = (sensor_msg_t*)payload;
      //uint16_t type = rsm -> type;
      
      if (rsm -> type == 1){
	
	printf("Light : %d\n",rsm -> light);
	call Leds.led0Toggle();
	}

	if (rsm -> type == 2){
	
	printf("Humidity : %d\n",rsm -> humidity);
	call Leds.led1Toggle();
	}

	if (rsm -> type == 3){
	
	printf("Temperature : %d\n",rsm ->temperature);
	call Leds.led2Toggle();
	}
      printfflush();
      return  bufPtr;
  }
// CHECKING PACKAGE 
  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (error != SUCCESS) {
      call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(sensor_msg_t));
    }
  }

}

