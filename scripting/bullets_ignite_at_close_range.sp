/**
 * bullets_ignite_at_close_range
 * 
 * Allows the player's weapon to ignite players at close range
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define CLOSERANGE_IGNITE_ATTRIB_INDEX 5207
#define CLOSERANGE_IGNITE_RANGE 500 //same range as the Back Scatter's minicrit range

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
			if(TF2Attrib_GetByDefIndex(iWeapon, CLOSERANGE_IGNITE_ATTRIB_INDEX) != Address_Null)
			{
				float fAttackerPos[3];
				float fVictimPos[3];
				GetClientAbsOrigin(iAttacker, fAttackerPos);
				GetClientAbsOrigin(iVictim, fVictimPos);
				float fDistance = GetVectorDistance(fAttackerPos, fVictimPos);

				if(fDistance < CLOSERANGE_IGNITE_RANGE)
				{
					float fIgniteDuration = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, CLOSERANGE_IGNITE_ATTRIB_INDEX));
					TF2_IgnitePlayer(iVictim, iAttacker, fIgniteDuration);
				}
			}
		}
	}

	return Plugin_Continue;
}