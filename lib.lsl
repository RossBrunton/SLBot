////Begin lib.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains common functions needed for all components, place at the start of each file to use them!

//Seperator for data passed between components
string SEPERATION_CHAR = "\t";

//Creator data
key CREATOR = "7603f799-3e62-429e-9388-f1cf54cb0a0d";
string CREATOR_NAME = "SavageWolf8 Resident";

//I can't find any function that will allow you to modify elements of an array in place, so I'll have to do this...
//This function replaces element n with new.
//// base - The source array
//// n - The index to set
//// new - The new data to set at that index
//// return - The base list with the element at index n replaced with the string new.
list swModListS(list base, integer n, string new) {
	return llListReplaceList(base, [new], n, n);
}

//Given a string that consists of values seperated with a character, it will return those values in a list.
//// str - The string to cut
//// cutter - The character to slice by
//// return - A list, from breaking str along cutter
list swCutStr(string str, string cutter) {
	return llParseString2List(str, [cutter], []);
}

//Parses a string that is a message and gets it's command, returns "INVALID" if the string cannot be parsed
//Not complete, doesn't validate
//// message - A message from another bot component
//// return - The name of the command that was requested, or "INVALID"
string swDecodeCommand(string message) {
	return llList2String(swCutStr(message, SEPERATION_CHAR), 0);
}

//Parses a string that is a message and gets it's arguments, returns [] if the string cannot be parsed. First element will NOT be the command name.
//Not complete, doesn't validate
//// message - A message from another bot component
//// return - A list of all the arguments for the requested command, all elements are strings
list swDecodeArgs(string message) {
	list args = swCutStr(message, SEPERATION_CHAR);
	return llDeleteSubList(args, 0, 0);
}

//Type specific versions that call llList2Whatever of the swDecodeArgs function
//// message - A message from another bot component
//// index - The number of the argument to return
//// return - The argument in the indexth position, converted to string
string swA2S(string message, integer index) {
	return llList2String(swDecodeArgs(message), index);
}

//// message - A message from another bot component
//// index - The number of the argument to return
//// return - The argument in the indexth position, converted to integer
integer swA2I(string message, integer index) {
	return llList2Integer(swDecodeArgs(message), index);
}

//Broadcasts a message to all other objects. Will not be sent to the caller
//// command - The command to request other components to run.
//// args - A list of arguments to send with the message
swBroadcast(string command, list args) {
	llMessageLinked(LINK_ALL_OTHERS, 0, command+SEPERATION_CHAR+llDumpList2String(args, SEPERATION_CHAR), NULL_KEY);
}

//Broadcasts a message to all other objects. Will be sent to the caller
//// command - The command to request other components to run.
//// args - A list of arguments to send with the message
swBroadcastAll(string command, list args) {
	llMessageLinked(LINK_SET, 0, command+SEPERATION_CHAR+llDumpList2String(args, SEPERATION_CHAR), NULL_KEY);
}

////End lib.lsl
