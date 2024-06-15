Dynamixel Simulink Library:

-----------------------------------------------------------------------------------------------

ABOUT THE Dynamixel:

Servo Motor 
For more information please refer to the following page: http://en.robotis.com/index/product.php?cate_code=101010

-----------------------------------------------------------------------------------------------


REQUIREMENTS

-) A Dynamixel with DynamixelSDK 3.X(https://github.com/ROBOTIS-GIT/DynamixelSDK)
-) USB to RS485(http://support.robotis.com/en/product/auxdevice/interface/usb2dxl_manual.htm)
-) Dynamixel C Libarary and headers

-) MATLAB (2016b or later)

-----------------------------------------------------------------------------------------------

USAGE:

1. Initialize Dynamixel(s) @"example/init_release_script.m" : 
>> Ts = 0.02;
>> myDxl = slDxl('COM4', 1000000);
>> myDxl.findDxls()
>> myDxl
>> myDxl.doEnableTorque(N);
>> myDxl.doEnableTorque(2);

2. Simulation/Algorithm @ @"example/slDxl_Ex.slx" : 

3. Release Dynamixel(s) @"example/init_release_script.m" : 
>> myDxl.doDisableTorque(1);
>> myDxl.doDisableTorque(2);
>> myDxl.delete()

------------------------------------------------------------------------------------------------

TROUBLESHOOTING: 

You have to build shared library using DynamixelSDK provided by ROBOTIS GitHub.

------------------------------------------------------------------------------------------------
Copyright 2017, The MathWorks, Inc.