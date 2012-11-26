////Begin Bot.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the main bot unit

//List of all help messages
list help = [];

//If the bot is currently turned on
integer on = FALSE;

//The owner of the bot
key ownerKey = NULL_KEY;
string ownerName = "";

//The bot's position
vector newPos = ZERO_VECTOR;

//This checks permission of key, if it is the owner or me, it returns true
integer checkPermission(key toCheck) {
	if(toCheck == CREATOR || toCheck == ownerKey) {
		return TRUE;
	}else{
		return FALSE;
	}
}

//Sets the colour of the bot's core. Specifying an unsupported colour will make it black.
setCoreColour(string toSet) {
	vector colour = <0.0, 0.0, 0.0>;
	
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
	
	//Particle effects
	if(colour == <0.0, 0.0, 0.0>) {
		llParticleSystem([]);
	}else{
		llParticleSystem([
			PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
			PSYS_PART_START_COLOR, colour,
			PSYS_PART_START_ALPHA, 0.2,
			PSYS_PART_MAX_AGE, 3,
			PSYS_SRC_BURST_RATE, 0.1,
			PSYS_SRC_BURST_PART_COUNT, 1,
			PSYS_SRC_ACCEL, <0.0, 0.0, 0.0>
		]);
	}
			
}

default {
	state_entry() {
		//Set some help messages
		swBroadcastAll("SETHELP", ["!say text1 [[text2] ...] - Say the arguments."]);
		swBroadcastAll("SETHELP", ["!shout text1 [[text2] ...] - Shout the arguments."]);
		swBroadcastAll("SETHELP", ["!creator - Information about creator."]);
		swBroadcastAll("SETHELP", ["!owner - Says who owns the bot."]);
		swBroadcastAll("SETHELP", ["!die - Bot is removed, and dies."]);
		swBroadcastAll("SETHELP", ["!colour [colour] - Change colour of bot."]);
		
		//Send the boot message
		swBroadcast("BOOT", []);
		
		//Set position
		newPos = llGetPos();
		
		//Listen for messages
		llListen(1, "", NULL_KEY, "");
		
		//Set the timer
		llSetTimerEvent(0.3);
	}
	
	listen(integer channel, string name, key id, string msg) {
		//Initial startup, sent by the dispenser
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
		//Update position
		llSetPos(newPos);
	}
		
	
	link_message(integer sender_num, integer num, string str, key id){
		//Chat input, sent from the aerial
		if(swDecodeCommand(str) == "INPUT" && llGetSubString(llList2String(swDecodeArgs(str), 0), 0, 0) == "!") {
			//It's a command!
			string commandName = llToLower(llGetSubString(llList2String(swCutStr(llList2String(swDecodeArgs(str), 0), " "), 0), 1, -1));
			
			//Parse the arguments
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
			if(commandName == "follow" && checkPermission(swA2K(str, 1))) {
				swBroadcast("FOLLOW", [(string)ownerKey]);
			}
			
			//Stay
			if(commandName == "stay" && checkPermission(swA2K(str, 1))) {
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
		
		//Set a new help message
		if(swDecodeCommand(str) == "SETHELP") {
			help += [swA2S(str, 0)];
		}
		
		//Set a new position
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
