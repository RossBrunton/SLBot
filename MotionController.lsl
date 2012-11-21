////Begin MotionController.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Manages motion

//This is where we are going
vector target = <0.0, 0.0, 0.0>;

//This is the key we are heading to
key targetKey = NULL_KEY;

default {
	state_entry() {
		//Set the timer
		llSetTimerEvent(0.2);
	}
	
	link_message(integer sender_num, integer num, string str, key id){
		//Boot up the robot, and add help messages
		if(swDecodeCommand(str) == "BOOT") {
			swBroadcast("SETHELP", ["!follow - Bot follows owner."]);
			swBroadcast("SETHELP", ["!stay - Bot stays put."]);
		}
		
		//Set the bot to follow someone
		if(swDecodeCommand(str) == "FOLLOW") {
			targetKey = swA2K(str, 0);
		}
		
		//Sets the bot to stay still
		if(swDecodeCommand(str) == "STAY") {
			targetKey = NULL_KEY;
		}
	}
	
	timer() {
		//Set the target were we are heading
		if(targetKey != NULL_KEY) {
			target = llList2Vector(llGetObjectDetails(targetKey, [OBJECT_POS]), 0) + <3.0, 3.0, 3.0>;
		}
		
		//And head there
		if(target.x != 3.0 && target.y != 0.3 && target.z != 0.3 && target != ZERO_VECTOR
		&& target.x > 0.0 && target.x < 256.0 && target.y > 0.0 && target.y < 256.0 && target.z > 0.0 && target.z < 256.0) {
			swBroadcast("POS", [target]);
		}
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End MotionController.lsl
