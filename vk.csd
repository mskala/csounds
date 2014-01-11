<CsoundSynthesizer>
<CsOptions>
-odac -+rtaudio=alsa -+rtmidi=virtual -s -B4096 -Mkeyboard.map
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

/***** MIDI DISPATCHER *****/

; general MIDI map - not used b/c of virtual keyboard mapping silliness
; giinstrmap ftgen 200,0,128,-2, \
;     2 -1 -1 -1 -1 -1 -1 -1 /* 0-7 piano */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 8-15 chromatic percussion */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 16-23 organ */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 24-31 guitar */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 32-39 bass */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 40-47 strings */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 48-55 ensemble */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 56-63 brass */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 64-71 reed */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 72-79 pipe */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 80-87 synth lead */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 88-95 synth pad */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 96-103 synth effects */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 104-111 ethnic */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 112-119 percussive */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 120-127 sound effects */

giinstrmap ftgen 200,0,32,-2, \
  2,3,4,5,11,12,13

massign 0,0
pgmassign 0,0
massign 0,1

instr 1

ichn midichn
inote notnum
iveloc veloc 0,1

; FIXME map note
imapnote=cpsmidinn(inote)

; velocity kludge for virtual keyboard
ivo ctrl7 ichn,7,0,1
iveloc=(ivo>0?ivo:iveloc)

midiprogramchange p4
instnum table p4,giinstrmap
instnum=instnum+ichn/32+inote/8192

print imapnote,iveloc
event_i "i",instnum,0,-1,imapnote,iveloc

krel release
if krel==1 then
  event "i",-instnum,0,1
endif

endin

/**********************************************************************/

; 2 = basic synth piano

instr 2

inote=p4
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

; 3 = sawtooth wave
instr 3

inote=p4
iveloc=p5

kenv linsegr 0,0.05,iveloc,0.05,0

aout poscil3 kenv*0.35,inote,gisawtbl,rnd(1)

galeft=galeft+aout
garight=garight+aout

endin

; 4 = sine wave
instr 4

inote=p4
iveloc=p5

kenv linsegr 0,0.05,iveloc,0.05,0

aout poscil3 kenv*0.85,inote,gisintbl,rnd(1)

galeft=galeft+aout
garight=garight+aout

endin

; 5 = square wave
instr 5

inote=p4
iveloc=p5

kenv linsegr 0,0.05,iveloc,0.05,0

aout poscil3 kenv*0.35,inote,gisquaretbl,rnd(1)

galeft=galeft+aout
garight=garight+aout

endin

/**********************************************************************/


instr 11

inote=p4
iveloc=p5

kenv expsegr 0.2,0.25,1,0.25,0.05
kbenv linsegr 0,0.5,1,0.5,0

kfilt expseg 1000,5,25000
a1 poscil3 kenv,inote,gisawtbl,rnd(1)
a3 poscil3 kbenv*0.20,34224/inote,gisquaretbl,rnd(1)
a2 lowpass2 a1+a3,kfilt,2

galeft=galeft+a2*(0.17+0.03*kenv)
garight=garight+a2*(0.12-0.03*kenv)

endin

instr 12

inote=p4
iveloc=p5

iscpos = log(inote/255)/log(427/256)

kenv linsegr 0,0.25,1,0.25,0
kbenv linsegr 0,0.5,1,0.5,0

kmod poscil3 0.06,20,gisintbl,rnd(1)
a1 poscil3 kenv*0.25,inote*exp(kmod*kenv*log(2)/12),gisheptbl,rnd(1)
a2 poscil3 kbenv*0.07,34224/inote,gisawtbl,rnd(1)

galeft=galeft+(a1+a2)*iscpos
garight=garight+(a1+a2)*(1-iscpos)

endin

instr 13

inote=p4
iveloc=p5

kenv expsegr 0.2,0.25,1,0.25,0.05
kbenv linsegr 0,0.5,1,0.5,0

a1a poscil3 kenv*0.076,inote*0.996,gisquaretbl,rnd(1)
a1b poscil3 kenv*0.076,inote,gisquaretbl,rnd(1)
a1c poscil3 kenv*0.076,inote*1.004,gisquaretbl,rnd(1)
alo poscil3 kbenv*0.017,34224/inote,gisintbl,rnd(1)

aranda random 0,1
arandb1 random -1,1
arandb2 random -1,1
arandb3 random -1,1

a3 fog kenv*0.009,150,inote*2*exp((arandb1+arandb2+arandb3)*log(2)*0.04) \
                    *(ftlen(gisquaretbl)/sr),aranda, \
       0,0,0.01,0.1,0.01,200,gisquaretbl,girisetbl,p3

a2 lowpass2 a1a+a1b+a1c+alo,2048*exp(kenv*2*log(2)),1+3*kenv
a4 lowpass2 a3,2048*exp(kenv*2*log(2)),1+3*kenv

galeft=galeft+0.3*a2+0.7*a4
garight=garight+0.7*a2+0.3*a4

endin

/**********************************************************************/

instr 1000

aleft table3 galeft*0.1,gicliptbl,1,0.5,0
aright table3 garight*0.1,gicliptbl,1,0.5,0

aboth=galeft+garight
galeft=0
garight=0

krms rms aboth
if krms>0.01 then
  dispfft aboth/krms,0.1,4096,0,1
endif
outs aleft*0.99,aright*0.99
fout "vk.wav",2,aleft,aright

endin

/**********************************************************************/

</CsInstruments>

<CsScore>

i 1000 0 3600

/**********************************************************************/

e 
</CsScore>
</CsoundSynthesizer>
