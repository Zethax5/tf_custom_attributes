/**
 * kill_with_any_weapon_heals
 * 
 * Adds an attribute that heals the player if they get a kill with any weapon
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define KILL_HEALS_ATTRIB 5222
#define MAXIMUM_WEAPON_SLOTS 5

public void OnPluginStart()
{
	HookEvent("player_death", Event_Death);
}

public void Event_Death(Event hEvent, const char[] sName, bool dontBroadcast)
{
	int iAttacker = GetClientOfUserId(hEvent.GetInt("attacker"));
	if(IsValidClient(iAttacker))
	{
		for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
		{
			int iWeapon = GetPlayerWeaponSlot(iAttacker, i);
			if(iWeapon > -1)
			{
				if(TF2Attrib_GetByDefIndex(iWeapon, KILL_HEALS_ATTRIB) != Address_Null)
				{
					int iHealAmount = RoundToNearest(TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, KILL_HEALS_ATTRIB)));
					HealPlayer(iAttacker, iHealAmount, 1.5);
				}
			}
		}
	}
}
