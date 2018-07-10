clear all; if ishandle(1) delete(1);end; close all;
d = which('scixminer','-all');
if (~isempty(d))
   if (length(d) ~= 1)       warndlg('An additional SciXMiner installation was found in the search path (scixminer.m).');
   end;
end;
addpath 'C:\Program Files\MATLAB\scixminer'
addpath 'C:\Program Files\MATLAB\scixminer\plugins\einzuggenerierung'
addpath 'C:\Program Files\MATLAB\scixminer\plugins\mgenerierung'
addpath 'C:\Program Files\MATLAB\scixminer\toolbox'
addpath 'C:\Program Files\MATLAB\scixminer\standardmakros'
addpath(fileparts(which('scixminer')))
scixminer_gui
d = which('scixminer_gui','-all');
if (~isempty(d))
   if (length(d) ~= 1)       warndlg('An additional SciXMiner installation was found in the search path (scixminer_gui.m).','Warning Dialog','modal');
   end;
end;
