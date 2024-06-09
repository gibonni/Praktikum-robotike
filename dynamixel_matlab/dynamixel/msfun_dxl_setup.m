%{
% Function:  msfun_dxl_setup(block) 
% --------------------------------------------------
% Description: 
% Setup for the Dynamixel(slDxl) 
%
%   Copyright 2017 The MathWorks, Inc.
%}

function msfun_dxl_setup(block)
% Level-2 MATLAB file S-Function

setup(block);

%% ---------------------------------------------------------
    function setup(block)
        % Register the number of ports.
        block.NumInputPorts  = 0;
        block.NumOutputPorts = 0;
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 2; % slDxl var name, workspace var name
        block.DialogPrmsTunable = {'Nontunable', 'Nontunable'};
        
        % Block is fixed in minor time step, i.e., it is only executed on major
        % time steps. With a fixed-step solver, the block runs at the fastest
        % discrete rate.
        block.SampleTimes = [0 1];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
        block.SimStateCompliance = 'DefaultSimState';
        
        block.RegBlockMethod('Start', @Start); % first call
        block.RegBlockMethod('Terminate', @Terminate);
    end

%%
    function Start(block)        
        % myDxlWorkspace = block.DialogPrm(2).Data;        
        % myDxl = myDxlWorkspace.copy();
        myDxl = evalin('base', block.DialogPrm(2).Data);
        
        % store info in custom data;
        customData = containers.Map('UniformValues', false);
        customData('slDxlHandle') = myDxl;
        set(block.BlockHandle, 'UserData', customData, 'UserDataPersistent', 'off');        
    end

%%
    function Terminate(block)      
        customData = get(block.BlockHandle, 'UserData');
        if isvalid(customData)
            delete(customData);
        end
    end

end

