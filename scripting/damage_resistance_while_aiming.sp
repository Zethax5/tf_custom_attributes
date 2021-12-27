/**
 * damage_resistance_while_aiming
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

#define DAMAGE_RESISTANCE_AIMING_ATTRIB_INDEX 5208

bool g_bAiming[MAXPLAYERS + 1];

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
		if(iWeapon > -1)
		{
			if(g_bAiming[iVictim])
			{
				if(TF2Attrib_GetByDefIndex(GetActiveWeapon(iVictim), DAMAGE_RESISTANCE_AIMING_ATTRIB_INDEX) != Address_Null)
				{
					float fMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(GetActiveWeapon(iVictim), DAMAGE_RESISTANCE_AIMING_ATTRIB_INDEX));
					fDamage *= fMultiplier;
					return Plugin_Changed;
				}
			}
		}
	}

	return Plugin_Continue;
}

public void TF2_OnConditionAdded(int iClient, TFCond cond)
{
	if(cond == view_as<TFCond>(0)) //Aiming condition
	{
		g_bAiming[iClient] = true;
	}
}

public void TF2_OnConditionRemoved(int iClient, TFCond cond)
{
	if(cond == view_as<TFCond>(0)) //Aiming condition
	{
		g_bAiming[iClient] = false;
	}
}