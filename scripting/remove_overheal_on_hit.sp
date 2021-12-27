/**
 * remove_overheal_on_hit
 * 
 * Hits will remove the victim's overheal
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define REMOVE_OVERHEAL_ATTRIB_INDEX 5217

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
			if(TF2Attrib_GetByDefIndex(iWeapon, REMOVE_OVERHEAL_ATTRIB_INDEX) != Address_Null)
			{
				if(GetClientHealth(iVictim) > GetClientMaxHealth(iVictim))
				{
					fDamage += (GetClientHealth(iVictim) - GetClientMaxHealth(iVictim)) * 1.0;
					return Plugin_Changed;
				}
			}
		}
	}

	return Plugin_Continue;
}