/**
 * healing_bonus_reduced_health
 * 
 * Increases healing received from packs and healers as the player's health goes down
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define HEALTH_FROM_HEALERS_ATTRIB_INDEX 70
#define HEALTH_FROM_PACKS_ATTRIB_INDEX 108
#define HEALING_BONUS_LOW_HEALTH_ATTRIB_INDEX 5211
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
            for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
            {
                int iWeapon = GetPlayerWeaponSlot(iClient, i);
                if(iWeapon > -1)
                {
                    if(TF2Attrib_GetByDefIndex(iWeapon, HEALING_BONUS_LOW_HEALTH_ATTRIB_INDEX) != Address_Null)
                    {
                        float fHealingBonus = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, HEALING_BONUS_LOW_HEALTH_ATTRIB_INDEX));
                        fHealingBonus *= 1.0 - (GetClientHealth(iClient) * 1.0 / GetClientMaxHealth(iClient) * 1.0);
                        fHealingBonus += 1.0;
                        
                        TF2Attrib_SetByDefIndex(iWeapon, HEALTH_FROM_HEALERS_ATTRIB_INDEX, fHealingBonus);
                        TF2Attrib_SetByDefIndex(iWeapon, HEALTH_FROM_PACKS_ATTRIB_INDEX, fHealingBonus);
                    }
                }
            }

            g_fLastTick[iClient] = GetEngineTime();
        }
    }

    return Plugin_Continue;
}