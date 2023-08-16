#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_buried_sq;
#include maps\mp\zm_buried_sq_ip;
#include maps\mp\zm_buried_sq_ows;
#include maps\mp\zm_buried_sq_tpo;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_utility;

// This Script was created By StickGaming
// Some code in the script have been used or remixed from other people around the internet
// This script is allowed to be shared around the interwebs
//
// Any contributors will be credited down below
// Nathan3197
//
//
// Credit of use of other people code found on the internet
//  Teh-Bandit - for making the time bomb step to be done with any amount of player
//
// Big thanks to the pluto team for all their hard efforts to allow us to play BO2 with mods and servers.

	// Buried all player EE


main()
{
	// replacing 3arc functions
	replaceFunc( ::_are_all_players_in_time_bomb_volume, ::_are_all_players_in_time_bomb_volume_qol );
	replaceFunc( ::ows_target_delete_timer, ::new_ows_target_delete_timer );
	replaceFunc( ::ows_targets_start, ::new_ows_targets_start);
	//replaceFunc( ::sq_ml_puzzle_logic, ::new_sq_ml_puzzle_logic);
}

playertracker_onlast_step()
{
	// when the players are on the last step of rich EE we are going
	// to check how many players are in the lobby when this step is activated
	// and change the amount of targets allowed to be missed based on how many players are in
	// the session.
	players = getPlayers();
	switch ( players.size )
	{
		case 1:
			level.targets_allowed_to_be_missed = 64; // Total (84) - ( Candy Shop (20) )
			break;
		case 2:
			level.targets_allowed_to_be_missed = 45; // Total (84) - ( Candy Shop (20) + Saloon (19) )
			break;
		/*case 3:
			level.targets_allowed_to_be_missed = 23; // Total (84) - ( Candy Shop (20) + Saloon (19) + Barn (22) )
			break;*/ //commented so that the players on 3p have to shoot all targets.
		default: //All 4 areas of the map
			level.targets_allowed_to_be_missed = 0;
	}
}

//Teh-Bandit time bomb fix
_are_all_players_in_time_bomb_volume_qol( e_volume )
{
	n_required_players = 4;
	a_players = get_players();
	if ( getPlayers().size <= 3 ) //this allows the server with less than 4 players to do the EE
		n_required_players = a_players.size;

	n_players_in_position = 0;

	foreach ( player in a_players )
	{
		if ( player istouching( e_volume ) )
			n_players_in_position++;
	}

	b_all_in_valid_position = n_players_in_position == n_required_players;
	return b_all_in_valid_position;
}

//When a target spawn it has alive timer then it will despawn
new_ows_target_delete_timer()
{
	self endon( "death" );
	wait 4; // change this if you want the target to stay alive longer (3arc had this set to 4)
	self notify( "ows_target_timeout" );
	level.targets_allowed_to_be_missed--; //
	if ( level.targets_allowed_to_be_missed < 0 /*|| ( getPlayers().size == 3 && level.targets_allowed_to_be_missed > 4 && level.targets_allowed_to_be_missed < 23 )*/ ) //the purpose of the commented conditions is to make the step on 3p be optional between 3 locations and all locations.
		flag_set( "sq_ows_target_missed" );
	/*else if ( getPlayers().size == 3 && level.targets_allowed_to_be_missed >= 0 && level.targets_allowed_to_be_missed <= 4 ) //clears the flag in the case that the players choose to only shoot the targets from 3 locations instead of all.
		flag_clear( "sq_ows_target_missed" );*/
}

//rip from 3arc but with some changes
new_ows_targets_start()
{
	n_cur_second = 0;
	flag_clear( "sq_ows_target_missed" );
	playertracker_onlast_step();
	level thread sndsidequestowsmusic();
	a_sign_spots = getstructarray( "otw_target_spot", "script_noteworthy" );

	while ( n_cur_second < 40 )
	{
		a_spawn_spots = ows_targets_get_cur_spots( n_cur_second );

		if ( isDefined( a_spawn_spots ) && a_spawn_spots.size > 0 )
			ows_targets_spawn( a_spawn_spots );

		wait 1;
		n_cur_second++;
	}

	//AllClientsPrint("Waiting for target to stop spawning");
	if ( !flag( "sq_ows_target_missed" ) )
	{
		flag_set( "sq_ows_success" );
		playsoundatposition( "zmb_sq_target_success", ( 0, 0, 0 ) );
	}
	else
		playsoundatposition( "zmb_sq_target_fail", ( 0, 0, 0 ) );

	level notify( "sndEndOWSMusic" );
}

//Maze fix (rip from 3arc but with some changes)
new_sq_ml_puzzle_logic()
{
	a_levers = getentarray( "sq_ml_lever", "targetname" );
	level.sq_ml_curr_lever = 0;
	a_levers = array_randomize( a_levers );

	for ( i = 0; i < a_levers.size; i++ )
		a_levers[i].n_lever_order = i;

	while ( true )
	{
		level.sq_ml_curr_lever = 0;
		sq_ml_puzzle_wait_for_levers();
		n_correct = 0;

		foreach ( m_lever in a_levers )
		{
			players = getPlayers();
			lever_flipped_in_position = m_lever.n_flip_number + 1;
			if ( m_lever.n_flip_number == m_lever.n_lever_order )
			{
				playfxontag( level._effect["sq_spark"], m_lever, "tag_origin" );
				n_correct++;
				m_lever playsound( "zmb_sq_maze_correct_spark" );
				// this step is really hard to do when you don't have 4 people watching all 4 switches at the same time
				// with 3 or less players tell the player if a switch is in the correct order but don't tell what color
				if( players.size <= 3 )
					AllClientsPrint( "Lever flipped in position " + lever_flipped_in_position + ": ^3Spark" );
			}
			// this step is really hard to do when you don't have 4 people watching all 4 switches at the same time
			// with 3 or less players tell the player if a switch is in the correct order but don't tell what color
			else if( players.size <= 3 )
				AllClientsPrint( "Lever flipped in position " + lever_flipped_in_position + ": No Spark" );
		}
		if ( n_correct == a_levers.size )
			flag_set( "sq_ip_puzzle_complete" );

		level waittill( "zm_buried_maze_changed" );

		level notify( "sq_ml_reset_levers" );
		wait 1;
	}
}
