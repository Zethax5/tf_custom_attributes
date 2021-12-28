# tf_custom_attributes
A set of custom attributes which uses rafradek's Hidden Dev Attributes plugin to inject the attributes directly into the item schema. What this essentially means is that these attributes can be used on any weapons, custom or official.

# Installing

rafradek's Hidden dev attributes plugin is necessary for this plugin to run. It can be downloaded here: https://forums.alliedmods.net/showthread.php?t=326853

Both the plugins and the zethaxattribs.txt files are required for these attributes to work. One will not work without the other sort of thing.

These plugins are rather dirty, and I'm absolutely certain there are better ways they could work. However, because I'm not a professional, I haven't figured out a way to make them better and more lightweight. The attributes themselves guaranteed work, but not without some system overhead for sure. Just be aware of this if your server is running a lot of other plugins already.

# Included Attributes

<details> <p>
  <summary> Click here to expand </summary>

```
"fire rate bonus after deploy" #5201
  Grants the given weapon a given fire rate bonus for the first 3 seconds after deploying
    0.75 = 25% fire rate bonus for the first 3 seconds after deploying
  TO DO: Make a convar that controls duration

"fire rate bonus on primary" #5200
  Grants your primary weapon the given fire rate bonus
    0.9 = 10% fire rate bonus on the primary weapon

"reload rate bonus on primary" #4999
  Grants your primary weapon the given reload rate bonus
    0.9 = 10% reload rate bonus on the primary weapon
 
"kill with any weapon reloads" #5204
  Instantly reloads the given amount of ammo into a weapon's clip on kill, regardless of what weapon got the kill. 
    2 = 2 rounds loaded into the clip.
  Respects "While Active" rules.

"percent damage done heals" #5205
  A given percent of damage dealt is returned as health. 
    0.25 = 25% damage returned as health
    
"heal for healing done" #5206
  A given percent of healing done to other players is returned as health.
    0.25 = 25% healing done restores health

"bullets ignite at close range" #5207
  Allows a weapon to ignite enemies for a given duration if they are within 500 HU.
    2 = 2 seconds of burn
  TO DO: Make a convar that controls range of ignition

"damage resistance while aiming" #5208
  Multiplies damage taken by the given value while aiming the sniper rifle/spinning the minigun.
    0.8 = 20% damage resistance while aiming/spun up

"ramping damage resistance while aiming" #5209
  Same as above, but instead ramps up over the course of 2 seconds after aiming/spinning up.
    0.2 = 20% damage resistance at maximum
  This damage resistance will decay while being healed, at the same rate as it ramps up.

"speed bonus while capping" #5210
  Multiplies movement speed by the given amount while doing an objective (capturing a point, carrying the intelligence, etc.)
    1.15 = 15% movement speed bonus while capping

"healing bonus with reduced health" #5211
  Multiplies healing received by the given amount, scaling with current health compared to maximum health.
    0.2 = 20% maximum healing bonus
    -0.2 = = 20% maximum healing penalty

"damage penalty after sticky arm" #5212
  Multiplies damage dealt by the given amount for the first second after the most recent stickybomb fired arms.
    0.8 = 20% damage penalty for the first second after arming
  TO DO: Make a convar that allows for adjusting duration

"crit vs gassed players" #5213
  Does what it says on the tin.
    1 = Enabled
 
"damage resistance while disguised" #5214
  Multiplies damage taken by the given amount while disguised.
    0.8 = 20% damage resistance while disguised

"reduce ubercharge build rate above threshold" #5215
  Reduces ubercharge build rate by 50% when patient is above the given overheal amount.
    1.2 = 120% health, or 20% overheal on a patient, will halve build rate.
  This will not overwrite the default build rate penalty when a patient is above 142.5% health.

"decaying dmg penalty after sticky arm" #5216
  Multiplies damage dealt by the given amount for the first second after the most recent stickybomb fired arms.
  This multiplier will scale down linearly over the first second after firing.
    0.8 = 20% decaying damage penalty

"remove overheal on hit" #5217
  Adds the victim's overhealed health to damage dealt.
    1 = Enabled

"apply healing received penalty on hit" #5218
  Inflicts a healing debuff on the victim for 5 seconds. This debuff multiplies healing received by the given amount. Applies to mediguns, dispensers, and medkits.
    0.8 = 20% reduction in healing for 5 seconds.
  TO DO: Make a convar for adjusting the duration

"damage bonus vs stunned players" #5219
  Multiplies damage dealt to slowed or stunned players. 
    1.2 = 20% damage bonus vs stunned players
 
"speed boost on hit burning player" #5220
  Grants a speed boost for the given duration after hitting a burning player.
    3.0 = 3 second speed boost for hitting a burning player.

"remove afterburn on hit" #5221
  Extinguishes a burning victim on hit.
    1 = Enabled.

"heal on kill any weapon" #5222
  When a kill is made with any weapon, the killer is healed for the given amount. This can overheal up to 150%.
    25 = 25 health on kill with any weapon
  Will not respect "While Active" rules. There's an attribute for that already in game.

"heal on assist" #5223
  Assisting in a kill will heal for the given amount. This can overheal up to 150%.
  Respects "While Active" rules.

"damage pierces resistance effects fixed" #5224
  Allows damage dealt by a weapon to pierce resistance effects. Only works with bullet resistance, as this is meant to go on a Spy's Revolver.
    1 = Enabled.

"kill increases reload speed" #5225
  Grants the provided percentage of reload speed on kill, which can stack up to 4 times. Does not come with a counter for kills, as this is meant to go on the Air Strike.
    0.25 = 25% bonus reload speed on kill

"dmg bonus vs players with more health" #5226
  Multiplies damage dealt to a player with more maximum health than you.
    1.25 = 25% more damage vs players with more maximum health

"dmg penalty vs players with less health" #5227
  Multiplies damage dealt to a player with the same or less maximum health than you.
    0.75 = 25% less damage vs players with less maximum health
```

</p>
</details>

# Source Code

Sources are provided if you want to see my god awful self-taught coding techniques. Also suggestions for better ways to make certain attributes work would be absolutely welcome. Always happy to learn from those that are better than me.
