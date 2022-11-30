%% Initialize

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

%% Program pulse burst

fprintf(t, 'sour:wave:abor')
fprintf(t, 'sour:curr:rang 200e-6')
fprintf(t, 'curr:filt off')

fprintf(t, 'outp:ishield guard')
fprintf(t, 'outp:ltearth on')

% Cathodic first, two data points per phase, 21 for the interpulse gap
% fprintf(t, 'sour:wave:arb:data -1,-1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
fprintf(t, 'sour:wave:arb:data -1, 0.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
fprintf(t, 'sour:wave:func arb0')
% Compliance voltage (V)
fprintf(t, 'curr:comp 50')
% Current amplitude (A)
fprintf(t, 'sour:wave:ampl 300e-6')
% How many cycles I want
fprintf(t, 'sour:wave:dur:cycl 3000')
% Alternative for defining duration: how long do I want it to last (s)
fprintf(t, 'sour:wave:dur:time 4') % duration for 4 seconds
% Frequency of the waveform. I think of this as the resolution for the duration of
% my waveform. So if it's 400 Hz, then 1/400 = 2500 us
% Now, since I have 25 slots in my waveform, that means that each one is
% 100 us long.
fprintf(t, 'sour:wave:freq 400')

fprintf(t, 'output off')
fprintf(t, 'sour:wave:arm')
fprintf(t, 'sour:wave:init')

% fprintf(t, 'system:key 8')


%% Program DC 'long pulse'

fprintf(t, 'sour:wave:abor')
fprintf(t, 'sour:curr:rang:auto on')
fprintf(t, 'curr:filt off')
% Cathodic first, two data points per phase, 21 for the interpulse gap
fprintf(t, 'sour:wave:arb:data -1,1')
fprintf(t, 'sour:wave:func arb0')
% Compliance voltage (V)
fprintf(t, 'curr:comp 15')
% Current amplitude (A)
fprintf(t, 'sour:wave:ampl 100e-6')
% How many cycles I want
fprintf(t, 'sour:wave:dur:cycl 1')
% Alternative for defining duration: how long do I want it to last (s)
fprintf(t, 'sour:wave:dur:time 40')
% Frequency of the waveform. 
fprintf(t, 'sour:wave:freq 0.25') % having each phase for 2 s


fprintf(t, 'output off')
fprintf(t, 'sour:wave:arm')
fprintf(t, 'sour:wave:init')

%% Program DC 

fprintf(t, 'sour:wave:abor')
fprintf(t, 'sour:curr:rang:auto on')
fprintf(t, 'curr:filt off')
% Cathodic first, two data points per phase, 21 for the interpulse gap
fprintf(t, 'sour:wave:arb:data -1')
fprintf(t, 'sour:wave:func arb0')
% Compliance voltage (V)
fprintf(t, 'curr:comp 100')
% Current amplitude (A)
fprintf(t, 'sour:wave:ampl 100e-6')
% How many cycles I want
fprintf(t, 'sour:wave:dur:cycl 1')
% Alternative for defining duration: how long do I want it to last (s)
fprintf(t, 'sour:wave:dur:time 40')
% Frequency of the waveform. 
fprintf(t, 'sour:wave:freq 0.25') % having each phase for 2 s


fprintf(t, 'output off')
fprintf(t, 'sour:wave:arm')
fprintf(t, 'sour:wave:init')

%% Disconnecting

% Disconnect and clean up the server connection.
fclose(t);
delete(t);
clear t