%{
% Function:  slDxl(class) 
% --------------------------------------------------
% Description: 
% Dynamixel Class 
%
%   Copyright 2017 The MathWorks, Inc.
%}

classdef slDxl < handle & matlab.mixin.SetGet & matlab.mixin.Copyable
    properties (Constant)
        % Device Name
        DeviceName = 'Dynamixel';
        % Protocol version
        ProtocalVer            = '2.0';          % See which protocol version is used in the Dynamixel        
        
        eSUCCESS = 0;
        eFAILURE = -1;
        eTorqueEnable               = 1;            % Value for enabling the torque
        eTorqueDisable              = 0;            % Value for disabling the torque
    end
    
    properties 
        % Serial Port
        COMPort;
        PortNum;
        nBaudRate;
        
        % library name for dynamic library(DLL or SO)
        LibName;
        
        % # of Dxl
        numOfDxl = 0;      
        oDxlUnits = slDxlUnit.empty();
   end
   
   methods       
       % methods Start %%--------------------------------------------------
       function myDxl = slDxl(DEVICENAME, BAUDRATE)
         myDxl.set('COMPort', DEVICENAME);
         myDxl.set('nBaudRate', BAUDRATE);
         
         myDxl.initialize();
         
         if myDxl.openPort() == myDxl.eSUCCESS
             disp('Ready to work!');
         else
             disp('Error to open!');
         end
         
         myDxl.setBaudRate();
       end
       
       function delete(myDxl)
           myDxl.release();
       end
       
       function [notfound, warnings] = initialize(myDxl)
          % Find platform
          if strcmp(computer, 'PCWIN')
              lib_name = 'dxl_x86_c';
          elseif strcmp(computer, 'PCWIN64')
              lib_name = 'dxl_x64_c';
          elseif strcmp(computer, 'GLNX86')
              lib_name = 'libdxl_x86_c';
          elseif strcmp(computer, 'GLNXA64')
              lib_name = 'libdxl_x64_c';
          end
          
          % Load Libraries
          if ~libisloaded(lib_name)
              [notfound, warnings] = loadlibrary(lib_name, 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h');
          end
          
          % Initialize PortHandler Structs
          % Set the port path
          % Get methods and members of PortHandlerLinux or PortHandlerWindows
          DEVICENAME = myDxl.COMPort;
          port_num = calllib(lib_name, 'portHandler', DEVICENAME);
          
          % Initialize PacketHandler Structs
          % packetHandler();
          calllib(lib_name, 'packetHandler');          
          
          % Set member variables
          myDxl.set('LibName', lib_name);
          myDxl.set('PortNum', port_num);
      end
      
      function release(myDxl)
          myDxl.closePort();
          % Unload Library
          unloadlibrary(myDxl.LibName);
      end
      
      function res = openPort(myDxl)        
          lib_name = myDxl.get('LibName');
          port_num = myDxl.get('PortNum');
          % Open port
          if( calllib(lib_name, 'openPort', port_num) ) 
              fprintf('Succeeded to open the port!\n');
              res = myDxl.eSUCCESS;
          else
              unloadlibrary(lib_name);
              fprintf('Failed to open the port!\n');           
              res = myDxl.eFAILURE;
          end
      end
      
      function closePort(myDxl)
          lib_name = myDxl.get('LibName');
          port_num = myDxl.get('PortNum');
          % Close port
          calllib(lib_name, 'closePort', port_num);
      end
      
      function setBaudRate(myDxl)
          BAUDRATE = myDxl.get('nBaudRate');
          lib_name = myDxl.get('LibName');
          port_num = myDxl.get('PortNum');
          
          % Set port baudrate
          if(  calllib(lib_name, 'setBaudRate', port_num, BAUDRATE) ) 
              fprintf('Succeeded to change the baudrate!\n');
          else
              unloadlibrary(lib_name);
              fprintf('Failed to change the baudrate!\n');
              input('Press any key to terminate...\n');
          end
      end
  
      function findDxls(myDxl)
          PROTOCOL_VERSION = str2double(myDxl.get('ProtocalVer'));
          lib_name = myDxl.get('LibName');
          port_num = myDxl.get('PortNum');
          
          nChkIdx = 0;
          
          for idx=1:253
              % Try to ping the Dynamixel
              % Get Dynamixel model number
              dxl_model_num = calllib(lib_name, 'pingGetModelNum', port_num, PROTOCOL_VERSION, idx);
              
              if calllib(lib_name, 'getLastTxRxResult', port_num, PROTOCOL_VERSION) == myDxl.eSUCCESS
                  fprintf(' [ID:%.3d] Model No : %.4d \n', idx, dxl_model_num);
                  
                  nChkIdx = nChkIdx+1;
                  myDxl.oDxlUnits(nChkIdx) = slDxlUnit(idx, dxl_model_num);                  
              else
                  if mod(idx,5) == 3
                      fprintf('.');
                  end
              end     
          end
          
          myDxl.set('numOfDxl', nChkIdx);
          fprintf('\n # of Valid Dynamixel %d\n', nChkIdx);                            
      end
      
      function doEnableTorque(myDxl, nID)          
          DXL_ID = nID;
                  
          bChkValidId = false;
          hDxlUnit = myDxl.get('oDxlUnits');
          for nIdx=1:myDxl.get('numOfDxl')
              if hDxlUnit(nIdx).get('nID') == DXL_ID
                  bChkValidId = true;
              end
          end
          
          if bChkValidId == false
              disp('Invalid ID!');
              return
          end
          
          PROTOCOL_VERSION = str2double(myDxl.get('ProtocalVer'));
          lib_name = myDxl.get('LibName');
          port_num = myDxl.get('PortNum');
          
          ADDR_PRO_TORQUE_ENABLE = hDxlUnit(DXL_ID).get('unAddrTorqueEnable');
          TORQUE_ENABLE = 1;
          
                              
          calllib( lib_name, 'write1ByteTxRx', port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE );
          
%           if calllib(lib_name, 'getLastTxRxResult', port_num, PROTOCOL_VERSION) ~= myDxl.eSUCCESS
%               % calllib( lib_name, 'printTxRxResult', PROTOCOL_VERSION, calllib(lib_name, 'getLastTxRxResult', port_num, PROTOCOL_VERSION) );
%               disp('Error : doEnableTorque.getLastTxRxResult');
              
          if calllib(lib_name, 'getLastRxPacketError', port_num, PROTOCOL_VERSION) ~= myDxl.eSUCCESS
              % calllib( lib_name, 'printRxPacketError', PROTOCOL_VERSION, calllib( lib_name, 'getLastRxPacketError', port_num, PROTOCOL_VERSION) );
              disp('Error : doEnableTorque.getLastRxPacketError');
          else
              fprintf('Dynamixel has been successfully connected \n');
          end
      end
      
      function doDisableTorque(myDxl, nID)          
          DXL_ID = nID;
                  
          bChkValidId = false;
          hDxlUnit = myDxl.get('oDxlUnits');
          for nIdx=1:myDxl.get('numOfDxl')
              if hDxlUnit(nIdx).get('nID') == DXL_ID
                  bChkValidId = true;
              end
          end
          
          if bChkValidId == false
              disp('Invalid ID!');
              return
          end
          
          PROTOCOL_VERSION = str2double(myDxl.get('ProtocalVer'));
          lib_name = myDxl.get('LibName');
          port_num = myDxl.get('PortNum');
          
          ADDR_PRO_TORQUE_ENABLE = hDxlUnit(DXL_ID).get('unAddrTorqueEnable');
          TORQUE_DISABLE = 0;
          
          % Disable Dynamixel Torque
          calllib( lib_name, 'write1ByteTxRx', port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE );
%           if calllib(lib_name, 'getLastTxRxResult', port_num, PROTOCOL_VERSION) ~= myDxl.eSUCCESS
%               % calllib( lib_name, 'printTxRxResult', PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION) );
%               disp('Error : doDisableTorque.getLastTxRxResult');
          if calllib(lib_name, 'getLastRxPacketError', port_num, PROTOCOL_VERSION) ~= myDxl.eSUCCESS
              % calllib( lib_name, 'printRxPacketError', PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION) );
              disp('Error : doDisableTorque.getLastRxPacketError');
          end
      end      
      % methods End%%--------------------------------------------------
   end
end