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

#define SPD_BONUS_ON_HIT_BURNING_ATTRIB 5220

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
			if(TF2Attrib_GetByDefIndex(iWeapon, SPD_BONUS_ON_HIT_BURNING_ATTRIB) != Address_Null)
			{
				if(TF2_IsPlayerInCondition(iVictim, TFCond_OnFire))
				{
					float fDuration = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, SPD_BONUS_ON_HIT_BURNING_ATTRIB));
					TF2_AddCondition(iAttacker, TFCond_SpeedBuffAlly, fDuration);
				}
			}
		}
	}
	return Plugin_Continue;
}
