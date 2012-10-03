////Begin lib.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains common functions needed for all components, place at the start of each file to use them!

//Seperator for data passed between components
string SEPERATION_CHAR = "\t";

//Given a string that consists of values seperated with a character, it will return those values in a list.
list swCutStr(string str, string cutter) {
	return llParseString2List(str, [cutter], []);
}

//Parses a string that is a message and gets it's command, returns "INVALID" if the string cannot be parsed
//Not complete
string swDecodeCommand(string message) {
	return llList2String(swCutStr(message, SEPERATION_CHAR), 0);
}

//Parses a string that is a message and gets it's arguments, returns [] if the string cannot be parsed
//Not complete
list swDecodeArgs(string message) {
	list args = swCutStr(message, SEPERATION_CHAR);
	return llDeleteSubList(args, 0, 0);
}

//Broadcasts a message to all other objects
swBroadcast(string command, list args) {
	llMessageLinked(LINK_ALL_OTHERS, 0, command+SEPERATION_CHAR+llDumpList2String(args, SEPERATION_CHAR), NULL_KEY);
}

////End lib.lsl
