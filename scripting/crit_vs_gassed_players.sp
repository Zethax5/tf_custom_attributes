/**
 * crit_vs_gassed_players
 * 
 * Deal crits vs gassed players
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define CRIT_GASSED_PLAYERS_ATTRIB_INDEX 5213

public void OnMapStart() {
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i)) {
			OnClientPutInServer(i);
		}
	}
}

public void OnClientPutInServer(int iClient) {
	SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int iVictim, int &iAttacker, int &iInflictor, float &fDamage, int &iDamageType, int &iWeapon, float[3] fDamageForce, float[3] fDamagePos)
{
	if(IsValidClient(iAttacker) && IsValidClient(iVictim))
	{
		if(iWeapon > -1)
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, CRIT_GASSED_PLAYERS_ATTRIB_INDEX) != Address_Null)
			{
				if(TF2_IsPlayerInCondition(iVictim, view_as<TFCond>(123)))
				{
					iDamageType += DMG_CRIT;
					return Plugin_Changed;
				}
			}
		}
	}

	return Plugin_Continue;
}