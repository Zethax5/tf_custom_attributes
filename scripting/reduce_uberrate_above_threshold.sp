/**
 * reduce_uberrate_above_threshold
 * 
 * Reduces medigun ubercharge build rate by 50% when above a given health threshold
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define UBERRATE_PENALTY_ATTRIB_INDEX 9
#define REDUCE_UBERRATE_ABOVE_ATTRIB_INDEX 5215
#define MAXIMUM_WEAPON_SLOTS 5
#define PRETHINK_INTERVAL 0.1

float g_fLastTick[MAXPLAYERS + 1];

public void OnMapStart() {
    for (int i = 1; i <= MaxClients; i++) {
        if (IsClientInGame(i)) {
            OnClientPutInServer(i);
        }
    }
}

public void OnClientPutInServer(int iClient) {
    SDKHook(iClient, SDKHook_PreThink, OnClientPreThink);
}

public Action OnClientPreThink(int iClient)
{
    if(IsValidClient(iClient))
    {
        if(GetEngineTime() >= g_fLastTick[iClient] + PRETHINK_INTERVAL)
        {
            int iMedigun = GetPlayerWeaponSlot(iClient, 1); //Uber build rate really only applies to mediguns, so we only need to target the secondary slot
            if(iMedigun > -1 && GetActiveWeapon(iClient) == iMedigun)
            {
                if(TF2Attrib_GetByDefIndex(iMedigun, REDUCE_UBERRATE_ABOVE_ATTRIB_INDEX) != Address_Null)
                {
                    int iHealTarget = 0;
                    if(GetEntPropEnt(iMedigun, Prop_Send, "m_hHealingTarget") > -1)
                        iHealTarget = GetEntPropEnt(iMedigun, Prop_Send, "m_hHealingTarget");

                    if(IsValidClient(iHealTarget))
                    {
                        int iPatientHealth = GetClientHealth(iHealTarget);
                        float fOverhealThreshold = GetClientMaxHealth(iHealTarget) * TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iMedigun, REDUCE_UBERRATE_ABOVE_ATTRIB_INDEX));
                        if(iPatientHealth > fOverhealThreshold)
                        {
                            TF2Attrib_SetByDefIndex(iMedigun, UBERRATE_PENALTY_ATTRIB_INDEX, 0.5); //50% build rate penalty
                        }
                        else
                        {
                            TF2Attrib_RemoveByDefIndex(iMedigun, UBERRATE_PENALTY_ATTRIB_INDEX);
                        }
                    }
                }
            }

            g_fLastTick[iClient] = GetEngineTime();
        }
    }

    return Plugin_Continue;
}