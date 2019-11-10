global A = csvread('csv_matter.csv');  #do not change this line

################################################
#######Declare your global variables here#######
################################################

global ax ay az gx gy gz = [0]*8000;
global yax yay yaz ygx ygy ygz = [0]*8000;
global n ;
accelScaleFactor = 16384;
gyroScaleFactor = 131;
f_cut = 5;
alpha = 0.03;

function read_accel(axl,axh,ayl,ayh,azl,azh)
  
  global accelScaleFactor f_cut ax ay az n;
  #################################################
  ax(n) = bitshift(axh,8) + axl;
  if (ax(n)>32767)
    ax(n) = ax(n) - 65536;
  endif
  ax(n) = ax(n) ./ accelScaleFactor;
  
  ay(n) = bitshift(ayh,8) + ayl;
  if (ay(n)>32767)
    ay(n) = ay(n) - 65536;
  endif
  ay(n) = ay(n) ./ accelScaleFactor;
  
  az(n) = bitshift(azh,8) + azl;
  if (az(n)>32767)
    az(n) = az(n) - 65536;
  endif
  az(n) = az(n) ./ accelScaleFactor;
  #################################################
  
  ####################################################
  lowpassfilter(ax(n),ay(n),az(n),f_cut);
  ####################################################
  
endfunction

function read_gyro(gxl,gxh,gyl,gyh,gzl,gzh)
  
  #################################################
  global gyroScaleFactor f_cut gx gy gz n;
  
  gx(n) = bitshift(gxh,8) + gxl;
  if (gx(n)>32767)
    gx(n) = gx(n) - 65536;
  endif
  gx(n) = gx(n)  ./  gyroScaleFactor;
  
  gy(n) = bitshift(gyh,8) + gyl;
  if (gy(n)>32767)
    gy(n) = gy(n) - 65536;
  endif
  gy(n) = gy(n)  ./  gyroScaleFactor;
  
  gz(n) = bitshift(gzh,8) + gzl;
  if (gz(n)>32767)
    gz(n) = gz(n) - 65536;
  endif
  gz(n) = gz(n)  ./  gyroScaleFactor;
  #################################################
  
  #####################################################
  highpassfilter(gx(n),gy(n),gz(n),f_cut);
  #####################################################

endfunction


function lowpassfilter(axCurrent,ayCurrent,azCurrent,f_cut)
  global alpha n yax yay yaz;
  dT = 0.01;  #time in seconds
  Tau= 1 ./ 2 ./ 3.1457 ./ 5;                   #f_cut = 5
  alpha = Tau ./ (Tau+dT);                #do not change this line
  
  if(n == 1) 
    yax(n) = (1-alpha)*axCurrent ;
    yay(n) = (1-alpha)*ayCurrent ;
    yaz(n) = (1-alpha)*azCurrent ;
  else
    yax(n) = (1-alpha)*axCurrent + alpha*yax(n-1);
    yay(n) = (1-alpha)*ayCurrent + alpha*yay(n-1);
    yaz(n) = (1-alpha)*azCurrent + alpha*yaz(n-1);
  endif

  ################################################
  ##############Write your code here##############
  ################################################

endfunction

function highpassfilter(gxCurrent,gyCurrent,gzCurrent,f_cut)
  global alpha n gx gy gz ygx ygy ygz;
  dT = 0.01;  #time in seconds
  Tau= 1  ./  2  ./ 3.1457  ./  5;                   #f_cut = 5
  alpha = Tau  ./  (Tau+dT);               #do not change this line
  
  if(n == 1) 
    ygx(n) = (1-alpha)*gxCurrent ; 
    ygy(n) = (1-alpha)*gyCurrent ;
    ygz(n) = (1-alpha)*gzCurrent ;
  else 
    ygx(n) = (1-alpha)*ygx(n-1) + (1-alpha)*(gxCurrent - gx(n-1));
    ygy(n) = (1-alpha)*ygy(n-1) + (1-alpha)*(gyCurrent - gy(n-1));
    ygz(n) = (1-alpha)*ygz(n-1) + (1-alpha)*(gzCurrent - gz(n-1));
  endif

  ################################################
  ##############Write your code here##############
  ################################################
endfunction

function comp_filter_pitch(ax,ay,az,gx,gy,gz)
  alpha = 0.03;

  ##############################################
  ####### Write a code here to calculate  ######
  ####### PITCH using complementry filter ######
  ##############################################

endfunction 

function comp_filter_roll(ax,ay,az,gx,gy,gz)
  alpha = 0.03;

  ##############################################
  ####### Write a code here to calculate #######
  ####### ROLL using complementry filter #######
  ##############################################

endfunction 

function execute_code
  global n A;
  B = A; #temporary
  
  for n = 1:2                    #do not change this line
    read_accel(A(n,2),A(n,1),A(n,4),A(n,3),A(n,6),A(n,5));
    read_gyro(A(n,8),A(n,7),A(n,10),A(n,9),A(n,12),A(n,11));  
    
    ###############################################
    ####### Write a code here to calculate  #######
    ####### PITCH using complementry filter #######
    ###############################################
    
  endfor
  csvwrite('output_data.csv',B);        #do not change this line
endfunction


execute_code                           #do not change this line
