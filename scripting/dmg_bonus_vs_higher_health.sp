/**
 * dmg_bonus_vs_higher_health
 * 
 * Adds an attribute that multiplies a weapon's damage against players with more maximum health than the attacker
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>

#define DMG_BONUS_VS_HIGH_HP_ATTRIB 5226

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
			if(TF2Attrib_GetByDefIndex(iWeapon, DMG_BONUS_VS_HIGH_HP_ATTRIB) != Address_Null)
			{
				if(GetClientMaxHealth(iAttacker) < GetClientMaxHealth(iVictim))
				{
					float fDamageMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, DMG_BONUS_VS_HIGH_HP_ATTRIB));
					fDamage *= fDamageMultiplier;
					return Plugin_Changed;
				}
			}
		}
	}
	return Plugin_Continue;
}
