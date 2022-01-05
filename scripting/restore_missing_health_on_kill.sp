/**
 * restore_missing_health_on_kill
 * 
 * Adds an attribute that heals the player based on their missing health on kill
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define KILL_HEALS_ATTRIB 5228

public void OnPluginStart()
{
	HookEvent("player_death", Event_Death);
}

public void Event_Death(Event hEvent, const char[] sName, bool dontBroadcast)
{
	int iAttacker = GetClientOfUserId(hEvent.GetInt("attacker"));
	if(IsValidClient(iAttacker))
	{
		int iWeapon = GetActiveWeapon(iAttacker);
		if(iWeapon > -1)
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, KILL_HEALS_ATTRIB) != Address_Null)
			{
				int iHealAmount = RoundToNearest((GetClientMaxHealth(iAttacker) - GetClientHealth(iAttacker)) * TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, KILL_HEALS_ATTRIB)));
				if(iHealAmount > 0)
					HealPlayer(iAttacker, iHealAmount, 1.0);
			}
		}
	}
}
