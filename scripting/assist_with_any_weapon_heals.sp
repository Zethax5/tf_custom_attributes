/**
 * assist_with_any_weapon_heals
 * 
 * Adds an attribute that heals the player if they get an assist with any weapon
 * Respects WHILE ACTIVE rules
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define ASSIST_HEALS_ATTRIB 5223
#define WHILE_ACTIVE_ATTRIB_INDEX 128
#define MAXIMUM_WEAPON_SLOTS 5

public void OnPluginStart()
{
	HookEvent("player_death", Event_Death);
}

public void Event_Death(Event hEvent, const char[] sName, bool dontBroadcast)
{
	int iAssister = GetClientOfUserId(hEvent.GetInt("assister"));
	if(IsValidClient(iAssister))
	{
		for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
		{
			int iWeapon = GetPlayerWeaponSlot(iAssister, i);
			if(iWeapon > -1)
			{
				//Checks to see if the weapon has the while active mod on it
				//If it does we only reload the weapon while the weapon is active
				if(TF2Attrib_GetByDefIndex(iWeapon, WHILE_ACTIVE_ATTRIB_INDEX) != Address_Null && GetActiveWeapon(iAssister) == iWeapon)
				{
					if(TF2Attrib_GetByDefIndex(iWeapon, ASSIST_HEALS_ATTRIB) != Address_Null)
					{
						int iHealAmount = RoundToNearest(TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, ASSIST_HEALS_ATTRIB)));
						HealPlayer(iAssister, iHealAmount, 1.5);
					}
				}
				else
				{
					if(TF2Attrib_GetByDefIndex(iWeapon, ASSIST_HEALS_ATTRIB) != Address_Null)
					{
						int iHealAmount = RoundToNearest(TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, ASSIST_HEALS_ATTRIB)));
						HealPlayer(iAssister, iHealAmount, 1.5);
					}
				}
			}
		}
	}
}
