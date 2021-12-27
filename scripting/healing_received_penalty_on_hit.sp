/**
 * healing_received_penalty_on_hit
 * 
 * Hits will inflict a healing received debuff for 5 seconds
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define HEALING_PENALTY_ON_HIT_ATTRIB 5218
#define HEALTH_FROM_HEALERS_ATTRIB_INDEX 69
#define HEALTH_FROM_PACKS_ATTRIB_INDEX 109
#define HEALING_DEBUFF_DURATION 5.0

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
			if(TF2Attrib_GetByDefIndex(iWeapon, HEALING_PENALTY_ON_HIT_ATTRIB) != Address_Null)
			{
				float fHealingMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, HEALING_PENALTY_ON_HIT_ATTRIB));
				TF2Attrib_SetByDefIndex(iVictim, HEALTH_FROM_PACKS_ATTRIB_INDEX, fHealingMultiplier);
				TF2Attrib_SetByDefIndex(iVictim, HEALTH_FROM_HEALERS_ATTRIB_INDEX, fHealingMultiplier);

				CreateTimer(HEALING_DEBUFF_DURATION, Timer_RemoveHealingDebuff, EntIndexToEntRef(iVictim), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}

	return Plugin_Continue;
}

public Action Timer_RemoveHealingDebuff(Handle hTimer, any iRef)
{
	int iClient = EntRefToEntIndex(iRef);

	if(IsValidClient(iClient))
	{
		TF2Attrib_RemoveByDefIndex(iClient, HEALTH_FROM_HEALERS_ATTRIB_INDEX);
		TF2Attrib_RemoveByDefIndex(iClient, HEALTH_FROM_PACKS_ATTRIB_INDEX);
	}
}