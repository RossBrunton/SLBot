////Begin Bot.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the main bot unit

list help = [];

default {
	state_entry() {
		swBroadcastAll("SETHELP", ["!say text1 [[text2] ...] - Say the arguments."]);
		swBroadcastAll("SETHELP", ["!shout text1 [[text2] ...] - Shout the arguments."]);
		swBroadcastAll("SETHELP", ["!creator - Information about creator."]);
		swBroadcast("BOOT", []);
	}
	
	link_message(integer sender_num, integer num, string str, key id){
		if(swDecodeCommand(str) == "INPUT" && llGetSubString(llList2String(swDecodeArgs(str), 0), 0, 0) == "!") {
			//It's a command!
			string commandName = llToLower(llGetSubString(llList2String(swCutStr(llList2String(swDecodeArgs(str), 0), " "), 0), 1, -1));
			
			//Parse the commands then!
			list args = [""];
			string quote = "";
			integer c = 0;
			for(c = llStringLength(commandName)+2; c < llStringLength(swA2S(str, 0)); c ++) {
				string char = llGetSubString(swA2S(str, 0), c, c);
				if(char == " " && quote == "" && llGetListLength(args)) {
					args = (args=[]) + args + [""];
				}else if(char == "'") {
					if(quote == "'") {
						quote = "";
					}else{
						quote = "'";
					}
				}else if(char == "\"") {
					if(quote == "\"") {
						quote = "";
					}else{
						quote = "\"";
					}
				}else{
					args = swModListS(args, llGetListLength(args)-1, llList2String(args, llGetListLength(args)-1)+char);
				}
			}
			
			//Broadcast the command to other components
			swBroadcast("CMD_"+llToUpper(commandName), args);
			
			//Say/Shout command
			if(commandName == "say" || commandName == "shout") {
				integer i;
				for(i = 0; i < llGetListLength(args); i ++) {
					if(commandName == "shout") {
						llShout(0, llList2String(args, i));
					}else{
						llSay(0, llList2String(args, i));
					}
				}
			}
			
			//Help
			if(commandName == "help") {
				llSay(0, "-- List of Commands --");
				integer i;
				for(i = 0; i < llGetListLength(help); i ++) {
					llSay(0, llList2String(help, i));
				}
			}
			
			//Creator info
			if(commandName == "creator") {
				llSay(0, "Some second life robot created by Ross Brunton ("+CREATOR_NAME+") for the Interactive Systems pet project thing.");
			}
		}
		
		if(swDecodeCommand(str) == "SETHELP") {
			help += [swA2S(str, 0)];
		}
	}
	
	touch_start (integer this_argument_is_stupid) {
		llSay(0, "This is a bot, say '!help' for help!");
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End Bot.lsl
