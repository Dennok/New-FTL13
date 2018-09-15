/obj/item/weapon_chip/projectile
	var/fire_delay = 5 //Time between shots
	var/shots_fired = 1
	var/projectile_icon = "laser"

/obj/item/weapon_chip/projectile/WeaponVisuals(var/turf/open/indestructible/ftlfloor/T, var/datum/player_attack/attack_info)
	.=..()
	for(var/i in 1 to shots_fired) //Fire for the amount of time
		addtimer(CALLBACK(src, .proc/SpawnProjectile, T, attack_info), fire_delay*i)

/obj/item/weapon_chip/projectile/proc/SpawnProjectile() //Projectile that flies out of the gun and dissapears, exists for visual aesthetic
	var/obj/item/projectile/ship_projectile/A = new(weapon.loc)
	A.icon_state =  projectile_icon
	A.setDir(EAST)
	A.pixel_x = 32
	A.pixel_y = 12
	A.yo = 0
	A.xo = 20
	A.starting = weapon
	A.fire()
	message_admins("pew")

	playsound(weapon, attack_info.fire_sound, 50, 1)

/obj/item/weapon_chip/projectile/ShootShip(var/turf/open/indestructible/ftlfloor/T, var/datum/player_attack/attack_info) //Real attack
	var/datum/starship/S = T.GetOurShip()
	var/matrix/M = RandomAimMatrix() //From what direction will we hit the shield?
	if(S.shield_integrity) //shot blocked by shields TODO: Make this visibly hit the shields and add actual visual shields.
		S.ShieldHit(attack_info)
		message_admins("shield")
		return
	message_admins("fire real projectile")
	for(var/i in 1 to shots_fired)
		addtimer(CALLBACK(src, .proc/SpawnShipProjectile, T, attack_info, M), fire_delay*i)

/obj/item/weapon_chip/projectile/proc/SpawnShipProjectile(var/turf/open/indestructible/ftlfloor/T, var/datum/player_attack/attack_info) //projectile that actually hits the ship
	var/obj/effect/ship_projectile/A = new(T, attack_info)
	A.icon_state = projectile_icon

/obj/item/weapon_chip/projectile/proc/RandomAimMatrix() //projectile that actually hits the ship
	var/angle = 0
	var/rand_coord = rand(-1000,1000)
	var/list/rand_edge = list(1,-1)
	if(prob(50)) // gets random location at the edge of a box
		pixel_x = rand_coord
		pixel_y = pick(rand_edge) * 1000
	else
		pixel_x = pick(rand_edge) * 1000
		pixel_y = rand_coord
	angle = ATAN2(0-pixel_y, 0-pixel_x)
	var/matrix/M = new
	M.Turn(angle + 180)
	return M

/obj/item/weapon_chip/projectile/phase
	fire_delay = 5 //Time between shots
	shots_fired = 3