<CsoundSynthesizer>
<CsOptions>
-odac -+rtaudio=alsa -s -B4096
</CsOptions>

/**********************************************************************/

<CsInstruments>

sr=44100
ksmps=32
nchnls=2
0dbfs=1

galeft init 0
garight init 0 

; basic waveforms
gisintbl ftgen 1,0,16384,10,1
gicostbl ftgen 2,0,16384,11,1
gisawtbl ftgen 3,0,16384,7,-1,16384,1
gisquaretbl ftgen 4,0,256,7,-1,128,-1,0,1,128,1
gisheptbl ftgen 5,0,4096,9, \
  1,1,0, 2,1/2,0, 4,1/4,0, 8,1/8,0, 16,1/16,0, 32,1/32,0, 64,1/64,0

; clipping/compression function for output
gicliptbl ftgen 10,0,4097,"tanh",-1,1,0

; sinusoidal rise shape for granular synthesis
girisetbl ftgen 11,0,1024,19, 0.5,0.5,270,0.5

giscalebase=100

/**********************************************************************/

/* x coords:
 *  0..200 control
 *  200..300 stage 1
 *  300..400 stage 2
 *  400..500 stage 3
 *  500..600 stage 4
 *  600..700 stage 5
 *  700..800 stage 6
 */
 
/* y coords:
 *  50 mode switches
 *  150 state LEDs
 *  250 CV A
 *  350 CV 5
 *  450 gate length
 *  550 gate out/bus
 */

FLpanel "Evariste simulator",800,600

giState1Hdl FLbox "@circle",1,1,27,40,40,230,130
giState2Hdl FLbox "@circle",1,1,27,40,40,330,130
giState3Hdl FLbox "@circle",1,1,27,40,40,430,130
giState4Hdl FLbox "@circle",1,1,27,40,40,530,130
giState5Hdl FLbox "@circle",1,1,27,40,40,630,130
giState6Hdl FLbox "@circle",1,1,27,40,40,730,130

gkTempoVal,giTempoHdl FLknob "Tempo",10,1000,-1,1,-1,80,20,20,30
gkTempoVal init 60

gkChnATVal,giChnATHdl FLslider "A: off/bus/clock",0,2,0,5,-1,80,20,60,200
gkChnBTVal,giChnBTHdl FLslider "B: off/bus/clock",0,2,0,5,-1,80,20,60,250

gkRetardVal,giRetardHdl FLbutton "retard",1,0,3,80,20,60,350,-1

gkMode1AVal,giMode1AHdl FLslider "n/ls/l",0,2,0,6,-1,20,60,220,30
gkMode1BVal,giMode1BHdl FLslider "b/0/r",0,2,0,6,-1,20,60,260,30
gkSet1Dummy,giSet1Hdl FLbutton "@circle",1,0,1,20,20,265,105,105,\
  101,0,0.001,1
gkClear1Dummy,giClear1Hdl FLbutton "@circle",1,0,1,20,20,215,175,105,\
  101,0,0.001,0
gkCV1AVal,giCV1AHdl FLknob "CV A 1",-1000,1000,0,1,-1,80,210,210,30
gkCV1BVal,giCV1BHdl FLknob "CV B 1",-1000,1000,0,1,-1,80,210,310,30
gkGate1Val,giGate1Hdl FLknob "Gate 1",10,2000,-1,1,-1,80,210,410,30
gkTBus1Val,giTBus1Hdl FLslider "bus",0,2,0,6,-1,20,60,240,530

gkMode2AVal,giMode2AHdl FLslider "n/ls/l",0,2,0,6,-1,20,60,320,30
gkMode2BVal,giMode2BHdl FLslider "b/0/r",0,2,0,6,-1,20,60,360,30
gkSet2Dummy,giSet2Hdl FLbutton "@circle",1,0,1,20,20,365,105,105,\
  102,0,0.001,1
gkClear2Dummy,giClear2Hdl FLbutton "@circle",1,0,1,20,20,315,175,105,\
  102,0,0.001,0
gkCV2AVal,giCV2AHdl FLknob "CV A 2",-1000,1000,0,1,-1,80,310,210,30
gkCV2BVal,giCV2BHdl FLknob "CV B 2",-1000,1000,0,1,-1,80,310,310,30
gkGate2Val,giGate2Hdl FLknob "Gate 2",10,2000,-1,1,-1,80,310,410,30
gkTBus2Val,giTBus2Hdl FLslider "bus",0,2,0,6,-1,20,60,340,530

gkMode3AVal,giMode3AHdl FLslider "n/ls/l",0,2,0,6,-1,20,60,420,30
gkMode3BVal,giMode3BHdl FLslider "b/0/r",0,2,0,6,-1,20,60,460,30
gkSet3Dummy,giSet3Hdl FLbutton "@circle",1,0,1,20,20,465,105,105,\
  103,0,0.001,1
gkClear3Dummy,giClear3Hdl FLbutton "@circle",1,0,1,20,20,415,175,105,\
  103,0,0.001,0
gkCV3AVal,giCV3AHdl FLknob "CV A 3",-1000,1000,0,1,-1,80,410,210,30
gkCV3BVal,giCV3BHdl FLknob "CV B 3",-1000,1000,0,1,-1,80,410,310,30
gkGate3Val,giGate3Hdl FLknob "Gate 3",10,2000,-1,1,-1,80,410,410,30
gkTBus3Val,giTBus3Hdl FLslider "bus",0,2,0,6,-1,20,60,440,530

gkMode4AVal,giMode4AHdl FLslider "n/ls/l",0,2,0,6,-1,20,60,520,30
gkMode4BVal,giMode4BHdl FLslider "b/0/r",0,2,0,6,-1,20,60,560,30
gkSet4Dummy,giSet4Hdl FLbutton "@circle",1,0,1,20,20,565,105,105,\
  104,0,0.001,1
gkClear4Dummy,giClear4Hdl FLbutton "@circle",1,0,1,20,20,515,175,105,\
  104,0,0.001,0
gkCV4AVal,giCV4AHdl FLknob "CV A 4",-1000,1000,0,1,-1,80,510,210,30
gkCV4BVal,giCV4BHdl FLknob "CV B 4",-1000,1000,0,1,-1,80,510,310,30
gkGate4Val,giGate4Hdl FLknob "Gate 4",10,2000,-1,1,-1,80,510,410,30
gkTBus4Val,giTBus4Hdl FLslider "bus",0,2,0,6,-1,20,60,540,530

gkMode5AVal,giMode5AHdl FLslider "n/ls/l",0,2,0,6,-1,20,60,620,30
gkMode5BVal,giMode5BHdl FLslider "b/0/r",0,2,0,6,-1,20,60,660,30
gkSet5Dummy,giSet5Hdl FLbutton "@circle",1,0,1,20,20,665,105,105,\
  105,0,0.001,1
gkClear5Dummy,giClear5Hdl FLbutton "@circle",1,0,1,20,20,615,175,105,\
  105,0,0.001,0
gkCV5AVal,giCV5AHdl FLknob "CV A 5",-1000,1000,0,1,-1,80,610,210,30
gkCV5BVal,giCV5BHdl FLknob "CV B 5",-1000,1000,0,1,-1,80,610,310,30
gkGate5Val,giGate5Hdl FLknob "Gate 5",10,2000,-1,1,-1,80,610,410,30
gkTBus5Val,giTBus5Hdl FLslider "bus",0,2,0,6,-1,20,60,640,530

gkMode6AVal,giMode6AHdl FLslider "n/ls/l",0,2,0,6,-1,20,60,720,30
gkMode6BVal,giMode6BHdl FLslider "b/0/r",0,2,0,6,-1,20,60,760,30
gkSet6Dummy,giSet6Hdl FLbutton "@circle",1,0,1,20,20,765,105,105,\
  106,0,0.001,1
gkClear6Dummy,giClear6Hdl FLbutton "@circle",1,0,1,20,20,715,175,105,\
  106,0,0.001,0
gkCV6AVal,giCV6AHdl FLknob "CV A 6",-1000,1000,0,1,-1,80,710,210,30
gkCV6BVal,giCV6BHdl FLknob "CV B 6",-1000,1000,0,1,-1,80,710,310,30
gkGate6Val,giGate6Hdl FLknob "Gate 6",10,2000,-1,1,-1,80,710,410,30
gkTBus6Val,giTBus6Hdl FLslider "bus",0,2,0,6,-1,20,60,740,530

FLpanelEnd
FLrun

giState1Val init 0
giState2Val init 0
giState3Val init 0
giState4Val init 0
giState5Val init 0
giState6Val init 0

instr 101 /* set/clear state 1 */
  if p4!=giState1Val then
    giState1Val=p4
    if p4==1 then
      FLsetTextColor 255,180,50,giState1Hdl
    else
      FLsetTextColor 0,0,0,giState1Hdl
    endif
    FLsetText "@circle",giState1Hdl
  endif
endin

instr 102 /* set/clear state 2 */
  if p4!=giState2Val then
    giState2Val=p4
    if p4==1 then
      FLsetTextColor 255,180,50,giState2Hdl
    else
      FLsetTextColor 0,0,0,giState2Hdl
    endif
    FLsetText "@circle",giState2Hdl
  endif
endin

instr 103 /* set/clear state 3 */
  if p4!=giState3Val then
    giState3Val=p4
    if p4==1 then
      FLsetTextColor 255,180,50,giState3Hdl
    else
      FLsetTextColor 0,0,0,giState3Hdl
    endif
    FLsetText "@circle",giState3Hdl
  endif
endin

instr 104 /* set/clear state 4 */
  if p4!=giState4Val then
    giState4Val=p4
    if p4==1 then
      FLsetTextColor 255,180,50,giState4Hdl
    else
      FLsetTextColor 0,0,0,giState4Hdl
    endif
    FLsetText "@circle",giState4Hdl
  endif
endin

instr 105 /* set/clear state 5 */
  if p4!=giState5Val then
    giState5Val=p4
    if p4==1 then
      FLsetTextColor 255,180,50,giState5Hdl
    else
      FLsetTextColor 0,0,0,giState5Hdl
    endif
    FLsetText "@circle",giState5Hdl
  endif
endin

instr 106 /* set/clear state 6 */
  if p4!=giState6Val then
    giState6Val=p4
    if p4==1 then
      FLsetTextColor 255,180,50,giState6Hdl
    else
      FLsetTextColor 0,0,0,giState6Hdl
    endif
    FLsetText "@circle",giState6Hdl
  endif
endin

/**********************************************************************/

opcode ForceSlider,i,iii
iModeIn,iModeVal,iModeHdl xin

if (iModeVal!=iModeIn) then
  if (iModeVal<0.5) then
    iModeOut=0
  elseif (iModeVal<1.5) then
    iModeOut=1
  else
    iModeOut=2
  endif
  if (iModeOut!=iModeVal) then
    FLsetVal_i iModeOut,iModeHdl
  endif
else
  iModeOut=iModeIn
endif

xout iModeOut
endop

opcode CalcNewState,ii,iiiiiii
iLState,iSState,iRState,iNin,iBin,iModeA,iModeB xin

if iModeA<2 then
  iTermX=iSState
else
  iTermX=0
endif
if iModeA>0 then
  iTermY=iLState
else
  iTermY=iNin
endif
if iModeB==0 then
  iTermZ=iBin
  iNout=iSState
elseif iModeB==1 then
  iTermZ=0
  iNout=iSState*iNin
else
  iTermZ=iRState
  iNout=iSState
endif

iNewState=(iTermX+iTermY+iTermZ)%2

xout iNewState,iNout
endop

giChnAT=0
giChnBT=0

giMode1A=0
giMode1B=0
giTBus1=0
giMode2A=0
giMode2B=0
giTBus2=0
giMode3A=0
giMode3B=0
giTBus3=0
giMode4A=0
giMode4B=0
giTBus4=0
giMode5A=0
giMode5B=0
giTBus5=0
giMode6A=0
giMode6B=0
giTBus6=0

; 1 = master updater

instr 1

; force all sliders to round values
giChnAT ForceSlider giChnAT,i(gkChnATVal),giChnATHdl
giChnBT ForceSlider giChnBT,i(gkChnBTVal),giChnBTHdl

giMode1A ForceSlider giMode1A,i(gkMode1AVal),giMode1AHdl
giMode1B ForceSlider giMode1B,i(gkMode1BVal),giMode1BHdl
giTBus1 ForceSlider giTBus1,i(gkTBus1Val),giTBus1Hdl

giMode2A ForceSlider giMode2A,i(gkMode2AVal),giMode2AHdl
giMode2B ForceSlider giMode2B,i(gkMode2BVal),giMode2BHdl
giTBus2 ForceSlider giTBus2,i(gkTBus2Val),giTBus2Hdl

giMode3A ForceSlider giMode3A,i(gkMode3AVal),giMode3AHdl
giMode3B ForceSlider giMode3B,i(gkMode3BVal),giMode3BHdl
giTBus3 ForceSlider giTBus3,i(gkTBus3Val),giTBus3Hdl

giMode4A ForceSlider giMode4A,i(gkMode4AVal),giMode4AHdl
giMode4B ForceSlider giMode4B,i(gkMode4BVal),giMode4BHdl
giTBus4 ForceSlider giTBus4,i(gkTBus4Val),giTBus4Hdl

giMode5A ForceSlider giMode5A,i(gkMode5AVal),giMode5AHdl
giMode5B ForceSlider giMode5B,i(gkMode5BVal),giMode5BHdl
giTBus5 ForceSlider giTBus5,i(gkTBus5Val),giTBus5Hdl

giMode6A ForceSlider giMode6A,i(gkMode6AVal),giMode6AHdl
giMode6B ForceSlider giMode6B,i(gkMode6BVal),giMode6BHdl
giTBus6 ForceSlider giTBus6,i(gkTBus6Val),giTBus6Hdl

; compute new values for stages

iNewState6Val,iStage6N CalcNewState \
  giState5Val,giState6Val,0,1,giState6Val,giMode6A,giMode6B
iNewState5Val,iStage5N CalcNewState \
  giState4Val,giState5Val,giState6Val,iStage6N,giState6Val,giMode5A,giMode5B
iNewState4Val,iStage4N CalcNewState \
  giState3Val,giState4Val,giState5Val,iStage5N,giState6Val,giMode4A,giMode4B
iNewState3Val,iStage3N CalcNewState \
  giState2Val,giState3Val,giState4Val,iStage4N,giState6Val,giMode3A,giMode3B
iNewState2Val,iStage2N CalcNewState \
  giState1Val,giState2Val,giState3Val,iStage3N,giState6Val,giMode2A,giMode2B
iNewState1Val,iStage1N CalcNewState \
  0,giState1Val,giState2Val,iStage2N,giState6Val,giMode1A,giMode1B

; assign stage values, generate triggers
iTrigA=-1
iTrigB=-1
if iNewState1Val!=giState1Val then
  giState1Val=iNewState1Val
  if iNewState1Val==1 then
    FLsetTextColor 255,180,50,giState1Hdl
  else
    FLsetTextColor 0,0,0,giState1Hdl
    if giTBus1==0 && i(gkGate1Val)>iTrigA then
      iTrigA=i(gkGate1Val)
    endif
    if giTBus1==2 && i(gkGate1Val)>iTrigB then
      iTrigB=i(gkGate1Val)
    endif
  endif
  FLsetText "@circle",giState1Hdl
endif
if iNewState2Val!=giState2Val then
  giState2Val=iNewState2Val
  if iNewState2Val==1 then
    FLsetTextColor 255,180,50,giState2Hdl
  else
    FLsetTextColor 0,0,0,giState2Hdl
    if giTBus2==0 && i(gkGate2Val)>iTrigA then
      iTrigA=i(gkGate2Val)
    endif
    if giTBus2==2 && i(gkGate2Val)>iTrigB then
      iTrigB=i(gkGate2Val)
    endif
  endif
  FLsetText "@circle",giState2Hdl
endif
if iNewState3Val!=giState3Val then
  giState3Val=iNewState3Val
  if iNewState3Val==1 then
    FLsetTextColor 255,180,50,giState3Hdl
  else
    FLsetTextColor 0,0,0,giState3Hdl
    if giTBus3==0 && i(gkGate3Val)>iTrigA then
      iTrigA=i(gkGate3Val)
    endif
    if giTBus3==2 && i(gkGate3Val)>iTrigB then
      iTrigB=i(gkGate3Val)
    endif
  endif
  FLsetText "@circle",giState3Hdl
endif
if iNewState4Val!=giState4Val then
  giState4Val=iNewState4Val
  if iNewState4Val==1 then
    FLsetTextColor 255,180,50,giState4Hdl
  else
    FLsetTextColor 0,0,0,giState4Hdl
    if giTBus4==0 && i(gkGate4Val)>iTrigA then
      iTrigA=i(gkGate4Val)
    endif
    if giTBus4==2 && i(gkGate4Val)>iTrigB then
      iTrigB=i(gkGate4Val)
    endif
  endif
  FLsetText "@circle",giState4Hdl
endif
if iNewState5Val!=giState5Val then
  giState5Val=iNewState5Val
  if iNewState5Val==1 then
    FLsetTextColor 255,180,50,giState5Hdl
  else
    FLsetTextColor 0,0,0,giState5Hdl
    if giTBus5==0 && i(gkGate5Val)>iTrigA then
      iTrigA=i(gkGate5Val)
    endif
    if giTBus5==2 && i(gkGate5Val)>iTrigB then
      iTrigB=i(gkGate5Val)
    endif
  endif
  FLsetText "@circle",giState5Hdl
endif
if iNewState6Val!=giState6Val then
  giState6Val=iNewState6Val
  if iNewState6Val==1 then
    FLsetTextColor 255,180,50,giState6Hdl
  else
    FLsetTextColor 0,0,0,giState6Hdl
    if giTBus6==0 && i(gkGate6Val)>iTrigA then
      iTrigA=i(gkGate6Val)
    endif
    if giTBus6==2 && i(gkGate6Val)>iTrigB then
      iTrigB=i(gkGate6Val)
    endif
  endif
  FLsetText "@circle",giState6Hdl
endif

; generate notes
giCVA=i(gkCV1AVal)*giState1Val+i(gkCV2AVal)*giState2Val+ \
  i(gkCV3AVal)*giState3Val+i(gkCV4AVal)*giState4Val+ \
  i(gkCV5AVal)*giState5Val+i(gkCV6AVal)*giState6Val
giCVB=i(gkCV1BVal)*giState1Val+i(gkCV2BVal)*giState2Val+ \
  i(gkCV3BVal)*giState3Val+i(gkCV4BVal)*giState4Val+ \
  i(gkCV5BVal)*giState5Val+i(gkCV6BVal)*giState6Val

if i(gkRetardVal)==1 then
  iRetardVal=iTrigB/1000
else
  iRetardVal=0
endif

if giChnAT==2 then
  event_i "i",2,0,iRetardVal+30/i(gkTempoVal),giCVA,0.8
elseif (giChnAT==1) && (iTrigA>0) then
  event_i "i",2,0,iTrigA/1000,giCVA,0.8
endif
if giChnBT==2 then
  event_i "i",2,0,iRetardVal+30/i(gkTempoVal),giCVB,0.8
elseif (giChnBT==1) && (iTrigB>0) then
  event_i "i",2,0,iTrigB/1000,giCVB,0.8
endif

; generate next beat
event_i "i",1,iRetardVal+60/i(gkTempoVal),0.01

endin

/**********************************************************************/

; 2 = basic synth piano

instr 2

print p4

inote=256*2^(p4/1200)
iveloc=p5

kenv expsegr 0.01,0.005,iveloc,1.5,0.1*iveloc,0.05,0.001
kbenv linsegr 0.9,0.6,0.33,0.05,0

inotea=inote*2^(15/2400)
inoteb=inotea-inote

inotex=inotea*(1-rnd(1)*0.005)
inotey=inotea*(1+rnd(1)*0.005)

aout1s gbuzz kenv*0.25,inotex,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>55?1:2),kbenv*iveloc*1.05,gisintbl,0
aout2s gbuzz kenv*0.55,inotea,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>95?1:2),kbenv*iveloc*1.05,gisintbl,0
aout3s gbuzz kenv*0.25,inotey,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>75?1:2),kbenv*iveloc*1.05,gisintbl,0
aouts=aout1s+aout2s+aout3s

aout1c gbuzz kenv*0.25,inotex,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>55?1:2),kbenv*iveloc*1.05,gicostbl,0
aout2c gbuzz kenv*0.55,inotea,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>95?1:2),kbenv*iveloc*1.05,gicostbl,0
aout3c gbuzz kenv*0.25,inotey,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>75?1:2),kbenv*iveloc*1.05,gicostbl,0
aoutc=aout1c+aout2c+aout3c

amods poscil3 1,inoteb,gisintbl,0
amodc poscil3 1,inoteb,gicostbl,0

alp tonex aouts*amodc-aoutc*amods,6000,5
aout atonex alp,30,5

galeft=galeft+aout
garight=garight+aout

endin

/**********************************************************************/

instr 1000

aleft table3 galeft*0.1,gicliptbl,1,0.5,0
aright table3 garight*0.1,gicliptbl,1,0.5,0

aboth=galeft+garight
galeft=0
garight=0

; krms rms aboth
; if krms>0.01 then
;   dispfft aboth/krms,0.1,4096,0,1
; endif
outs aleft*0.99,aright*0.99
fout "simulator.wav",2,aleft,aright
; fout "audio-fifo",1,aleft,aright

endin

/**********************************************************************/

</CsInstruments>

<CsScore>

i 1000 0 -1

i1 0.01 0.01

e360000

/**********************************************************************/

e 
</CsScore>
</CsoundSynthesizer>
