state("Tag", "IGF Professional 2008")
{
	int NextLevelNumber: "Tag.exe", 0x16C088, 0x40;
	int StartGame: "Tag.exe", 0x16C094, 0x14;
}

state("Tag", "v1.1")
{
	int NextLevelNumber: "Tag.exe", 0x16D0E8, 0x40;
	int StartGame: "Tag.exe", 0x16D0F4, 0x14;
}

init
{
	int Size = modules.First().ModuleMemorySize;
	
    switch(Size)
    {
        case 1511424: version = "IGF Professional 2008"; print("Tag.asl: detected version IGF Professional 2008"); break;
        case 1515520: version = "v1.1";                  print("Tag.asl: detected version v1.1");                  break;

        default: 

        print("Tag.asl: unknown module size " + Size.ToString());
		MessageBox.Show(timer.Form,
			"Tag autosplitter startup failure:\n\n"
			+ "I could not recognize what version of the game you are running.\n"
			+ "Please talk to Altafen.\n\n"
			+ "Important number: " + Size.ToString(),
			"Tag autosplitter startup failure",
			MessageBoxButtons.OK,
			MessageBoxIcon.Error);
        break;
    }
}

reset
{
	return current.StartGame == 0;
}

start
{
	return old.StartGame == 0 && current.StartGame != 0;
}

split
{
	return current.NextLevelNumber != 0 && old.NextLevelNumber != current.NextLevelNumber;
}
