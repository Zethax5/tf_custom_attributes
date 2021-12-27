/**
 * move_speed_bonus_while_capping
 * 
 * Grants a movement speed bonus while capturing a control point or carrying a flag
 */
#pragma semicolon 1
#include <sourcemod>
#include <zethax>

#pragma newdecls required

#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>

#define MOVE_SPD_BONUS_ATTRIB_INDEX 1002
#define MOVE_SPD_WHILE_CAPPING_ATTRIB_INDEX 5210
#define MAXIMUM_WEAPON_SLOTS 5

public void OnPluginStart()
{
	HookEvent("controlpoint_starttouch", Event_ControlPoint_StartTouch);
	HookEvent("controlpoint_endtouch", Event_ControlPoint_EndTouch);
	HookEvent("teamplay_flag_event", Event_TeamplayFlagEvent);
}

public Action Event_ControlPoint_StartTouch(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(hEvent.GetInt("player"));
	if(IsValidClient(iClient))
	{
		for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
		{
			int iWeapon = GetPlayerWeaponSlot(iClient, i);
			if(iWeapon > -1)
			{
				if(TF2Attrib_GetByDefIndex(iWeapon, MOVE_SPD_WHILE_CAPPING_ATTRIB_INDEX) != Address_Null)
				{
					float fSpeedBonus = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, MOVE_SPD_WHILE_CAPPING_ATTRIB_INDEX));
					TF2Attrib_SetByDefIndex(iWeapon, MOVE_SPD_BONUS_ATTRIB_INDEX, fSpeedBonus);
					TF2_AddCondition(iClient, TFCond_SpeedBuffAlly, 0.001);
				}
			}
		}
	}
}

public Action Event_ControlPoint_EndTouch(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(hEvent.GetInt("player"));
	if(IsValidClient(iClient))
	{
		for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
		{
			int iWeapon = GetPlayerWeaponSlot(iClient, i);
			if(iWeapon > -1)
			{
				if(TF2Attrib_GetByDefIndex(iWeapon, MOVE_SPD_WHILE_CAPPING_ATTRIB_INDEX) != Address_Null)
				{
					TF2Attrib_RemoveByDefIndex(iWeapon, MOVE_SPD_BONUS_ATTRIB_INDEX);
					TF2_AddCondition(iClient, TFCond_SpeedBuffAlly, 0.001);
				}
			}
		}
	}
}

public Action Event_TeamplayFlagEvent(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(hEvent.GetInt("player"));
	int iEventType = hEvent.GetInt("eventtype");
	if(IsValidClient(iClient))
	{
		switch(iEventType)
		{
			//Adds the speed bonus while carrying the flag
			case 1:
			{
				for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
				{
					int iWeapon = GetPlayerWeaponSlot(iClient, i);
					if(iWeapon > -1)
					{
						if(TF2Attrib_GetByDefIndex(iWeapon, MOVE_SPD_WHILE_CAPPING_ATTRIB_INDEX) != Address_Null)
						{
							float fSpeedBonus = TF2Attrib_GetValue(TF2Attrib_GetByDefIndex(iWeapon, MOVE_SPD_WHILE_CAPPING_ATTRIB_INDEX));
							TF2Attrib_SetByDefIndex(iWeapon, MOVE_SPD_BONUS_ATTRIB_INDEX, fSpeedBonus);
							TF2_AddCondition(iClient, TFCond_SpeedBuffAlly, 0.001);
						}
					}
				}
			}
			//Removes the speed bonus after dropping the flag
			case 4:
			{
				for(int i = 0; i < MAXIMUM_WEAPON_SLOTS; i++)
				{
					int iWeapon = GetPlayerWeaponSlot(iClient, i);
					if(iWeapon > -1)
					{
						if(TF2Attrib_GetByDefIndex(iWeapon, MOVE_SPD_WHILE_CAPPING_ATTRIB_INDEX) != Address_Null)
						{
							TF2Attrib_RemoveByDefIndex(iWeapon, MOVE_SPD_BONUS_ATTRIB_INDEX);
							TF2_AddCondition(iClient, TFCond_SpeedBuffAlly, 0.001);
						}
					}
				}
			}
		}
	}
}
