import board
import time
from adafruit_onewire.bus import OneWireBus
import adafruit_ds18x20
from adafruit_motorkit import MotorKit
from adafruit_motor import stepper
from adafruit_onewire.bus import OneWireBus

from adafruit_ble import BLERadio
from adafruit_ble.advertising.standard import ProvideServicesAdvertisement
from adafruit_ble.services.nordic import UARTService


ble = BLERadio()
uart = UARTService()
advertisment = ProvideServicesAdvertisement(uart)
ble.name = "autocook - penguin"



#Variables
targetTemperature = 80 #in celsius
temperatureRange = 5 #in celsius
temperatureTimeDelay = 10 #in seconds
timeSinceLastChange = 0 #in seconds

#Setting up temperature sensor
ow_bus = OneWireBus(board.D5)
devices = ow_bus.scan()
for device in devices:
    print("ROM = {} \tFamily = 0x{:02x}".format([hex(i) for i in device.rom], device.family_code))

ds18b20 = adafruit_ds18x20.DS18X20(ow_bus, devices[0])
print("Temperature Sensor OK")

#Setting Up motor
kit = MotorKit(i2c=board.I2C())
print("Motor Controler OK")


def start_advertising_device():
    if ble.connected:
        ble.stop_advertising()
    elif not ble.advertising:
        ble.start_advertising(advertisment)
        print("start_advertising: ", ble.name)
    elif ble.advertising:
        print("not yet connected: ", ble.name)
    else:
        pass


def blue_broadcast(temperature, targetTemperature):
    if ble.connected:
        #uart.write("5,10")
        uart.write("{},{}".format(temperature,targetTemperature))


def floatTryParse(value):
    try:
        return float(value), True
    except ValueError:
        return -1000, False


def get_data():
    if ble.connected:
        print('waiting for data')
        s = uart.readline()
        print(s)
        val, success = floatTryParse(s)
        if success:
            set_targetTemperature(val)
        print('waited for data')


def set_targetTemperature(newTargetTemperature):
    global targetTemperature
    if(newTargetTemperature <= 105 and newTargetTemperature >= 55):
        targetTemperature = newTargetTemperature

while (True):
    start_advertising_device()

    temperature = ds18b20.temperature
    timeSinceLastChange += temperatureTimeDelay
    if(timeSinceLastChange == 300)
        timeSinceLastChange = 0
        if((temperature >= (targetTemperature + temperatureRange)) or (temperature <= (targetTemperature -temperatureRange))):
            print("not in range")
            if(temperature < targetTemperature):
                for i in range(500):
                    kit.stepper1.onestep(direction=stepper.BACKWARD)
                print("moved")
            elif(temperature > targetTemperature):
                for i in range(500):
                    kit.stepper1.onestep()
                print("moved")


    print("targetTemperature : " + str(targetTemperature))
    print("Temperature: {0:0.3f}C".format(temperature))

    get_data()

    blue_broadcast(temperature, targetTemperature)
    time.sleep(temperatureTimeDelay)
    #print("next move")


