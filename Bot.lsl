////Begin Bot.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the man bot unit

default {
	link_message(integer sender_num, integer num, string str, key id){
		if(swDecodeCommand(str) == "INPUT" && llGetSubString(llList2String(swDecodeArgs(str), 0), 0, 0) == "!") {
			//It's a command!
			string commandName = llGetSubString(llList2String(swCutStr(llList2String(swDecodeArgs(str), 0), " "), 0), 1, -1);
			
			//Generic debug command
			if(commandName == "debug") {
				llSay(0, "Hello World!");
			}
		}
	}
}

////End Bot.lsl
