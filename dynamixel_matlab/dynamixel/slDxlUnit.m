%{
% Function:  slDxlUnit(class) 
% --------------------------------------------------
% Description: 
% Dynamixel Unit Class 
%
%   Copyright 2017 The MathWorks, Inc.
%}

classdef slDxlUnit < handle & matlab.mixin.SetGet
    properties
        nID = [];
        nModelNum = [];        
        
        unAddrTorqueEnable       = 64;         % Control table address is different in Dynamixel model
        unAddrGoalPosition         = 116;
        unAddrPresentPosition     = 132;
    end   
        
    methods       
        % methods Start %%--------------------------------------------------
        function myDxlUnit = slDxlUnit(nID, nModelNum)
            myDxlUnit.set('nID', nID);
            myDxlUnit.set('nModelNum', nModelNum);
        end        
        % methods End%%--------------------------------------------------
    end
end