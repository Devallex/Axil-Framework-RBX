return {
	DIRECTORIES = {
		game:GetService("ServerScriptService"),
		game:GetService("ServerStorage"),
		game:GetService("ReplicatedStorage"),
		game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"),
		game:GetService("StarterPlayer"):WaitForChild("StarterCharacterScripts"),
	}
}