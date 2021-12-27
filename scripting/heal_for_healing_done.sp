/**
 * heal_for_healing_done
 * 
 * Heals the player for a percentage of the healing they've done
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define HEAL_FOR_HEALING_DONE_ATTRIB_INDEX 5206
#define MAXIMUM_WEAPON_SLOTS 5

public void OnPluginStart()
{
	HookEvent("player_healed", Event_Healing);
}

public void Event_Healing(Event hEvent, const char[] sName, bool dontBroadcast)
{
	int iPatient = GetClientOfUserId(hEvent.GetInt("patient"));
	int iHealer = GetClientOfUserId(hEvent.GetInt("healer"));
	int iAmount = hEvent.GetInt("amount");

	//Checks to see if the healer is real
	//and makes sure the healer isn't the same as the patient
	if(IsValidClient(iHealer) && iHealer != iPatient)
	{
		for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
		{
			int iWeapon = GetPlayerWeaponSlot(iHealer, i);
			if(iWeapon > -1)
			{
				if(TF2Attrib_GetByDefIndex(iWeapon, HEAL_FOR_HEALING_DONE_ATTRIB_INDEX) != Address_Null)
				{
					float fMultiplier = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, HEAL_FOR_HEALING_DONE_ATTRIB_INDEX));
					int iHealingAmount = RoundToNearest(iAmount * fMultiplier);
					HealPlayer(iHealer, iHealingAmount);
				}
			}
		}
	}
}
