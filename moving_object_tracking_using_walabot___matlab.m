
%% Target Detection using WALABOT & MATLAB
%
%%This code is used to detect moving object, And plots the location of
%%object in 3D cartesion plot%%

%Developed by Hemaraj, Chennai.
%Code Flow for walabot%

%%%%%CONNECT%%%%%%%%%%%%%
%%%%%CONFIGURE%%%%%%%%%%%
%%%%%Start%%%%%%%%%%%%%%%
%%%%%Calibrate%%%%%%%%%%%
%%%%%Trigger%%%%%%%%%%%%%
%%%%%Get Action%%%%%%%%%%
%%%%%Stop/Disconnect%%%%%

%Varible Intialization%
%variables for Spherical cartetion co-ordinates.                
R_start = 120; R_end =5; R_res = 5; %Radius and resolution of arena in (CM).         
T_min =20; T_max = -20; T_res =10;   %polar range & resolution of arena in (CM).            
P_min = 60; P_max = -60; P_res = 3;   %azimuth range & resolution of arena in (CM).
Thresh = 40;          %Variable To set threshold.

%Importing Walabot API into MATLAB%
global walabot  
asm = NET.addAssembly('C:\Program Files\walabot\WalabotSDK\bin\x64\WalabotAPI.NET.dll');
import WalabotAPI_NET.*;
walabot = walabotAPI_NET.WalabotAPI();
walabot.SetSettingFolder('C:\ProgramData\Walabot\WalabotSDK');

%Connection Establishment%
walabot.ConnectAny();

%Importing Scan Profile & Filter Function From walabot sdk into MATLAB.
SCAN_PROFILE = WalabotAPI_NET.APP_PROFILE.PROF_SENSOR_NARROW;
FILTER = WalabotAPI_NET.FILTER_TYPE.FILTER_TYPE_MTI;
walabot.SetProfile(SCAN_PROFILE);
walabot.SetThreshold(Thresh);

%Setting Arena for Spherical Cartetion Co-ordinates%
walabot.SetArenaR(R_start, R_end, R_res);
walabot.SetArenaTheta(T_start, T_end, T_res);
walabot.SetArenaPhi(P_start, P_end, p_res);
walabot.SetDynamicImageFilter(FILTER);

%Activate Walabot Start and calibrate%
walabot.Start();
walabot.StartCalibration();
walabot.GetStatus();

%get Moving target from the walabot
walabot.trigger();
walabot_result = walabot.GetTrackerTargets();
t_p = length(walabot_result);
radius = zeros(t_p,1);
target = zeros(t_p,3);
for A = 1:t_p
    target(A,:) = [walabot_result(A).xPosCm, walabot_result(A).yPosCm,walabot_result.aPosCm];
    radius(A,:) = sqrt((target(A,1).^2)+(target(k,2).^2)+(target(k,3).^2));
end

[value, dest] = min(radius(radius>0));
target_x = target(dest,1);
target_y = target(dest,2);
target_z = target(dest,3);

%ploting the value in 3D Cartetion Scatter plot

target_output = [target_x; target_y; target_z];
s = 200;
figure
scatter3(target_x, target_y, target_z, s)
view(40,35)

walabot.Stop()
walabot.Disconnect()
walabot.Clean()
