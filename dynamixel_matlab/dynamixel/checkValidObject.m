%{
% Function:  msfcn_dxl_read(block) 
% --------------------------------------------------
% Description: 
% Read Block for the Dynamixel(slDxl)
%
%   Copyright 2017 The MathWorks, Inc.
%}

function resID = checkValidObject(moduleHandle, nTargetID)
NumDxl = moduleHandle.get('numOfDxl');
%objDxlUnit = slDxlUnit.empty();

nChkID = -1;
for idx=1:NumDxl
    objDxlUnit = moduleHandle.oDxlUnits(idx);
    objID = objDxlUnit.get('nID');
    if objID == nTargetID
        nChkID = objID;
    end
end

resID = nChkID;
end