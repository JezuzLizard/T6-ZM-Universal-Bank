main()
{
	mapname = getDvar( "mapname" );
	if ( mapname != "zm_transit" && mapname != "zm_highrise" && mapname != "zm_buried" )
	{
		level thread on_player_connect();
	}
	level thread command_thread();
	level thread auto_deposit_on_end_game();
}

command_thread()
{
	level endon( "end_game" );
	while ( true )
	{
		level waittill( "say", message, player, isHidden );
		args = strTok( message, " " );
		command = args[ 0 ];
		switch ( command )
		{
			case ".w":
			case ".with":
			case ".withdraw":
			 	player withdraw_logic( args[ 1 ] );
				break;
			case ".d":
			case ".dep":
			case ".deposit":
				player deposit_logic( args[ 1 ] );
				break;
			case ".b":
			case ".bal":
			case ".balance":
				player balance_logic();
				break;
			default:
				break;
		}
	}
}

auto_deposit_on_end_game()
{
	level waittill( "end_game" );
	wait 1;
	foreach ( player in level.players )
	{
		player deposit_logic( "all" );
	}
}

on_player_connect()
{
	level endon( "end_game" );
	while ( true )
	{
		level waittill( "connected", player );
		player.account_value = player maps\mp\zombies\_zm_stats::get_map_stat( "depositBox", "zm_transit" );
	}
}

withdraw_logic( amount )
{
	if ( !isDefined( self.account_value ) )
	{
		self iPrintLn( "Map is not bank compatible" );
		return;
	}
	if ( self.account_value <= 0 )
	{
		self iPrintln( "Withdraw failed: empty bank" );
		return;
	}
	if ( self.score >= 1000000 )
	{
		self iPrintLn( "Withdraw failed: Max score is 1000000" );
		return;
	}
	if ( !isDefined( amount ) )
	{
		self iPrintLn( "Usage .w <number|all>" );
		return;
	}
	num_score = int( floor( self.score / 1000 ) );
	if ( is_str_int( amount ) )
	{
		num_amount = int( amount );
		if ( num_amount < 1000 )
		{
			self iPrintLn( "Withdraw failed: Value must be 1000 or greater" );
			return;
		}
		divided_value = num_amount / 1000;
		num_amount = int( floor( divided_value ) );
	}
	else if ( amount == "all" )
	{
		num_amount = self.account_value;
	}
	else 
	{
		self iPrintLn( "Usage .w <number|all>" );
		return;
	}
	//Clamp amount to account value
	if ( num_amount > self.account_value )
	{
		num_amount = self.account_value;
	}
	new_balance = self.account_value - num_amount; //250 - 250
	//If the withdraw amount + the player's current score is greater than 1000 clamp the withdraw amount
	over_balance = num_score + num_amount - 1000; // 800 + 250 - 1000
	max_score_available = abs( num_score - 1000 ); // 800 - 1000
	if ( over_balance > 0 ) // 50 > 0
	{
		new_balance = over_balance;
		num_amount = max_score_available;
	}
	self.account_value = new_balance;
	final_amount = num_amount * 1000;
	self.score += final_amount;
	self maps\mp\zombies\_zm_stats::set_map_stat( "depositBox", new_balance, "zm_transit" );
	self iPrintLn( "Successfuly withdrew " + final_amount );
}

deposit_logic( amount )
{
	if ( !isDefined( self.account_value ) )
	{
		self iPrintLn( "Map is not bank compatible" );
		return;
	}
	if ( self.score <= 0 )
	{
		self iPrintLn( "Deposit failed: Not enough points" );
	}
	if ( self.account_value >= 250 )
	{
		self iPrintLn( "Deposit failed: Max bank is 250000" );
		return;
	}
	if ( !isDefined( amount ) )
	{
		self iPrintLn( "Usage .d <number|all>" );
		return;
	}
	num_score = int( floor( self.score / 1000 ) );
	if ( is_str_int( amount ) )
	{
		num_amount = int( amount );
		if ( num_amount < 1000 )
		{
			self iPrintLn( "Deposit failed: Value must be 1000 or greater" );
			return;
		}
		divided_value = num_amount / 1000;
		num_amount = int( floor( divided_value ) );
	}
	else if ( amount == "all" )
	{
		num_amount = num_score;
	}
	else 
	{
		self iPrintLn( "Usage .d <number|all>" );
		return;
	}
	//Clamp deposit amount to player's score
	if ( num_amount > num_score )
	{
		num_amount = num_score;
	}
	//Clamp deposit amount to 250(max amount allowed in bank)
	if ( num_amount > 250 )
	{
		num_amount = 250;
	}
	//If the amount is greater than what can fit in the bank clamp the deposit amount to what can fit in the bank (250)
	new_balance = self.account_value + num_amount;
	over_balance = new_balance - 250;
	if ( over_balance > 0 )
	{
		num_amount -= over_balance;
		new_balance -= over_balance;
	}
	self.account_value = new_balance;
	final_amount = num_amount * 1000;
	self.score -= final_amount;
	self maps\mp\zombies\_zm_stats::set_map_stat( "depositBox", new_balance, "zm_transit" );
	self iPrintLn( "Successfully deposited " + final_amount );
}

balance_logic()
{
	self iPrintLn( "Current balance: " + self.account_value * 1000 + " Max: 250000" );
}

is_str_int( str )
{
	val = 0;
	list_num = [];
	list_num[ "0" ] = val;
	val++;
	list_num[ "1" ] = val;
	val++;
	list_num[ "2" ] = val;
	val++;
	list_num[ "3" ] = val;
	val++;
	list_num[ "4" ] = val;
	val++;
	list_num[ "5" ] = val;
	val++;
	list_num[ "6" ] = val;
	val++;
	list_num[ "7" ] = val;
	val++;
	list_num[ "8" ] = val;
	val++;
	list_num[ "9" ] = val;
	for ( i = 0; i < str.size; i++ )
	{
		if ( !isDefined( list_num[ str[ i ] ] ) )
		{
			return false;
		}
	}
	return true;
}