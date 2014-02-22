<CsoundSynthesizer>
<CsOptions>
-odac -i/dev/null -+rtaudio=alsa -+rtmidi=alsa -s -B4096 -Mhw:3,0
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

/**********************************************************************/

massign 0,0
pgmassign 0,0
massign 0,2

; 2 = basic synth piano

instr 2

inote notnum
inote=cpsmidinn(inote)
iveloc veloc 0,1

ivol midictrl 7,-40,0
ivol=ampdb(ivol)

print inote

kenv expsegr 0.01,0.005,iveloc,1.5,0.27*iveloc,0.07,0.001
kbenv linsegr 0.9,0.6,0.33,0.05,0

inotea=inote*2^(15/2400)
inoteb=inotea-inote

inotex=inotea*(1-rnd(1)*0.005)
inotey=inotea*(1+rnd(1)*0.005)

aout1s gbuzz kenv*0.25,inotex,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>85?1:2),kbenv*iveloc*1.05,gisintbl,0
aout2s gbuzz kenv*0.55,inotea,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>85?1:2),kbenv*iveloc*1.05,gisintbl,0
aout3s gbuzz kenv*0.25,inotey,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>85?1:2),kbenv*iveloc*1.05,gisintbl,0
aouts=aout1s+aout2s+aout3s

aout1c gbuzz kenv*0.25,inotex,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>85?1:2),kbenv*iveloc*1.05,gicostbl,0
aout2c gbuzz kenv*0.55,inotea,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>85?1:2),kbenv*iveloc*1.05,gicostbl,0
aout3c gbuzz kenv*0.25,inotey,(inotea<1000?12:floor(12000/inotea)),\
             (inotea>85?1:2),kbenv*iveloc*1.05,gicostbl,0
aoutc=aout1c+aout2c+aout3c

amods poscil3 1,inoteb,gisintbl,0
amodc poscil3 1,inoteb,gicostbl,0

alp tonex aouts*amodc-aoutc*amods,6400,5
aout atonex alp*ivol,30,5

galeft=galeft+aout
garight=garight+aout

endin

/**********************************************************************/

instr 1000

aleft table3 galeft*0.1,gicliptbl,1,0.5,0
aright table3 garight*0.1,gicliptbl,1,0.5,0

galeft=0
garight=0

outs aleft*0.99,aright*0.99
; fout "piano.wav",2,aleft,aright

endin

/**********************************************************************/

</CsInstruments>

<CsScore>

i 1000 0 36000

/**********************************************************************/

e 
</CsScore>
</CsoundSynthesizer>
