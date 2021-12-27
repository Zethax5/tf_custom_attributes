/**
 * fire_rate_bonus_on_deploy
 * 
 * Grants a weapon a temporary fire rate bonus after being deployed
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define TEMP_FIRE_RATE_BONUS_ATTRIB_INDEX 5201
#define FIRE_RATE_BONUS_ATTRIB_INDEX 394
#define FIRE_RATE_BONUS_DURATION 3.0
#define MAXIMUM_WEAPON_SLOTS 3

float g_fLastTick[MAXPLAYERS + 1];
float g_fBonusTime[MAXPLAYERS + 1];
float g_fFireRateBonus[MAXPLAYERS + 1] = {1.0, ...};

public void OnPluginStart()
{
	HookEvent("post_inventory_application", Event_ApplyInventory);
}

public void OnMapStart() {
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i)) {
			OnClientPutInServer(i);
		}
	}
}

public void OnClientPutInServer(int iClient) {
	SDKHook(iClient, SDKHook_PreThink, OnClientPreThink);
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
				if(TF2Attrib_GetByDefIndex(iWeapon, TEMP_FIRE_RATE_BONUS_ATTRIB_INDEX) != Address_Null)
				{
					g_fFireRateBonus[iClient] = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, TEMP_FIRE_RATE_BONUS_ATTRIB_INDEX));
				}
			}
		}
	}
}

public void OnClientPreThink(int iClient) {
	
	if(!IsValidClient(iClient))
		return;

	if(GetEngineTime() >= g_fLastTick[iClient] + 0.1) //After 1/10th of a second has passed since the last tick
	{
		int iWeapon = GetActiveWeapon(iClient);
		if(IsValidEntity(iWeapon))
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, TEMP_FIRE_RATE_BONUS_ATTRIB_INDEX) != Address_Null)
			{
				if(g_fBonusTime[iClient] > 0.0)
					TF2Attrib_SetByDefIndex(iWeapon, FIRE_RATE_BONUS_ATTRIB_INDEX, g_fFireRateBonus[iClient]);

				g_fBonusTime[iClient] -= 0.1;
				if(g_fBonusTime[iClient] < 0.1)
				{
					TF2Attrib_RemoveByDefIndex(iWeapon, FIRE_RATE_BONUS_ATTRIB_INDEX);
					g_fBonusTime[iClient] = 0.0;
				}
			}
			else
			{
				g_fBonusTime[iClient] = FIRE_RATE_BONUS_DURATION;
			}
		}

		g_fLastTick[iClient] = GetEngineTime(); //Resets the tick time
	}
}
