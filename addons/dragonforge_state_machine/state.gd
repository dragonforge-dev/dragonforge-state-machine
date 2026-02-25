## An abstract virtual state for states to implement and add to a [StateMachine].[br]
## [b]NOTE:[/b] The following are turned off by default:[br]
## - process()[br]
## - physics_process()[br]
## - input()[br]
## - unhandled_input()[br]
## If you want to turn any of these on, do so in [method State._activate_state].
## Be sure to call [method super] on the first line of your method.
@icon("res://addons/dragonforge_state_machine/assets/textures/icons/state_icon_64x64_white.png")
class_name State extends Node

## Set to false if this [State] cannot be transitioned to (or alternately, from).
## For example when waiting for a cooldown timer to expire, when a
## character is dead, or when the splash screens have been completed.
var can_transition = true
# A reference to the state machine used for switching states.
var _state_machine: StateMachine
# Used when deactivating a state and the [StateMachine] has already been deleted.
var _state_machine_name: String
# The name of the parent node of the StateMachine. Stored for logging purposes.
# NOTE: This is not guaranteed to be the same as get_owner().name
var _subject_name: String


## Turns off the _process(), _phsyics_process(), _input() and _unhandled_input()
## functions. If you want to use them for a [State] you can turn them on in the
## _activate_state() function, or turned on and off in _enter_state() and
## _exit_state()
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)


## Asks the [StateMachine] to switch to this [State]. Should always be used
## instead of calling _enter_state() when a [State] wants to switch to itself.
func switch_state() -> void:
	_state_machine.switch_state(self)


## Asks the [StateMachine] to exit this [State] if it is the current [State].
## Should always be used instead of calling _exit_state() when a [State] wants
## to exit. Will fail if the current [State] is not this one.
func clear_state() -> void:
	if is_current_state():
		_state_machine.clear_state()


## Returns true if this is the current [State].
func is_current_state() -> bool:
	return _state_machine.is_current_state(self)


## Returns the [StateMachine]'s current [State]. Intended for type checking.
## E.G. if you wanted to only switch to a custom [b]JumpState[/b] state when the
## "jump" action is pressed and the player is not in a custom [b]FallState[/b],
## as long as the FallState had [b]class_name FallState[/b] at the top of the
## script, you could write:
## [codeblock]
## func _process(delta: float) -> void:
## 	if Input.is_action_just_pressed("jump") and not get_current_state() is FallState:
## 		switch_state()
## [/codeblock]
func get_current_state() -> State:
	return _state_machine._current_state


## Called when the [State] is added to a [StateMachine].
## This should be used for initialization instead of _ready() because it is
## guaranteed to be run [i]after[/i] all of the nodes that are in the owner's 
## tree have been constructed - preventing race conditions.
## [br][br][color=yellow][b]WARNING:[/b][/color]
## [br]When overriding, be sure to call [method super] on the first line of your method.
## [br][i]Never[/i] call this method directly. It should only be used by the [StateMachine]
func _activate_state() -> void:
	_state_machine = get_parent()
	_state_machine_name = _state_machine.name
	_subject_name = _state_machine.subject.name
	if _state_machine.print_state_changes:
		print_rich("[color=forest_green][b]Activate[/b][/color] [color=gold][b]%s[/b][/color] [color=ivory]%s State:[/color] [color=forest_green]%s[/color]" % [_subject_name, _state_machine_name, self.name])


## Called when a [State] is removed from a [StateMachine].
## [br][br][color=yellow][b]WARNING:[/b][/color]
## [br]When overriding, be sure to call [method super] on the first line of your method.
## [br][i]Never[/i] call this method directly. It should only be used by the [StateMachine]
func _deactivate_state() -> void:
	if _state_machine.print_state_changes:
		print_rich("[color=#d42c2a][b]Deactivate[/b][/color] [color=gold][b]%s[/b][/color] [color=ivory]%s State:[/color] [color=#d42c2a]%s[/color]" % [_subject_name, _state_machine_name, self.name])


## Called every time the [State] is entered.
## [br][br][color=yellow][b]WARNING:[/b][/color]
## [br]When overriding, be sure to call [method super] on the first line of your method.
## [br][i]Never[/i] call this method directly. It should only be used by the [StateMachine]
func _enter_state() -> void:
	if _state_machine.print_state_changes:
		print_rich("[color=deep_sky_blue][b]Enter[/b][/color] [color=gold][b]%s[/b][/color] [color=ivory]%s State:[/color] [color=deep_sky_blue]%s[/color]" % [_subject_name, _state_machine_name, self.name])


## Called every time the [State] is exited.
## [br][br][color=yellow][b]WARNING:[/b][/color]
## [br]When overriding, be sure to call [method super] on the first line of your method.
## [br][i]Never[/i] call this method directly. It should only be used by the [StateMachine]
func _exit_state() -> void:
	if _state_machine.print_state_changes:
		print_rich("[color=dark_orange][b]Exit[/b][/color] [color=gold][b]%s[/b][/color] [color=ivory]%s State:[/color] [color=dark_orange]%s[/color]" % [_subject_name, _state_machine_name, self.name])
