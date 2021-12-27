/**
 * ramping_damage_resistance_while_aiming
 * 
 * Grants an amount of damage resistance that ramps up while aiming/spun up
 * Damage resistance will decay if being healed
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define RAMPING_DAMAGE_RESISTANCE_AIMING_ATTRIB_INDEX 5209
#define PRETHINK_INTERVAL 0.1
#define MAXIMUM_AIMTIME 2.0 //The interval over which the damage resistance will ramp up

float g_fLastTick[MAXPLAYERS + 1];
bool g_bAiming[MAXPLAYERS + 1];
float g_fTimeAiming[MAXPLAYERS + 1];

public void OnMapStart() 
{
	for (int i = 1; i <= MaxClients; i++) 
	{
		if (IsClientInGame(i)) 
		{
			OnClientPutInServer(i);
		}
	}
}

public void OnClientPutInServer(int iClient) 
{
	SDKHook(iClient, SDKHook_OnTakeDamageAlive, OnTakeDamageAlive);
	SDKHook(iClient, SDKHook_PreThink, OnClientPreThink);
}

public Action OnTakeDamageAlive(int iVictim, int &iAttacker, int &iInflictor, float &fDamage, int &iDamageType, int &iWeapon, float[3] fDamageForce, float[3] fDamagePos)
{
	if(IsValidClient(iVictim))
	{
		if(iWeapon > -1)
		{
			if(g_bAiming[iVictim])
			{
				if(TF2Attrib_GetByDefIndex(GetActiveWeapon(iVictim), RAMPING_DAMAGE_RESISTANCE_AIMING_ATTRIB_INDEX) != Address_Null)
				{
					float fMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(GetActiveWeapon(iVictim), RAMPING_DAMAGE_RESISTANCE_AIMING_ATTRIB_INDEX));
					fMultiplier = 1.0 - ((g_fTimeAiming[iVictim] / MAXIMUM_AIMTIME) * fMultiplier);

					fDamage *= fMultiplier;
					return Plugin_Changed;
				}
			}
		}
	}

	return Plugin_Continue;
}

public Action OnClientPreThink(int iClient)
{
	if(IsValidClient(iClient))
	{
		if(GetEngineTime() >= g_fLastTick[iClient] + PRETHINK_INTERVAL)
		{
			//Keeps track of how long the player has been aiming for
			if(g_bAiming[iClient])
			{
				if(GetEntProp(iClient, Prop_Send, "m_nNumHealers") > 0)
					g_fTimeAiming[iClient] -= PRETHINK_INTERVAL;
				else
					g_fTimeAiming[iClient] += PRETHINK_INTERVAL;

				if(g_fTimeAiming[iClient] > MAXIMUM_AIMTIME)
					g_fTimeAiming[iClient] = MAXIMUM_AIMTIME;

				if(g_fTimeAiming[iClient] < 0.0)
					g_fTimeAiming[iClient] = 0.0;
			}
			else
				g_fTimeAiming[iClient] = 0.0;

			g_fLastTick[iClient] = GetEngineTime();
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