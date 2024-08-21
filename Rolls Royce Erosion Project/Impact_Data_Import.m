%% Rolls Royce Voltage (V) vs Time (s) Data Import and Plot
tic

% Find Data in Directory and Save to Structure Using File Pattern
% tekXXXX.csv.
DataFolder = '/Users/ramzikattan/Library/CloudStorage/OneDrive-purdue.edu/RR Erosion Project/Particle Impact Data'; % Indicating where the folder is located.
tekPattern = fullfile(DataFolder, 'tek*.csv'); % Specifying the file pattern in desired folder. 
datafiles = dir(tekPattern); % Saving all files with naming pattern to a structure in Workspace. 

% Extract and Plot
for k = 1:length(datafiles)
    baseFileName = datafiles(k).name; % Indicating desired file name in structure (i.e 'tek0000.csv').
    fullFileName = fullfile(datafiles(k).folder, baseFileName); % Indicating actual file name using required path (i.e '/Users/ramzikattan/Library/CloudStorage/OneDrive-purdue.edu/RR Erosion Project/Particle Impact Data/tek0002ALL.csv'. 
    channel3dat = csvread(fullFileName, 21, 0); % Importing data from desired file, offsetting by 21 rows and 0 columns. 
    time = channel3dat(:,1); % Importing time data.
    if size(channel3dat,2) == 2 % If number of columns is 2 (for data files only saving channel 3 data).
        voltage = channel3dat(:,2); % Importing voltage data.
    else
        voltage = channel3dat(:,4); % Importing voltage data.
    end
    fig = figure(k); % Creating seperate figures.
    set(fig, 'Visible', 'off') % Turning off figure pop-ups.
    plot(time, voltage) % Plotting voltage as a function of time.
    hold on
    title(sprintf('tek0%d',k-1)) % Plot title.
    xlabel('Time (s)') % X Axis Label.
    ylabel('Voltage (V)') % Y Axis Label.
    maxlim = max(abs(voltage)); % Finding the maximum voltage value.
    ylim([floor(-maxlim) ceil(maxlim)]); % Setting axis limits as the larger whole number from maximum value.
    saveas(gcf, sprintf('tek0%d.svg',k-1)); % Automatically saving all figures generated.
end

toc