////Begin Physics.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Powers the physics ball, which controls the motion of the bot.

vector target = <0.0, 0.0, 0.0>;
key targetKey = NULL_KEY;
integer noHeart = 0;

default {
	state_entry() {
		llSetTimerEvent(0.3);
		llListen(2, "MotionController", NULL_KEY, "");
	}

	timer() {
		if(targetKey) {
			llMoveToTarget(llList2Vector(llGetObjectDetails(targetKey, [OBJECT_POS]), 0) + <5.0, 5.0, 5.0>, 0.5);
		}
		
		noHeart ++;
		if(noHeart > 30) {
			llDie();
		}
	}
	
	listen(integer channel, string name, key listenId, string msg) {
		if(swDecodeCommand(msg) == "HEARTBEAT" && (key)swA2S(msg, 0) == llGetKey()) {
			noHeart = 0;
			llSay(2, swBroadcastCreate("SPHEREPOS", [(string)llGetKey(), (string)llGetPos()]));
		}
		
		if(swDecodeCommand(msg) == "SETTARGET" && (key)swA2S(msg, 0) == llGetKey()) {
			targetKey = (key)swA2S(msg, 1);
		}
	}
	
	on_rez(integer param) {
		llSetText("", <0.0, 0.0, 0.0>, 0.0);
		llResetScript();
	}
}

////End Physics.lsl
