//open doSomething_playground program
"doSomething_playground".unixCmd;

//SC server
s.boot;
s.quit;
Server.local.makeWindow;

/*------------------------------------------------------------------------------------------------*/
//live coding

(
SynthDef(\bleep,{ arg out=0, note=60, amp=0.5, pan=0.0;
	var freq, env;
	freq = note.midicps;
	env = EnvGen.ar(
					Env([0,1,1,0],[0.01, 0.1, 0.2]),
					levelScale:amp,
					doneAction:2
				);
	Out.ar(out,
		Pan2.ar(Blip.ar(freq) * env, pan)
	)
}).send(s);
)


(
t = Task.new({
		inf.do({ arg i;
//			Synth(\bleep, [\note, 36+(2.3*(i%17))]);
//			0.5.wait;

   		Synth(\bleep,
			[\note, (#[0,2,4,5,7,9] + 48).choose,
				\pan, 1.0.rand2
			]
		);

		[0.5,1,1.5,0.75].choose.wait;
		});
});
)

t.play(SystemClock); //開始task
//t.play(TempoClock(1.4)); //開始task
t.pause;  //暂停
t.resume;  //繼續
t.reset;





