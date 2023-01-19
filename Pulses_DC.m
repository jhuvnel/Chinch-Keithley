% Author: Celia Fernandez Brillet
% Date: 11/15/22
% Description:script to connect to Keithley 6221 and program it to send out
% pulses or DC (monophasic or biphasic).

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

%% Program pulse burst

fprintf(t, 'sour:wave:abor')
fprintf(t, 'sour:curr:rang 200e-6')
fprintf(t, 'curr:filt off')

fprintf(t, 'outp:ishield guard')
fprintf(t, 'outp:ltearth on')

% The code below will create a waveform that is made up of a pattern of "25
% points" (note: this can be changed depending on your needs). Because I want 
% a pulse frequency of 400 Hz, those two numbers will define the duration
% of each of the points in my waveform pattern. 1/400Hz = 2500 us. So, each
% slot will be 100 us long. I chose the number of points in my waveform
% (25) to get a resolution of 100 us. Now, say I want my phases to be 200
% us long -- I'd need two points per phase. If I wanted an interphase gap
% (IPG) of <100 us, I'd have to make my resolution smaller. For now, the smallest
% IPG I could add would be 100 us. In this example, I won't have an IPG.

% Cathodic first, two data points per phase, 21 for the interpulse gap
fprintf(t, 'sour:wave:arb:data -1,-1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
% fprintf(t, 'sour:wave:arb:data -1, 0.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
% Choosing an arbitrary waveform (meaning we can define our string our values like in the line above)
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
% Cathodic first, one data point per phase
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
% Cathodic phase
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