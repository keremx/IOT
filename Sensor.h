// HEADER FILE
#ifndef SENSOR_H
#define SENSOR_H

// THESE ARE THE STRUCT VARIABLES WHICH I AM USING IN SENSORC.
typedef nx_struct{
  nx_uint16_t light;
  nx_uint16_t humidity;
  nx_uint16_t temperature;
  nx_uint16_t type;
} sensor_msg_t;
// THIS IS THE MESSAGE RANGE VALUE
enum {
  AM_RADIO_SENSE_MSG = 243,
};

#endif
