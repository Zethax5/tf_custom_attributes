/**
 * damage_pierces_resistances_fixed
 * 
 * Adds an attribute that actually pierces damage resistance effects, without ignoring vulnerabilities as well.
 * Only works on bullet resistance effects.
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define DAMAGE_PIERCES_FIXED 5224
#define BATTALIONS_BACKUP_EFFECT view_as<TFCond>(26)
#define VACC_BULLET_RESIST_UBER view_as<TFCond>(58)
#define VACC_BULLET_RESIST_PASSIVE view_as<TFCond>(61)
#define CLOAKED view_as<TFCond>(4)
#define BULLET_RESISTANCE_ATTRIB 66
#define RANGED_DMG_RESISTANCE_ATTRIB 205
#define WHILE_ACTIVE_ATTRIB 128
#define MAXIMUM_WEAPON_SLOTS 5

bool g_bIsSentry[2049];

public void OnMapStart() {
	for (int i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i)) { 
			OnClientPutInServer(i);
		}
	}

	HookEvent("player_builtobject", Event_PlaceBuilding);

	if (IsValidEntity(0))
	{
		int i = -1;
		while ((i = FindEntityByClassname(i, "obj_*")) != -1)
		{
			SDKHook(i, SDKHook_OnTakeDamage, OnTakeDamage_Building);
		}
	}
}

public void OnClientPutInServer(int iClient) {
	SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int iVictim, int &iAttacker, int &iInflictor, float &fDamage, int &iDamageType, int &iWeapon, float[3] fDamageForce, float[3] fDamagePos)
{
	Action aAction;
	if(IsValidClient(iAttacker) && IsValidClient(iVictim))
	{
		if(iWeapon > -1)
		{
			if(TF2Attrib_GetByDefIndex(iWeapon, DAMAGE_PIERCES_FIXED) != Address_Null)
			{
				if(TF2_IsPlayerInCondition(iVictim, BATTALIONS_BACKUP_EFFECT))
				{
					fDamage += fDamage * 0.5;
					aAction = Plugin_Changed;
				}
				if(TF2_IsPlayerInCondition(iVictim, VACC_BULLET_RESIST_UBER))
				{
					fDamage *= 4.0;
					aAction = Plugin_Changed;
				}
				if(TF2_IsPlayerInCondition(iVictim, VACC_BULLET_RESIST_PASSIVE))
				{
					fDamage *= (10.0/9.0);
					aAction = Plugin_Changed;
				}
				if(TF2_IsPlayerInCondition(iVictim, CLOAKED))
				{
					fDamage *= (1.0/0.8);
					aAction = Plugin_Changed;
				}
				for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
				{
					int iVictimWeapon = GetPlayerWeaponSlot(iVictim, i);
					if(iVictimWeapon > -1)
					{
						if(TF2Attrib_GetByDefIndex(iVictimWeapon, BULLET_RESISTANCE_ATTRIB) != Address_Null)
						{
							PrintToChat(iAttacker, "Victim weapon slot %i has bullet resistance", i);
							if(TF2Attrib_GetByDefIndex(iVictimWeapon, WHILE_ACTIVE_ATTRIB) != Address_Null && GetActiveWeapon(iVictim) == iVictimWeapon)
							{
								float fBulletResistance = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iVictimWeapon, BULLET_RESISTANCE_ATTRIB));
								fDamage *= (1.0 / fBulletResistance); //We multiply damage by the reciprocal of the resistance to remove said resistance
								aAction = Plugin_Changed;
								PrintToChat(iAttacker, "Active bullet resist negated: %f", fBulletResistance);
							}
							else
							{
								float fBulletResistance = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iVictimWeapon, BULLET_RESISTANCE_ATTRIB));
								fDamage *= (1.0 / fBulletResistance); //We multiply damage by the reciprocal of the resistance to remove said resistance
								aAction = Plugin_Changed;
								PrintToChat(iAttacker, "Bullet resist negated: %f", fBulletResistance);
							}
						}
						if(TF2Attrib_GetByDefIndex(iVictimWeapon, RANGED_DMG_RESISTANCE_ATTRIB) != Address_Null)
						{
							PrintToChat(iAttacker, "Victim weapon slot %i has ranged resistance", i);
							if(GetActiveWeapon(iVictim) == iVictimWeapon)
							{
								float fRangedResistance = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iVictimWeapon, RANGED_DMG_RESISTANCE_ATTRIB));
								fDamage *= (1.0 / fRangedResistance); //We multiply damage by the reciprocal of the resistance to remove said resistance
								aAction = Plugin_Changed;
								PrintToChat(iAttacker, "Ranged resist negated: %f", fRangedResistance);
							}
						}
					}
				}
			}
		}
	}

	return aAction;
}

public Action OnTakeDamage_Building(int iVictim, int &iAttacker, int &iInflictor, float &fDamage, int &iDamageType, int &iWeapon, float[3] fDamageForce, float[3] fDamagePos)
{
	if(IsValidClient(iAttacker) && TF2_GetPlayerClass(iAttacker) == TFClass_Spy)
	{
		if(iWeapon > -1)
		{
			if(g_bIsSentry[iVictim])
			{
				if(TF2Attrib_GetByDefIndex(iWeapon, DAMAGE_PIERCES_FIXED) != Address_Null)
				{
					if(GetEntProp(iVictim, Prop_Send, "m_bHasSapper"))
					{
						fDamage *= 1.5;
						return Plugin_Changed;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action Event_PlaceBuilding(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	int iOwner = GetClientOfUserId(hEvent.GetInt("userid"));
	int iEntity = hEvent.GetInt("index");

	if (!IsValidClient(iOwner)) return Plugin_Continue;
	if(!IsValidEntity(iEntity)) return Plugin_Continue;

	if(IsClassname(iEntity, "obj_sentrygun"))
		g_bIsSentry[iEntity] = true;

	SDKHook(iEntity, SDKHook_OnTakeDamage, OnTakeDamage_Building);

	return Plugin_Continue;
}