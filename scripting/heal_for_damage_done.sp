/**
 * heal_for_damage_done
 * 
 * Heals the player for a percentage of damage done
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>

#define HEAL_FOR_DAMAGE_DONE_ATTRIB_INDEX 5205

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
			if(TF2Attrib_GetByDefIndex(iWeapon, HEAL_FOR_DAMAGE_DONE_ATTRIB_INDEX) != Address_Null)
			{
				float fMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, HEAL_FOR_DAMAGE_DONE_ATTRIB_INDEX));
				int iHealAmount = RoundToNearest(fDamage * fMultiplier);
				HealPlayer(iAttacker, iHealAmount);
			}
		}
	}

	return Plugin_Continue;
}