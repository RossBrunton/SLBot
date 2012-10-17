////Begin Bot.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the man bot unit

default {
	link_message(integer sender_num, integer num, string str, key id){
		if(swDecodeCommand(str) == "INPUT" && llGetSubString(llList2String(swDecodeArgs(str), 0), 0, 0) == "!") {
			//It's a command!
			string commandName = llGetSubString(llList2String(swCutStr(llList2String(swDecodeArgs(str), 0), " "), 0), 1, -1);
			
			//Parse the commands then!
			list args = [];
			string quote = "";
			integer c = 0;
			for(c = 0; c < llStringLength(swA2S(str, 0)); c ++) {
				string char = llGetSubString(swA2S(str, 0), c, c);
				if(char == " " && quote == "" && llGetListLength(args)) {
					args = (args=[]) + args + [];
				}else{
					args = swModListS(args, llGetListLength(args)-1, llList2String(args, llGetListLength(args)-1)+char);
				}
			}
			
			llSay(0, "Parsed command '"+commandName+"', with arguments "+llDumpList2String(args, "::"));
		
			//Generic debug command
			if(commandName == "debug") {
				llSay(0, "Hello World!");
			}
		}
	}
	
	touch_start (integer this_argument_is_stupid) {
		llSay(0, "This is a bot, say '!help' for help!");
	}
}

////End Bot.lsl
