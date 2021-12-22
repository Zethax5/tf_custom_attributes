/**
 * fire_rate_bonus_on_primary
 * 
 * Grants your primary weapon a fire rate bonus for equipping this weapon
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define PRIM_FIRE_RATE_BONUS_ATTRIB_INDEX 5202
#define FIRE_RATE_BONUS_ATTRIB_INDEX 348
#define MAXIMUM_WEAPON_SLOTS 7

public void OnPluginStart()
{
	HookEvent("post_inventory_application", Event_ApplyInventory);
}

public void Event_ApplyInventory(Event hEvent, const char[] sName, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(hEvent.GetInt("userid"));
	if(IsValidClient(iClient))
	{
		int iPrimary = GetPlayerWeaponSlot(iClient, 0);
		if(iPrimary > -1)
		{
			for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
			{
				int iWeapon = GetPlayerWeaponSlot(iClient, i);
				if(iWeapon > -1)
				{
					if(TF2Attrib_GetByDefIndex(iWeapon, PRIM_FIRE_RATE_BONUS_ATTRIB_INDEX) != Address_Null)
					{
						float fBonus = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, PRIM_FIRE_RATE_BONUS_ATTRIB_INDEX));
						TF2Attrib_SetByDefIndex(iPrimary, FIRE_RATE_BONUS_ATTRIB_INDEX, fBonus);
					}
				}
			}
		}
	}
}
