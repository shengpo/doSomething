/*------------------------------------------------------------------------------------------------*/

//send OSC message to Processing (visual program of doSomething_playground)
n = NetAddr("127.0.0.1", 12000);     	//remote端IP and OSC port
n.stop

n.sendMsg('/switchBackground');
n.sendMsg('/toggleBackground');
n.sendMsg('/fadeoutBackground');

n.sendMsg('/changeMode', 1);
n.sendMsg('/changeMode', 2);
n.sendMsg('/changeMode', 3);
n.sendMsg('/changeMode', 4);

n.sendMsg('/trigger');

n.sendMsg('/changeCubeCount', -1); //random from 1 ~ 7
n.sendMsg('/changeCubeCount', 90); //assign the count you want

n.sendMsg('/changeWaveLineCircleMode'); //change random mode

n.sendMsg('/toggleTunnel');

n.sendMsg('/toggleWireframe');

n.sendMsg('/toggleParticle');

n.sendMsg('/clearParticles');

/*------------------------------------------------------------------------------------------------*/
