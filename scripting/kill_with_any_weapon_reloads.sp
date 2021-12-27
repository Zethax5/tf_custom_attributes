/**
 * kill_with_any_weapon_reloads
 * 
 * Reloads x amount of shots into this weapon if a kill is secured with any weapon.
 * Alternatively, if the while active mod attribute is present, the weapon is only
 * reloaded if it is currently active.
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define KILL_RELOADS_ATTRIB_INDEX 5204
#define WHILE_ACTIVE_ATTRIB_INDEX 128
#define MAXIMUM_WEAPON_SLOTS 2 //There are only 2 weapon slots that can have ammo

int g_iMaxClip[MAXPLAYERS + 1][MAXIMUM_WEAPON_SLOTS];

public void OnPluginStart()
{
	HookEvent("player_death", Event_Death);
	HookEvent("post_inventory_application", Event_ApplyInventory);
}

public void Event_ApplyInventory(Event hEvent, const char[] sName, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(hEvent.GetInt("userid"));
	if(IsValidClient(iClient))
	{
		for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
		{
			int iWeapon = GetPlayerWeaponSlot(iClient, i);
			if(iWeapon > -1)
			{
				g_iMaxClip[iClient][i] = GetClip_Weapon(iWeapon); //Stores the maximum clip size of a weapon in a given slot
			}
		}
	}
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
				//Checks to see if the weapon has the while active mod on it
				//If it does we only reload the weapon while the weapon is active
				if(TF2Attrib_GetByDefIndex(iWeapon, WHILE_ACTIVE_ATTRIB_INDEX) != Address_Null && GetActiveWeapon(iAttacker) == iWeapon)
				{
					if(TF2Attrib_GetByDefIndex(iWeapon, KILL_RELOADS_ATTRIB_INDEX) != Address_Null)
					{
						ReloadWeapon(iAttacker, i);
					}
				}
				else
				{
					if(TF2Attrib_GetByDefIndex(iWeapon, KILL_RELOADS_ATTRIB_INDEX) != Address_Null)
					{
						ReloadWeapon(iAttacker, i);
					}
				}
			}
		}
	}
}

void ReloadWeapon(int iClient, int iSlot)
{
	int iWeapon = GetPlayerWeaponSlot(iClient, iSlot);

	int iInitClip = GetClip_Weapon(iWeapon);
	int iReloadAmount = RoundToNearest(TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, KILL_RELOADS_ATTRIB_INDEX))); //Gets the amount of ammo we need to reload, and subsequently subtract from the ammo pool
	int iCurrentAmmo = GetAmmo_Weapon(iWeapon);

	//Limits the amount of ammo we can reload if the player doesn't have
	//enough ammo for a full reload
	if(iCurrentAmmo - iReloadAmount < 0)
		iReloadAmount = iCurrentAmmo;

	//Ensures we don't go over the weapon's maximum clip size
	if(iInitClip + iReloadAmount > g_iMaxClip[iClient][iSlot])
		iReloadAmount = g_iMaxClip[iClient][iSlot] - iInitClip;

	//Reloads the weapon and removes the ammo used to reload the weapon
	SetClip_Weapon(iWeapon, iInitClip + iReloadAmount);
	SetAmmo_Weapon(iWeapon, iCurrentAmmo - iReloadAmount);
}