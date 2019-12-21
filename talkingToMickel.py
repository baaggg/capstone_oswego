import serial
import time

# In command prompt:
# C:\Users\brand>python -m serial.tools.list_ports
# COM5

# Initialize XBee
# Note: Assigning a port also opens it
xbee = serial.Serial(port = 'COM5',
                     baudrate = 9600)

# Write a full sentence to the XBee (serial port)
# Delay of 10ms because the loop iterates too fast
message = 'Mike you are so sexy'
for k in message:
    msg = bytes(k, 'utf-8')
    xbee.write(msg)
    time.sleep(0.01)

# Close the XBee / serial port
xbee.close()
