init()
{
	if ( getDvar( "ui_zm_gamemodegroup" ) == "zsurvival" )
	{
		level thread maps\mp\zombies\_zm_banking::init();
	}
}