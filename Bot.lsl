////Begin Bot.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the main bot unit

list help = [];
integer on = FALSE;

key ownerKey = NULL_KEY;
string ownerName = "";
vector newPos = ZERO_VECTOR;

integer checkPermission(key toCheck) {
	if(toCheck == CREATOR || toCheck == ownerKey) {
		return TRUE;
	}else{
		return FALSE;
	}
}

setCoreColour(string toSet) {
	vector colour;
	
	if(toSet == "green") {
		colour = <0.3, 1.0, 0.3>;
	}else if(toSet == "blue") {
		colour = <0.3, 0.3, 1.0>;
	}else if(toSet == "red") {
		colour = <1.0, 0.3, 0.3>;
	}else if(toSet == "cyan") {
		colour = <0.3, 1.0, 1.0>;
	}else if(toSet == "magenta") {
		colour = <1.0, 0.3, 1.0>;
	}else if(toSet == "yellow") {
		colour = <1.0, 1.0, 0.3>;
	}
	
	llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, colour, 0.2, PRIM_POINT_LIGHT, TRUE, colour, 0.7, 10.0, 0.0]);
	
}

default {
	state_entry() {
		swBroadcastAll("SETHELP", ["!say text1 [[text2] ...] - Say the arguments."]);
		swBroadcastAll("SETHELP", ["!shout text1 [[text2] ...] - Shout the arguments."]);
		swBroadcastAll("SETHELP", ["!creator - Information about creator."]);
		swBroadcastAll("SETHELP", ["!owner - Says who owns the bot."]);
		swBroadcastAll("SETHELP", ["!die - Bot is removed, and dies."]);
		swBroadcastAll("SETHELP", ["!colour [colour] - Change colour of bot."]);
		swBroadcast("BOOT", []);
		
		newPos = llGetPos();
		llListen(1, "", NULL_KEY, "");
		llSetTimerEvent(0.3);
	}
	
	listen(integer channel, string name, key id, string msg) {
		if(swDecodeCommand(msg) == "STARTUP" && on == FALSE) {
			ownerKey = (key)swA2S(msg, 0);
			ownerName = swA2S(msg, 1);
			setCoreColour(llToLower(swA2S(msg, 2)));
			swBroadcast("FOLLOW", [(string)ownerKey]);
			swBroadcast("IMG", ["blank"]);
			llSetRot(llEuler2Rot(<0.0, 0.0, -PI_BY_TWO*0.5>));
			on = TRUE;
		}
	}
	
	timer() {
		llSetPos(newPos);
	}
		
	
	link_message(integer sender_num, integer num, string str, key id){
		if(swDecodeCommand(str) == "INPUT" && llGetSubString(llList2String(swDecodeArgs(str), 0), 0, 0) == "!") {
			//It's a command!
			string commandName = llToLower(llGetSubString(llList2String(swCutStr(llList2String(swDecodeArgs(str), 0), " "), 0), 1, -1));
			
			//Parse the commands then!
			list args = [];
			string quote = "";
			integer c = 0;
			string buffer = "";
			for(c = llStringLength(commandName)+2; c < llStringLength(swA2S(str, 0)); c ++) {
				string char = llGetSubString(swA2S(str, 0), c, c);
				if(char == " " && quote == "") {
					args += [buffer];
					buffer = "";
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
					buffer += char;
					//args = swModListS(args, llGetListLength(args)-1, llList2String(args, llGetListLength(args)-1)+char);
				}
			}
			
			args += [buffer];
			
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
					llSay(0, "| "+llList2String(help, i));
				}
			}
			
			//Creator info
			if(commandName == "creator") {
				llSay(0, "Some second life robot created by Ross Brunton ("+CREATOR_NAME+") for the Interactive Systems pet project thing.");
			}
			
			//Owner info
			if(commandName == "owner") {
				llSay(0, "This bot is owned by "+ownerName+".");
			}
			
			if(commandName == "ownerKey") {
				llSay(0, (string)ownerKey);
			}
			
			//Death
			if(commandName == "die" && checkPermission(swA2K(str, 1))) {
				llRezObject("Dead Bot", llGetPos(), ZERO_VECTOR, llGetRot(), FALSE);
				llWhisper(1, "BOTDIE");
				llDie();
			}
			
			//Following
			if(commandName == "follow") {
				swBroadcast("FOLLOW", [(string)ownerKey]);
			}
			
			//Stay
			if(commandName == "stay") {
				swBroadcast("STAY", []);
			}
			
			//Colours
			if(commandName == "colour" || commandName == "color") {
				setCoreColour(llToLower(llList2String(args, 0)));
			}
			
			//Super secret turning off
			if(commandName == "to") {
				setCoreColour("");
				on = FALSE;
				swBroadcast("STAY", []);
				swBroadcast("IMG", ["boot"]);
				llSetRot(llEuler2Rot(<0.0, 0.0, 0.0>));
			}
		}
		
		if(swDecodeCommand(str) == "SETHELP") {
			help += [swA2S(str, 0)];
		}
		
		if(swDecodeCommand(str) == "POS") {
			newPos = swA2V(str, 0);
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
