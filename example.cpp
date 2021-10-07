// Serial library
#include "serial/SerialPort.h"
#include <unistd.h>
#include <stdio.h>

#if defined (_WIN32) || defined(_WIN64)
    //for serial ports above "COM9", we must use this extended syntax of "\\.\COMx".
    //also works for COM0 to COM9.
    //https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea?redirectedfrom=MSDN#communications-resources
    #define SERIAL_PORT "\\\\.\\COM1"
#endif
#if defined (__linux__) || defined(__APPLE__)
    #define SERIAL_PORT "/dev/ttyS0"
#endif



/*!
 * \brief main  Simple example that send ASCII characters to the serial device
 * \return      0 : success
 *              <0 : an error occured
 */
int main( /*int argc, char *argv[]*/)
{
    // Serial object
    SerialPort serial;


    // Connection to serial port
    char errorOpening = serial.openDevice(SERIAL_PORT, 115200);


    // If connection fails, return the error code otherwise, display a success message
    if (errorOpening!=1) return errorOpening;
    printf ("Successful connection to %s\n",SERIAL_PORT);


    // Display ASCII characters (from 32 to 128)
    for (int c=32;c<128;c++)
    {
        serial.writeChar(c);
        usleep(10000);
    }

    // Read lines and print them out
    char line[1024];

    while(1) {
        int n = serial.readBytes(line, sizeof(line));
        if (n>=0) {
            std::cout << std::string(line, n) << std::endl;
        }
    }

    // Close the serial device
    serial.closeDevice();

    return 0 ;
}
