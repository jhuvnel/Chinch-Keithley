% Author: Celia Fernandez Brillet
% Date: 11/15/22
% Description:script to connect to Keithley 6221 and program it to send out
% pulses or DC (monophasic or biphasic).


%%%%%%%% TO ADD: SAVE TO .TXT FILE WITH TIMESTAMP AND WAVEFORM DETAIL FOR
%%%%%%%% EACH ITERATION

%% Initialize Keithley, connect to it

% Delete instrument objects that are still open 
delete(instrfindall)
% Create TCP/IP object 't'. Specify server machine and port number.
t = tcpip('192.168.0.2', 1394)
% Set size of receiving buffer, if needed.
set(t, 'InputBufferSize', 30000);
% Open connection to the server.
fopen(t)
% Transmit data to the server (or a request for data from the server).
fprintf(t, '*idn?');
pause(1); % Pause for the communication delay, if needed.
fscanf(t); % Receive lines of data from server

%% Sine frequency/amplitude sweep
ChID = 'Ch311';
time = datestr(clock,'YYYYmmdd_HHMMSS');
fid=fopen([time(1:8) ChID 'log.txt'],'a+');

amp = [
    % 5
    % 10
    % 15
    % 20
    % 30
    % 40
    % 50
    % 60
    70
    % 80
    % 90
    % 100
    ];

freq = [0.5 1 2 3 8 10];
% freq = [10 8 3 2 1 0.5];
% freq = [8 10];

for i = 1:length(amp)
    for j = 1:length(freq)
        fprintf(t, 'sour:wave:abor')
        fprintf(t, 'sour:curr:rang:auto on')
        fprintf(t, 'curr:filt off')

        % Compliance voltage (V)
        fprintf(t, 'curr:comp 100')
        % Current amplitude (A)
        fprintf(t, ['sour:wave:ampl ' num2str(amp(i)) 'e-6'])
        % Sine frequency
        fprintf(t, ['sour:wave:freq ' num2str(freq(j))])
        % Program sine wave
        fprintf(t, 'sour:wave:func sin')
        % How many cycles I want
        if freq(j)>5
            fprintf(t, 'sour:wave:dur:cycl 40')    
        else
            fprintf(t, 'sour:wave:dur:cycl 20')
        end

        % Arm and start waveform
        fprintf(t, 'output off')
        fprintf(t, 'sour:wave:arm')
        fprintf(fid,'%s Sine %duA %1fHz init\n',datestr(clock,'YYYYmmdd_HHMMSSFFF'),amp(i),freq(j));
        fprintf(t, 'sour:wave:init')

        % Do I need to make sure I wait here?
        if freq(j)>5
            pause(40/freq(j))  
        else
            pause(20/freq(j))
        end
        fprintf(fid,'%s Sine %duA %1fHz abor\n',datestr(clock,'YYYYmmdd_HHMMSSFFF'),amp(i),freq(j));
        % if i==1 && j==1
        %     fprintf(fid,'%s Sine %duA %1fHz abor\n',datestr(clock,'YYYYmmdd_HHMMSSFFF'),amp(i),freq(j));
        % elseif i==1 && j>1
        %     fprintf(fid,'%s Sine %duA %1fHz abor\n',datestr(clock,'YYYYmmdd_HHMMSSFFF'),amp(i),freq(j-1));
        % elseif i>1 && j>1
        %     fprintf(fid,'%s Sine %duA %1fHz abor\n',datestr(clock,'YYYYmmdd_HHMMSSFFF'),amp(i-1),freq(j-1));
        % end
        pause(10)
    end
    % pause(10)
    a=1;
end
fprintf(t, 'sour:wave:abor')
fclose(fid);
%% Steps (1 s on, 2 s off, 1 s on)
ChID = 'Ch311';
time = datestr(clock,'YYYYmmdd_HHMMSS');
fid=fopen([time(1:8) ChID 'log.txt'],'a+');

amp = [
    % 5
    % 10
    % 15
    20
    % 30
    % 40
    % 50
    % 60
    % 70
    % 80
    % 90
    % 100
    ];

for i = 1:length(amp)
    fprintf(t, 'sour:wave:abor')
    fprintf(t, 'sour:curr:rang:auto on')
    fprintf(t, 'curr:filt off')

    % Compliance voltage (V)
    fprintf(t, 'curr:comp 100')
    % Current amplitude (A)
    fprintf(t, ['sour:wave:ampl ' num2str(amp(i)) 'e-6'])
    % Sine frequency
    fprintf(t, ['sour:wave:freq ' num2str(freq(j))])
    % Program step
    fprintf(t, 'sour:wave:arb:data -1,0,0,1,0,0,0,0')
    fprintf(t, 'sour:wave:func arb0')
    % How many cycles I want
    fprintf(t, 'sour:wave:dur:cycl 5')
    % Frequency of the waveform.
    fprintf(t, 'sour:wave:freq 0.125') % 1 s cath, 2 s off, 1 s anod, 4 s off

    % Arm and start waveform
    fprintf(t, 'output off')
    fprintf(t, 'sour:wave:arm')
    fprintf(fid,'%s Step %duA init\n',datestr(clock,'YYYYmmdd_HHMMSSFFF'),amp(i));
    fprintf(t, 'sour:wave:init')

    % Do I need to make sure I wait here?
    pause(8*5)
    fprintf(fid,'%s Step %duA abor\n',datestr(clock,'YYYYmmdd_HHMMSSFFF'),amp(i));
    pause(5)
    a=1;
end
fprintf(t, 'sour:wave:abor')
fclose(fid);

%% Section for calculating duration of experiment (sine frequency/amplitude sweep)

ChID = '';
time = datestr(clock,'YYYYmmdd_HHMMSS');
fid=fopen([time(1:8) ChID 'log.txt'],'a+');



amp = [5
    % 10
    % 20
    % 30
    % 40
    % 50
    % 60
    % 70
    % 80
    % 90
    % 100
    ];

freq = [0.5 1 2 3 8 10];
% freq = 3;

dur = 0;

for i = 1:length(amp)
    for j = 1:length(freq)
        if freq(j)>5
            dur = dur + 40/freq(j) + 10;
        else
            dur = dur + 20/freq(j) + 10;
        end
        fprintf(fid,'%s Sine %duA %dHz init\n',datestr(clock,'YYYYmmdd_HHMMSS'),amp(i),freq(j));
    end
    dur = dur + 10;
end

dur
% dur/60
% dur/length(amp) % duration per amplitude

fclose(fid);


%% Section for calculating duration of experiment (step amplitude sweep)
reps = input('How many reps? ');
amps = input('How many amplitudes? ');
step_time_secs = (8*reps*amps + 10*(amps-1))
% step_time_minutes = (8*reps*amps + 10*(amps-1))/60


% Total duration: 8 s per trial x 5 reps x 11 amps + 10*10 pauses = 9 mins 
% If we did 20 reps, it'd be 31 mins

%% Disconnecting

% Disconnect and clean up the server connection.
fclose(t);
delete(t);
clear t