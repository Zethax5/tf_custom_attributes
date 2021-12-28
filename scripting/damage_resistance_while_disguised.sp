/**
 * damage_resistance_while_disguised
 * 
 * Grants a flat amount of damage resistance while aiming/spun up
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define WHILE_ACTIVE_ATTRIB_INDEX 128
#define DAMAGE_RESISTANCE_DISGUISED_ATTRIB_INDEX 5214
#define DAMAGE_PIERCES_FIXED 5224
#define MAX_WEAPON_SLOTS 5

bool g_bDisguised[MAXPLAYERS + 1];

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
	if(IsValidClient(iVictim))
	{
		if(TF2Attrib_GetByDefIndex(iWeapon, DAMAGE_PIERCES_FIXED) != Address_Null)
		{
			return Plugin_Continue;
		}
		if(g_bDisguised[iVictim])
		{
			fDamage = DisguisedDamageReduction(iVictim, fDamage);

			for(int i = 0; i < MAX_WEAPON_SLOTS; i++)
			{
				int iVictimWeaponSlot = GetPlayerWeaponSlot(iVictim, i);
				if(iVictimWeaponSlot > -1)
				{
					if(TF2Attrib_GetByDefIndex(iVictimWeaponSlot, WHILE_ACTIVE_ATTRIB_INDEX) != Address_Null && GetActiveWeapon(iVictim) == iVictimWeaponSlot)
					{
						fDamage = DisguisedDamageReduction(iVictimWeaponSlot, fDamage);
					}
					else
					{
						fDamage = DisguisedDamageReduction(iVictimWeaponSlot, fDamage);
					}
				}
			}

			return Plugin_Changed;
		}
	}

	return Plugin_Continue;
}

float DisguisedDamageReduction(int iTargetEntity, float fDamage)
{
	if(TF2Attrib_GetByDefIndex(iTargetEntity, DAMAGE_RESISTANCE_DISGUISED_ATTRIB_INDEX) != Address_Null)
	{
		float fMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iTargetEntity, DAMAGE_RESISTANCE_DISGUISED_ATTRIB_INDEX));
		fDamage *= fMultiplier;
		return fDamage;
	}
	else
		return fDamage;
}

public void TF2_OnConditionAdded(int iClient, TFCond cond)
{
	if(cond == view_as<TFCond>(3)) //Disguised condition
	{
		g_bDisguised[iClient] = true;
	}
}

public void TF2_OnConditionRemoved(int iClient, TFCond cond)
{
	if(cond == view_as<TFCond>(3)) //Disguised condition
	{
		g_bDisguised[iClient] = false;
	}
}