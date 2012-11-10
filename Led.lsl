////Begin Led.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the LED display

//From: http://wiki.secondlife.com/wiki/StringReverse
string uStringReverse( string vStrSrc ){
    integer vIntCnt = llStringLength( vStrSrc );
    while (vIntCnt){
        vStrSrc += llGetSubString( vStrSrc, (vIntCnt = ~-vIntCnt), vIntCnt );
    }
    return llGetSubString( vStrSrc, llStringLength( vStrSrc ) >> 1, 0xFFFFFFFF );
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--                                                                 --//*/

//List of all the LED displays
list DISPLAYS = [
	"blank:0000000000000000000000000000000000000000000000000000000000000000",
	"borders:1111111100000000000000000000000000000000000000000000000011111111",
	"stripes:1010101010101010101010101010101010101010101010101010101010101010",
	"creeper:0000000001100110011001100001100000111100001111000010010000000000"
];

//Start index
integer START = 75;

//Display an image
drawImage(string image) {
    //Loop through all images looking for one with the name we want
    integer d;
    for(d = llGetListLength(DISPLAYS)-1; d >= 0; d --) {
        //Break apart the string into a list, containing [name, data]
        list fragments = llParseString2List(llList2String(DISPLAYS, d), [":"], []);
        
        if(llList2String(fragments, 0) == image) {
            //Yes, we found one, now get it's data!
            string data = uStringReverse(llList2String(fragments, 1));
            integer i;
            
            //And loop through all the prims and have them set their colour as appropriate
            for(i = 65; i >= 0; i --) {
                if(llGetSubString(data, 65-i, 65-i) == "1") {
                    llSetLinkColor(START-i, <1, 0, 0>, ALL_SIDES);
                }else{
                    llSetLinkColor(START-i, <0, 0, 0>, ALL_SIDES);
                }
            }
        }
    }
}


default {
	state_entry() {
		drawImage("blank");
	}
	
	link_message(integer sender_num, integer num, string str, key id){
		if(swDecodeCommand(str) == "CMD_IMG" || swDecodeCommand(str) == "IMG") {
			drawImage(swA2S(str, 0));
		}
		
		if(swDecodeCommand(str) == "BOOT") {
			swBroadcast("SETHELP", ["!img [image] - Display an image."]);
			drawImage("blank");
		}
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End Led.lsl
