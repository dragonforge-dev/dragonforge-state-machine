@icon("res://addons/dragonforge_state_machine/assets/icons/state_icon_64x64_white.png")
class_name State extends Node
# A abstract virtual state for states to implement.

## A reference to the state machine used for switching states.
var state_machine: StateMachine
## Set to false if this state cannot be transitioned to.
## For example when waiting for a cooldown timer to expire, when a
## character is dead, or when the splash screens have been completed.
var can_transition = true
## The name of the parent node of the state_machine. Stored for logging purposes.
## NOTE: This is not guaranteed to be the same as get_owner().name
var _owner_name: String


## Guarantees this gets run if the node is added after it has been made, or is
## reparented.
func _enter_tree() -> void:
	state_machine = get_parent()
	_owner_name = state_machine.get_parent().name


## Asks the state machine to switch to this state. Should always be used instead of _enter_state()
## when a state wants to switch to itself.
## Helper function.
func switch_state() -> void:
	state_machine.switch_state(self)


## Returns true if this is the current state.
## Helper function.
func is_current_state() -> bool:
	return state_machine.is_current_state(self)


## Called when the state is added to a state machine.
func _activate_state() -> void:
	print_rich("[color=forest_green][b]Activate[/b][/color] [color=gold][b]%s[/b][/color] [color=ivory]%s State:[/color] %s" % [_owner_name, state_machine.name, self.name])


## Called when a state is removed from a state machine.
func _deactivate_state() -> void:
	print_rich("[color=#d42c2a][b]Deactivate[/b][/color] [color=gold][b]%s[/b][/color] [color=ivory]%s State:[/color] %s" % [_owner_name, state_machine.name, self.name])


## Called every time the state is entered.
func _enter_state() -> void:
	print_rich("[color=deep_sky_blue][b]Enter[/b][/color] [color=gold][b]%s[/b][/color] [color=ivory]%s State:[/color] %s" % [_owner_name, state_machine.name, self.name])


## Called every time the state is exited.
func _exit_state() -> void:
	print_rich("[color=dark_orange][b]Exit[/b][/color] [color=gold][b]%s[/b][/color] [color=ivory]%s State:[/color] %s" % [_owner_name, state_machine.name, self.name])
