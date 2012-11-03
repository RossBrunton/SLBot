////Begin Debug.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// When attached to robot broadcasts debugging stuff

integer debug = FALSE;

default {
	link_message(integer sender_num, integer num, string str, key id){
		//Send debugging messages
		if(debug == TRUE) {
			llWhisper(1, (string)sender_num+" > "+str);
		}
		
		if(swDecodeCommand(str) == "CMD_DEBUG") {
			if(debug) {
				debug = FALSE;
				llSay(1, "Debugging is now off.");
			}else{
				debug = TRUE;
				llSay(0, "Debugging is now on, it runs on channel 1.");
			}
		}
		
		if(swDecodeCommand(str) == "BOOT") {
			swBroadcast("SETHELP", ["!debug - Turn debugging on or off."]);
		}
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End Debug.lsl
