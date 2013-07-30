/*------------------------------------------------------------------------------------------------*/
//re-using SC140 projects

// 01
// Nathaniel Virgo
~s1 = {LocalOut.ar(a=CombN.ar(BPF.ar(LocalIn.ar(2)*7.5+Saw.ar([32,33],0.2),2**LFNoise0.kr(4/3,4)*300,0.1).distort,2,2,40));a}.play//#supercollider
~s1.free

// 02
// LFSaw
~s2 = {Splay.ar(Ringz.ar(Impulse.ar([2, 1, 4], [0.1, 0.11, 0.12]), [0.1, 0.1, 0.5])) * EnvGen.kr(Env([1, 1, 0], [120, 10]), doneAction: 2)}.play
~s2.free

// 05
// Batuhan Bozkurt
~s3 = play{f=LocalIn.ar(2).tanh;k=Latch.kr(f[0].abs,Impulse.kr(1/4));LocalOut.ar(f+CombC.ar(Blip.ar([4,6],100*k+50,0.9),1,k*0.3,50*f));f}//44.1kHz
~s3.free

// 07
// Thor Magnusson
~s4 = play{x=SinOsc;y=LFNoise0;a=y.ar(8);(x.ar(Pulse.ar(1)*24)+x.ar(90+(a*90))+MoogFF.ar(Saw.ar(y.ar(4,333,666)),a*XLine.ar(1,39,99,99,0,2)))!2/3}
~s4.free

// 13
// Batuhan Bozkurt
~s5 = play{LeakDC.ar(BRF.ar(Saw.ar(8,Decay2.kr(x=Duty.kr(1/8,0,Drand([0,Drand((0.4,0.5..1))],inf)),0.01,0.3))**1.5,x*20+[45.1,45],0.1)).tanh}//#sc
~s5.free

// 16
// Batuhan Bozkurt
~s6 = play{AllpassC.ar(SinOsc.ar(55).tanh,0.4,TExpRand.ar(2e-4, 0.4,Impulse.ar(8)).round([2e-3,4e-3]),2)};// #supercollider with bass please...
~s6.free

