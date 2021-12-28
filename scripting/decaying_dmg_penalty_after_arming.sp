/**
 * damage_penalty_after_sticky_arm
 * 
 * Attribute that reduces sticky damage by a given percentage for 1 second after a sticky arms
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define DMG_PENALTY_AFTER_ARM_ATTRIB_INDEX 5216
#define ARM_TIME_PENALTY_ATTRIB 120
#define ARM_TIME_BONUS_ATTRIB 126
#define DEFAULT_STICKY_ARM_TIME 0.8
#define DMG_MULT_PERIOD 1.0

float g_fTimeSinceFiring[MAXPLAYERS + 1];

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
	if(IsValidClient(iAttacker))
	{
		if(iWeapon > -1)
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, DMG_PENALTY_AFTER_ARM_ATTRIB_INDEX) != Address_Null)
			{
				float fMaxMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, DMG_PENALTY_AFTER_ARM_ATTRIB_INDEX));
				if(GetEngineTime() < g_fTimeSinceFiring[iAttacker] + DMG_MULT_PERIOD)
				{
					float fTimeDifference = (g_fTimeSinceFiring[iAttacker] + DMG_MULT_PERIOD) - GetEngineTime();
					float fDamageMultiplier = (DMG_MULT_PERIOD / fTimeDifference) * fMaxMultiplier;
					if(fDamageMultiplier < fMaxMultiplier)
						fDamageMultiplier = fMaxMultiplier;
					if(fDamageMultiplier > 1.0)
						fDamageMultiplier = 1.0;

					fDamage *= fDamageMultiplier;
					return Plugin_Changed;
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action TF2_CalcIsAttackCritical(int iClient, int iWeapon, char[] sWeaponName, bool &bResult)
{
	if(IsValidClient(iClient))
	{
		if(iWeapon > -1)
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, DMG_PENALTY_AFTER_ARM_ATTRIB_INDEX) != Address_Null)
			{
				g_fTimeSinceFiring[iClient] = GetEngineTime() + DEFAULT_STICKY_ARM_TIME;
				if(TF2Attrib_GetByDefIndex(iWeapon, ARM_TIME_BONUS_ATTRIB) != Address_Null)
				{
					g_fTimeSinceFiring[iClient] += TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, ARM_TIME_BONUS_ATTRIB));
				}
				if(TF2Attrib_GetByDefIndex(iWeapon, ARM_TIME_PENALTY_ATTRIB) != Address_Null)
				{
					g_fTimeSinceFiring[iClient] += TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, ARM_TIME_PENALTY_ATTRIB));
				}
			}
		}
	}
	return Plugin_Continue;
}