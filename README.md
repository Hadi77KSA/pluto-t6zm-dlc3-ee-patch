# Stick Gaming Pluto Buried Easter Egg Quality of Life improvement
This script makes the Easter Egg achievable with any amount of players in the game session while keeping the original design of each step the same but allowing any player to complete it.


# Features
-	**Buired Easter Egg QOL V1.0**
	- **Maze Step**
        - (Disabled) With less than 4 players when the last switch has been pulled. The game will notify players if a switch is in the correct position.
	- **Timebomb Step**
        - Require all players in the lobby to be near the location of the timebomb. If the amount of players is greater than 4, then require at least 4 players to be near the location.
    - **Shooting Gallery Step**
        - Depending on how many players are in the lobby when interacting with the fountain outside of the courthouse will decide how many targets will be needed to be shot to complete the step.
        - If there are 4 or more players - All targets will need to be shot (just like vanilla)
        - (Disabled. Currently the same as 4p) If there are 3 players in the lobby - at least 61 targets will need to be shot (Candy Shop (20) + Saloon (19) + Barn (22)) (There are optional lines that make the step fail if the players shoot between 65 (Candy Shop (20) + Barn (22) + Mansion (23) and less than 84 (all) targets, but this is disabled by default)
        - If there are 2 players in the lobby - at least 39 targets will need to be shot (Candy Shop (20) + Saloon (19))
        - If there is 1 player in the lobby - at least 20 targets will need to be shot (Outside of the candy store has 20 targets)

## Installation
- Copy the files to your `%localappdata%/Plutonium/storage/t6/scripts/zm/zm_buried` folder _(if you don't have a "zm_buried" folder then create one)_

- Start your server or custom game


## Contributors
-	[Nathan3197](https://twitter.com/nathan3197) - Owner/developer
-   The hundreds of people who tested this on our servers
