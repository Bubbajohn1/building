local skins = {}

skins["chroma"] = {
	"XM1014 | Quicksilver",
	"SCAR-20 | Grotto",
	"Glock-18 | Catacombs",
	"M249 | System Lock",
	"MP9 | Deadly Poison",
	"Desert Eagle | Naga",
	"P250 | Muertos",
	"AWP | Man-o'-war",
	"AK-47 | Cartel",
	"M4A4 | Dragon King",
	"Galil AR | Chatterbox",
	knifes = {
		"Gut Knife | Rust Coat",
		"Gut Knife | Ultraviolet",
	},
}

function skins.random(case)
	local skinList = skins[case]
	if not skinList then
		return nil
	end

	return skinList[math.random(#skinList)]
end

return skins
