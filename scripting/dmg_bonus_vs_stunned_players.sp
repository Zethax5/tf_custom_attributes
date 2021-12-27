/**
 * dmg_bonus_vs_stunned_players
 * 
 * Attribute that increases a weapon's damage against burning players
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define DMG_BONUS_VS_STUNNED_ATTRIB 5219

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
	if(IsValidClient(iAttacker) && IsValidClient(iVictim))
	{
		if(iWeapon > -1)
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, DMG_BONUS_VS_STUNNED_ATTRIB) != Address_Null)
			{
				if(TF2_IsPlayerInCondition(iVictim, TFCond_Dazed))
				{
					float fDamageMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, DMG_BONUS_VS_STUNNED_ATTRIB));
					fDamage *= fDamageMultiplier;
					return Plugin_Changed;
				}
			}
		}
	}
	return Plugin_Continue;
}
