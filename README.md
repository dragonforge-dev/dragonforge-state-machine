[![Static Badge](https://img.shields.io/badge/Godot%20Engine-4.5.stable-blue?style=plastic&logo=godotengine)](https://godotengine.org/)

# Dragonforge State Machine <img src="/addons/dragonforge_state_machine/assets/textures/icons/state_machine_64x64.png" width="32" alt="State Machine Icon"/>
A base state machine class to be used in games.
# Version 0.5
For use with **Godot 4.5.stable** and later.
# Installation Instructions
1. Copy the `dragonforge_state_machine` folder from the `addons` folder into your project's `addons` folder.
2. In your project go to **Project -> Reload Current Project**
3. Wait for the project to reload.

# Usage Instructions
To use the **StateMachine** and **State** classes, you add a **StateMachine** to the **Node** you want it to control. Then you add a **State** node to the **StateMachine** for each state that you want the object to have.

## State Machine
1. Add a new node as you would normally. (The **Create New Node** window will appear.)
2. Type `state` into the Search box.
3. Select **StateMachine**.
4. Click the **Create** button.

## State <img src="/addons/dragonforge_state_machine/assets/textures/icons/state_icon_64x64_white.png" width="32" alt="State Icon"/>
1. Add a new node as you would normally. (The **Create New Node** window will appear.)
2. Type `state` into the Search box.
3. Select **State**.
4. Click the **Create** button.

# Class Descriptions
## StateMachine <img src="/addons/dragonforge_state_machine/assets/textures/icons/state_machine_64x64.png" width="32" alt="State Machine Icon"/>
While there are a number of public functions, this class is not intended to be changed or operated directly. All state switching happens from the **State** class.

This state machine is intended to be a "pull" machine instead of a "push" machine. Based on the Kanban principle of only pulling work when it's available. This means that instead of the **StateMachine** telling classes when they take over, the **State** class is implemented to tell the **StateMachine** when it wants to start up. This means that all the logic for switching is stored in the **State**. This keeps states modular, and means you can add or remove them from a **StateMachine** without breaking anything or having to rewrite code.

As such, even though there are public methods and variables, they are meant to only be accessed by **State** nodes. If there was a `protected` scope, StateMachine would fall into that scope - only accessible by **State**. So there is no documentation on how to use it because you are not supposed to use it. If you are curious how it works, the code is well-documented.

### Signals
- `state_changed` Emitted when state is changed.

### Export Variables
- `starting_state: State` The initial **State** for the **StateMachine**. This can be left blank, in which case the **StateMachine** will typically transition when the first **State** that is triggered calls **State.switch_state**
- `autostart: bool = true` By default, the **StateMachine** is started automatically, unless this flag is turned off. In such case, to start the **StateMachine** manually, both **initialize** and **start** need to be called.
- `print_state_changes: bool = true` By default, **State** status changes are printed to the console, unless this flag is turned off.

### Public Functions
- `add_state(state: State) -> void` Adds **state** as a child to the **StateMachine** and immediately activates it.
- `remove_state(state: State) -> void` Removes **state** from the **StateMachine** and immediately deactivates it.
- `set_arg(arg: StringName, value: bool = true) -> void` Adds an argument **arg** to the **_args** **Dictionary** with **value** that can be used for communication between **State**s.
- `remove_arg(arg: StringName) -> void` Removes an argument **arg** from the **_args** **Dictionary**.
- `is_arg(arg: StringName) -> bool` Returns an argument **arg** from the **_args** **Dictionary**, or `false` if the argument doesn't exist in `_args`.

## State <img src="/addons/dragonforge_state_machine/assets/textures/icons/state_icon_64x64_white.png" width="32" alt="State Icon"/>
### Public Member Variables
- `can_transition = true` Set to false if this [State] cannot be transitioned to (or alternately, from). For example when waiting for a cooldown timer to expire, when a character is dead, or when the splash screens have been completed.

### Public Functions
Though public, typically these functions are used inside the **State** itself.
- `switch_state() -> void` Asks the state machine to switch to this [State]. Should always be used instead of _enter_state() when a [State] wants to switch to itself.
- `is_current_state() -> bool` Returns true if this is the current [State].

### Private Override Functions
To implement a State, there are four functions you typically override. Sometimes you only need one or two. Sometimes you need all five. Whenever you override any of these functions, the first line of your override function should be to call `super()`. This ensures that the logging code runs, but forgetting to do it can cause the **State** to malfunction and weird bugs to occur. Note that none of these functions should be called directly in code. The **StateMachine** will call them at the appropriate time.

- `_ready() -> void` Turns off the _process(), _phsyics_process(), _input() and _unhandled_input() functions. If you want to use them for a [State] you can turn them on in the _activate_state() function, or turned on and off in _enter_state() and _exit_state(). **NOTE:** Although typically you override this function in Godot, that code should be moved to the `_activate_state()` function for **State** nodes.
- `_activate_state() -> void` Called when the [State] is added to a [StateMachine]. This should be used for initialization instead of `_ready()` because it is guaranteed to be run _after_ all of the nodes that are in the owner's tree have been constructed - preventing race conditions. <span style="color:yellow">**WARNING:**</span> When overriding, be sure to call `super()` on the first line of your method. _Never_ call this method directly. It should only be used by the [StateMachine].
- `_deactivate_state() -> void` Called when a [State] is removed from a [StateMachine]. <span style="color:yellow">**WARNING:**</span> When overriding, be sure to call `super()` on the first line of your method. _Never_ call this method directly. It should only be used by the [StateMachine].
- `_enter_state() -> void` Called every time the [State] is entered. <span style="color:yellow">**WARNING:**</span> When overriding, be sure to call `super()` on the first line of your method. _Never_ call this method directly. It should only be used by the [StateMachine].
- `_exit_state() -> void` Called every time the [State] is exited. <span style="color:yellow">**WARNING:**</span> When overriding, be sure to call `super()` on the first line of your method. _Never_ call this method directly. It should only be used by the [StateMachine].
