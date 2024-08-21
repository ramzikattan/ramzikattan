%% Rolls Royce Voltage (V) vs Time (s) Data Import and Find Max Values
tic

% Find Data in Directory and Save to Structure Using File Pattern
% tekXXXX.csv.
DataFolder = '/Users/ramzikattan/Library/CloudStorage/OneDrive-purdue.edu/RR Erosion Project/Particle Impact Data'; % Indicating where the folder is located.
tekPattern = fullfile(DataFolder, 'tek*.csv'); % Specifying the file pattern in desired folder. 
datafiles = dir(tekPattern); % Saving all files with naming pattern to a structure in Workspace. 

% Extract and Find Max Values
for k = 1:1
    baseFileName = datafiles(k).name; % Indicating desired file name in structure (i.e 'tek0000.csv').
    fullFileName = fullfile(datafiles(k).folder, baseFileName); % Indicating actual file name using required path (i.e '/Users/ramzikattan/Library/CloudStorage/OneDrive-purdue.edu/RR Erosion Project/Particle Impact Data/tek0002ALL.csv'. 
    channel3dat = csvread(fullFileName, 21, 0); % Importing data from desired file, offsetting by 21 rows and 0 columns. 
    time = channel3dat(:,1); % Importing time data.
    if size(channel3dat,2) == 2 % If number of columns is 2 (for data files only saving channel 3 data).
        voltage = channel3dat(:,2); % Importing voltage data.
    else
        voltage = channel3dat(:,4); % Importing voltage data.
    end
    [max_voltage(k), index1] = max(voltage); % Finding max voltage value and its index in array
    max_time(k) = time(index1); % Finding max voltage time using index
    [min_voltage(k), index2] = min(voltage); % Finding min voltage value and its index in array
    min_time(k) = time(index2); % Finding min voltage time using index
    file(k) = sprintf("tek0%d", k-1); % Saving file name
    
end



toc