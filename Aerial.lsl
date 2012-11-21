////Begin Aerial.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Takes chat input, and messages that to all other objects

default {
	state_entry() {
		//Listen for all messages on public chat
		llListen(0, "", "", "");
	}

	listen(integer channel, string name, key id, string message) {
		//Check we have not said the message ourself; loop through all objects and check the key of the sender
		integer o;
		for(o = llGetObjectPrimCount(llGetKey()); o >= 0; o--) {
			if(llGetLinkKey(o) == id) {
				return;
			}
		}
        
		//Broadcast the message to other components
		swBroadcast("INPUT", [message, (string)id]);
	}
}

////End Arial.lsl
