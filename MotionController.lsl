////Begin MotionController.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Manages motion

integer listener = 0;
key sphereId = NULL_KEY;
integer noHeart = 0;
vector posBuffer = <0.0, 0.0, 0.0>;
key active = NULL_KEY;

goGoPhysicsSphere() {
	llRezObject("Physics Sphere", llGetPos(), <0.0, 0.0, 0.0>, <0.0, 0.0, 0.0, 0.0>, 0);
	llSay(2, swBroadcastCreate("SETTARGET", [active]));
}

default {
	state_entry() {
		llSetTimerEvent(0.3);
	}
	
	link_message(integer sender_num, integer num, string str, key id){
		if(swDecodeCommand(str) == "BOOT") {
			//swBroadcast("SETHELP", ["!debug - Turn debugging on or off."]);
		}
		
		if(swDecodeCommand(str) == "CMD_GO") {
			goGoPhysicsSphere();
		}
		
		if(swDecodeCommand(str) == "FOLLOW") {
			active = (key)swA2S(str, 0);
			llSay(2, swBroadcastCreate("SETTARGET", [(string)sphereId, active]));
		}
		
		if(swDecodeCommand(str) == "STAY") {
			active = NULL_KEY;
			llSay(2, swBroadcastCreate("SETTARGET", [(string)sphereId, active]));
		}
	}
	
	timer() {
		llSay(2, swBroadcastCreate("HEARTBEAT", [(string)sphereId]));
		noHeart ++;
		if(noHeart > 30) {
			goGoPhysicsSphere();
			noHeart = 0;
		}
		if(posBuffer) {
			swBroadcast("POS", [(string)posBuffer]);
		}
	}
	
	on_rez(integer param) {
		llSetText("", <0.0, 0.0, 0.0>, 0.0);
		llResetScript();
	}
	
	object_rez(key id) {
		if(listener) {
			llListenRemove(listener);
		}
		
		llListen(2, "", id, "");
		sphereId = id;
	}
	
	listen(integer channel, string name, key listenId, string msg) {
		posBuffer = swA2V(msg, 1);
		noHeart = 0;
	}
}

////End MotionController.lsl
