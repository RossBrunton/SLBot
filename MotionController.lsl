////Begin MotionController.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Manages motion

key active = NULL_KEY;
vector target = <0.0, 0.0, 0.0>;
key targetKey = NULL_KEY;

default {
	state_entry() {
		llSetTimerEvent(0.3);
	}
	
	link_message(integer sender_num, integer num, string str, key id){
		if(swDecodeCommand(str) == "BOOT") {
			swBroadcast("SETHELP", ["!follow - Bot follows owner."]);
			swBroadcast("SETHELP", ["!stay - Bot stays put."]);
		}
		
		if(swDecodeCommand(str) == "FOLLOW") {
			targetKey = (key)swA2S(str, 0);
		}
		
		if(swDecodeCommand(str) == "STAY") {
			targetKey = NULL_KEY;
		}
	}
	
	timer() {
		if(targetKey != NULL_KEY) {
			target = llList2Vector(llGetObjectDetails(targetKey, [OBJECT_POS]), 0) + <3.0, 3.0, 3.0>;
		}
		
		if(target.x != 3.0 && target.y != 0.3 && target.z != 0.3 && target != ZERO_VECTOR) {
			swBroadcast("POS", [target]);
		}
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End MotionController.lsl
