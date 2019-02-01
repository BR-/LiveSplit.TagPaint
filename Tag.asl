/*
WindowClass 108C
LevelNameOffset 5B8
LevelName AD4
4964A3 writes 0
496512 writes name


56D0F8 stores ptr 18FD18
18FD98 seems to stop being null as soon as you click Start Game, so that's a better "start" trigger - looks like it might be address to player struct
18FD28 seems to change as soon as i hit the level end trigger - looks like it might be the color used for the transition
	also gets set to FF1A1A1A on death

56D0E8 stores ptr 18F900, seems useful also (see code 496722)
18F940 is the "next level to load" number, increments immediately when you hit the goal
	written by code 49685A


loading seems almost instant and the 'loading' screen stays up for 0.5s, so I don't think load removal is necessary?
*/

state("Tag") {
	int NextLevelNumber: "Tag.exe", 0x16D0E8, 0x40;
	int StartGame: "Tag.exe", 0x16D0F8, 0x80;
}

/* this is no longer necessary
startup {
	vars.WindowClassAddress = 0x141F1C; // address to "TagTeam"
	vars.WindowTitleAddress = 0x141F24; // address to "Tag: The Power of Paint"
	vars.LevelNameOffset = 0x5B8; // distance between LevelName and WindowClass in GameState struct
}

init {
	var page = game.MainModuleWow64Safe();
	var pWindowClass = page.BaseAddress + vars.WindowClassAddress;
	var pWindowTitle = page.BaseAddress + vars.WindowTitleAddress;
	var bWindowClass = BitConverter.GetBytes(pWindowClass.ToInt32());
	var bWindowTitle = BitConverter.GetBytes(pWindowTitle.ToInt32());
	var signature = new byte[8];
	for (var i = 0; i < 4; ++i) {
		signature[i] = bWindowClass[i];
		signature[i+4] = bWindowTitle[i];
	}
	var target = new SigScanTarget(signature);
	var gamestatePtr = IntPtr.Zero;
	foreach (var mem in memory.MemoryPages()) {
		if (IntPtr.Zero != (gamestatePtr = new SignatureScanner(game, mem.BaseAddress, (int)mem.RegionSize).Scan(target))) {
			break;
		}
	}
	if (gamestatePtr == IntPtr.Zero) {
		Thread.Sleep(1000);
		throw new Exception("Tag autosplitter init - could not find signature");
	}
	vars.level = new StringWatcher(new DeepPointer("Tag.exe",
		(int)gamestatePtr - (int)page.BaseAddress
		- vars.LevelNameOffset, 4), 8); // Name is 4th byte in Level struct. Longest level name is 8.
}

update {
	vars.level.Update(game);
}
*/

reset {
	//return vars.level.Current == "mainmenu";
	return current.StartGame == 0;
}

start {
	//return vars.level.Old == "mainmenu" && vars.level.Current == "level1";
	return old.StartGame == 0 && current.StartGame != 0;
}

split {
	//return vars.level.Old != vars.level.Current;
	return current.NextLevelNumber != 0 && old.NextLevelNumber != current.NextLevelNumber;
}