%{
% Function:  getDxlSetupBlockUserData(modelHandle, spheroVarNumber) 
% --------------------------------------------------
% Description: 
% Searches the model for the Dynamixel(slDxl) Name Setup block 
%
%   Copyright 2017 The MathWorks, Inc.
%}

function data = getDxlSetupBlockUserData(modelHandle, slDxlVarName)
    blockName = find_system(modelHandle, ...
        'SearchDepth', 1, ...
        'MaskType', 'slDxl Setup', ...
        'slDxlVarName', slDxlVarName);

    if numel(blockName) == 0
        error('Cannot find slDxl Name Setup Block for ''%s'' at top level of model', slDxlVarName);
    elseif numel(blockName) > 1
        error('Multiple slDxl Name Setup Blocks for ''%s''', slDxlVarName);
    end

    data = get_param(blockName, 'UserData');
    if isempty(data)
       error('slDxl Name Setup Block for ''%s'' is not initialized', slDxlVarName); 
    end
end
