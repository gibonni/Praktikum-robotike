%{
% Function:  msfun_dxl_write(block) 
% --------------------------------------------------
% Description: 
% Write Block for the Dynamixel(slDxl)
%
%   Copyright 2017 The MathWorks, Inc.
%}

function msfun_dxl_write(block)
% Level-2 MATLAB file S-Function

% instance variables 
myDxl = [];

setup(block);
  
%% ---------------------------------------------------------
    function setup(block)
        % Register the number of ports.
        block.NumInputPorts  = 1;
        block.NumOutputPorts = 0;
        
        block.SetPreCompOutPortInfoToDynamic;
        block.InputPort(1).Dimensions  = 1;
         block.InputPort(1).DirectFeedthrough = false;
        
         % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 5; % slDxlObject, DXL_ID, DXL_ADDR, byte(size), sampleT
        block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable'};
        
        % Set the sample time
        block.SampleTimes = [block.DialogPrm(5).Data 0];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
        block.SimStateCompliance = 'DefaultSimState';
        
        % Register methods
        block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
        block.RegBlockMethod('InitializeConditions', @InitializeConditions); % call second
        % block.RegBlockMethod('Start', @Start);
        % block.RegBlockMethod('Outputs', @Outputs);     % Required
        block.RegBlockMethod('Update', @Update);
        % block.RegBlockMethod('Derivatives', @Derivatives);
        % block.RegBlockMethod('Terminate', @Terminate); % Required
    end

%%
    function DoPostPropSetup(block)
        st = block.SampleTimes;
        if st(1) == 0
            error('The Sphero library blocks can only handle discrete sample times');
        end        
    end

%%
    function InitializeConditions(block)
        customData = getDxlSetupBlockUserData(bdroot(block.BlockHandle), block.DialogPrm(1).Data);
        myDxl = customData('slDxlHandle');
    end

%%
    function Update(block)
        PROTOCOL_VERSION = str2double(myDxl.get('ProtocalVer'));
        lib_name = myDxl.get('LibName');
        port_num = myDxl.get('PortNum');
        
         if checkValidObject(myDxl, block.DialogPrm(2).Data) == -1
            disp('Invalid ID!!!');
            return;
         end
        
        DXL_ID = block.DialogPrm(2).Data;
        DXL_ADDR = block.DialogPrm(3).Data;

        % Read present position
%          switch block.DialogPrm(4).Data
%             case 1
%                 calllib( lib_name, 'write1ByteTxRx', port_num, PROTOCOL_VERSION, DXL_ID, DXL_ADDR, block.InputPort(1).Data );
%             case 2 
%                 calllib( lib_name, 'write2ByteTxRx', port_num, PROTOCOL_VERSION, DXL_ID, DXL_ADDR, block.InputPort(1).Data );
%             case 3
%                 calllib( lib_name, 'write4ByteTxRx', port_num, PROTOCOL_VERSION, DXL_ID, DXL_ADDR, block.InputPort(1).Data );
%             otherwise
%                 disp('Error : msfcn_dxl_write.Outputs ByteSie');
%         end

        switch block.DialogPrm(4).Data
            case 1
                calllib( lib_name, 'write1ByteTxOnly', port_num, PROTOCOL_VERSION, DXL_ID, DXL_ADDR, block.InputPort(1).Data );
            case 2 
                calllib( lib_name, 'write2ByteTxOnly', port_num, PROTOCOL_VERSION, DXL_ID, DXL_ADDR, block.InputPort(1).Data );
            case 3
                calllib( lib_name, 'write4ByteTxOnly', port_num, PROTOCOL_VERSION, DXL_ID, DXL_ADDR, block.InputPort(1).Data );
            otherwise
                disp('Error : msfcn_dxl_write.Outputs ByteSie');
        end
        
        % block.InputPort(1).Data = dxl_res;
        
        %{
        if calllib(lib_name, 'getLastTxRxResult', port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
            calllib( lib_name, 'printTxRxResult', PROTOCOL_VERSION, calllib( lib_name, 'getLastTxRxResult', port_num, PROTOCOL_VERSION) );
        elseif calllib(lib_name, 'getLastRxPacketError', port_num, PROTOCOL_VERSION) ~= 0
            calllib( lib_name, 'printRxPacketError', PROTOCOL_VERSION, calllib(lib_name, 'getLastRxPacketError', port_num, PROTOCOL_VERSION) );
        end
        %}
    end

end