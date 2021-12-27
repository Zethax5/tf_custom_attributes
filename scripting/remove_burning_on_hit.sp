/**
 * speed_bonus_on_hit_burning
 * 
 * Attribute that grants a speed boost for a given duration after hitting a burning player
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define REMOVE_BURN_ON_HIT_ATTRIB 5221

public void OnMapStart() {
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i)) {
			OnClientPutInServer(i);
		}
	}
}

public void OnClientPutInServer(int iClient) {
	SDKHook(iClient, SDKHook_OnTakeDamageAlive, OnTakeDamageAlive);
}

public Action OnTakeDamageAlive(int iVictim, int &iAttacker, int &iInflictor, float &fDamage, int &iDamageType, int &iWeapon, float[3] fDamageForce, float[3] fDamagePos)
{
	if(IsValidClient(iAttacker))
	{
		if(iWeapon > -1)
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, REMOVE_BURN_ON_HIT_ATTRIB) != Address_Null)
			{
				CreateTimer(0.1, Timer_ExtinguishPlayer, EntIndexToEntRef(iVictim), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	return Plugin_Continue;
}

public Action Timer_ExtinguishPlayer(Handle hTimer, any iRef)
{
	int iClient = EntRefToEntIndex(iRef);
	if(IsValidClient(iClient))
		TF2_RemoveCondition(iClient, TFCond_OnFire);
}
