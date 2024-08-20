extends Node

var items = {
	"armor": true,
	"spear_upgrade": false,
	"grapple": false,
	"item4": false,
	"wings": true
}

var flight_stamina = 0.0
var scales = 10
var dead = false
var armor_used = false
var burnt = false

func reset():
	items = {
		"armor": true,
		"spear_upgrade": false,
		"grapple": false,
		"item4": false,
		"wings": true
	}
	flight_stamina = 0.0
	scales = 0
	dead = false
	armor_used = false
	burnt = false

func save_player_state(player):
	items = player.items.duplicate()
	flight_stamina = player.flight_stamina
	scales = player.scales

func load_player_state(player):
	player.items = items.duplicate()
	player.flight_stamina = flight_stamina
	player.scales = scales
	player.dead = false
	player.armor_used = false
	player.burnt = false
