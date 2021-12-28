/**
 * stacking_reload_rate
 * 
 * Adds an attribute that grants stacking reload speed on kill
 * Meant to be paired with the Air Strike, so no HUD will be given for the reload speed bonus
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define STACKING_RELOAD_RATE_ATTRIB 5225
#define RELOAD_RATE_BONUS_ATTRIB 97
#define MAXIMUM_WEAPON_SLOTS 2 //Only two weapon slots can be reloaded
#define MAXIMUM_STACKS 4

int g_iStacks[MAXPLAYERS + 1];

public void OnPluginStart()
{
	HookEvent("player_death", Event_Death);
}

public void Event_Death(Event hEvent, const char[] sName, bool dontBroadcast)
{
	int iAttacker = GetClientOfUserId(hEvent.GetInt("attacker"));
	int iVictim = GetClientOfUserId(hEvent.GetInt("userid"));
	if(IsValidClient(iAttacker))
	{
		int iWeapon = GetActiveWeapon(iAttacker);
		if(iWeapon > -1)
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, STACKING_RELOAD_RATE_ATTRIB) != Address_Null)
			{
				if(g_iStacks[iAttacker] < MAXIMUM_STACKS)
				{
					g_iStacks[iAttacker]++;

					float fReloadRateBonus = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, STACKING_RELOAD_RATE_ATTRIB));
					TF2Attrib_SetByDefIndex(iWeapon, RELOAD_RATE_BONUS_ATTRIB, 1.0 - (fReloadRateBonus * g_iStacks[iAttacker]));
				}
			}
		}
	}
	if(IsValidClient(iVictim))
	{
		g_iStacks[iVictim] = 0;
	}
}