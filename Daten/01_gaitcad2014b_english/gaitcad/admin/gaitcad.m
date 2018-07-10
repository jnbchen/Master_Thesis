%PLEASE COPY THIS FILE TO YOUR MATLAB WORK DIRECTORY - e.g. c:\programme\matlab\R2008b\work

clear all; close all;
d = which('gaitcad','-all');
if (~isempty(d))
   if (length(d) ~= 1)       warndlg('An additional Gait-CAD installation was found in the search path (gaitcad.m).');
   end;
end;

%PLEASE UPDATE ALL PATH NAMES TO YOUR LOCAL NAMES 
gaitcadpath = '/Users/.../Documents/MATLAB/00_gaitcad2014b_english/gaitcad/';
addpath(gaitcadpath);
addpath([gaitcadpath filesep 'plugins' filesep 'einzuggenerierung']);
addpath([gaitcadpath filesep 'plugins' filesep 'mgenerierung']);
addpath([gaitcadpath filesep 'toolbox']);
addpath([gaitcadpath filesep 'standardmakros']);
addpath(fileparts(which('gaitcad')))
gaitcad_gui
d = which('gaitcad_gui','-all');
if (~isempty(d))
   if (length(d) ~= 1)       warndlg('An additional Gait-CAD installation was found in the search path (gaitcad_gui.m).','Warning Dialog','modal');
   end;
end;
