## This node is intended to be generic and manage the various states in a game.
## Each [State] of a [StateMachine] should be added as a child node of the
## [StateMachine]. Ideally a [StateMachine] should never call its own methods,
## instead being driven by a [State] changing and calling its own helper methods
## to switch state.
@icon("res://addons/dragonforge_state_machine/assets/icons/state_machine_64x64.png")
class_name StateMachine extends Node

## The initial [State] for the [StateMachine]. This can be left blank, in which
## case the [StateMachine] will typically transition when the first [State] that
## is triggered calls [method State.switch_state]
@export var starting_state: State

## If this value is false, this [StateMachine] will not change states. It is
## initially set to true once the [StateMachine] is fully constructed.
var is_running = false
# The node this StateMachine is attached. Not the same as a call to get_owner().
var _owner

# The current State of the StateMachine. Initially defaults to the first node it
# finds beneath itself if starting_state is not defined.
@onready var _current_state: State


# Guarantees this gets run if the node is added after it has been made, or is
# reparented.
func _enter_tree() -> void:
	_owner = get_parent()


# Sets up every [State] for this [StateMachine], and monitors any [State] being
# added or removed to the machine by being added or removed as child nodes
# of this [StateMachine] instance.
func _ready() -> void:
	# Keep intitalization from happening until the parent and all its dependants are constructed.
	# This prevents race conditions from happening where a State needs to reference things that
	# do not exist yet.
	_owner.ready.connect(_on_ready)


func _on_ready() -> void:
	for state in get_children():
		if state is State:
			state._activate_state()
	self.connect("child_entered_tree", _on_state_added)
	self.connect("child_exiting_tree", _on_state_removed)
	
	start()


## Starts the [StateMachine] running. All machines start automatically, but
## they can be stopped at any time by calling [method StateMachine.stop] and
## restarted with [method StateMachine.start].
func start() -> void:
	if get_child_count() <= 0:
		print_rich("[color=red][b]ERROR[/b][/color]: %s State Machine has no States! Failed to start!" % [_owner.name])
		return
	
	is_running = true
	
	if starting_state:
		_current_state = starting_state
		_current_state._enter_state()


## Stops the [StateMachine] from running. Stops the current [State] if one is
## running, even if [member State.can_transition] = false. So be careful with this.
## All machines start automatically, but they can be stopped at any time by
## calling [method StateMachine.stop] and restarted with [method StateMachine.start].
func stop() -> void:
	is_running = false
	
	if _current_state:
		_current_state._exit_state() # Run the exit code for the current state. (Even if the state says you can't exit it.)


## Should ideally be called from [method State.switch_state][br][br]
## Switch to the target [State] from the current [State]. Fails if:[br]
## 1. The [StateMachine] does not have the passed [State].[br]
## 2. The [StateMachine] is already in that [State].[br]
## 3. The current [State] won't allow a transition to happen because its [member State.can_transition] = false.[br]
## 4. The target [State] won't allow a transition to happen because its [member State.can_transition] = false (e.g. cooldown timers).
func switch_state(state: State) -> void:
	if not is_running:
		print_rich("[color=red][b]ERROR[/b][/color]: %s State Machine is off! Cannot enter %s!" % [_owner.name, state.name])
		return # The StateMachine is not running.
	if not _machine_has_state(state): return # The StateMachine does not have the passed state.
	if _current_state == state: return # The StateMachine is already in that state.
	if not state.can_transition: return # The target State won't allow a transition to happen (e.g. cooldown timers).
	
	if _current_state:
		if not _current_state.can_transition: return # The current State won't allow a transition to happen.
		_current_state._exit_state() # Run the exit code for the current state.
	
	_current_state = state # Assign the new state we are transitioning to as the current state.
	_current_state._enter_state() # Run the enter code for the new current state.


## Should ideally be called from [method State.is_current_state][br][br]
## Returns true if the passed [State] is the current [State].
func is_current_state(state: State) -> bool:
	return _current_state == state


# Returns whether or not the StateMachine has this state.
# (A StateMachine has a state if the state is a child node of the StateMachine.)
func _machine_has_state(state: State) -> bool:
	for element in get_children():
		if element == state:
			return true
	return false


# Activates a state.
# (Called when a node enters the tree as a child node of this StateMachine.)
# Accepts all nodes as an argument because this is called whenever a child node
# enters the tree.
func _on_state_added(node: Node) -> void:
	if not node is State:
		return
	node._activate_state()


# Deactivates a state.
# (Called when a child node of this StateMachine leaves the tree.)
# Accepts all nodes as an argument because this is called whenever a child node
# exits the tree.
func _on_state_removed(node: Node) -> void:
	if not node is State:
		return
	node._deactivate_state()
