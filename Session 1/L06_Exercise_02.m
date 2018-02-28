% L06_Exercise_02

% Run length encoding (user defined array)

warning off

% Prompt user for array values
original_array = input('\nEnter array values (use []) to run length encode: ');

% Determine length of array
original_array_size = size(original_array,2);

% Start first count
RLE_array(1) = 1;
% First value encountered
RLE_array(2) = original_array(1);

% Initialise run number
run_number = 1;

% Run length encode array
for i=2:original_array_size
    % If value same as previous
    if original_array(i)==RLE_array(run_number*2),
        RLE_array(2*run_number-1) = RLE_array(2*run_number-1) + 1;
    % If value different from previous
    else
        run_number = run_number + 1;
        RLE_array(2*run_number-1) = 1;
        RLE_array(2*run_number) = original_array(i);
    end
end

% Determine length of RLE array
RLE_array_size = size(RLE_array,2);

% Output arrays to command window
original_array
RLE_array

original_array_size
RLE_array_size

Compression_Ratio = original_array_size/RLE_array_size

% input('\nEnter to finish');

pause

clear all
close all

clc
    