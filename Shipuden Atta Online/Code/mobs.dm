#include "playerVars.dm"
mob
	var
		Health
	proc
		AddClone(mob/Shadowclone/c)
			if(!usr:clones)
				usr:clones = list(c)
				verbs += /verb/Bunshin_Attack
				verbs += /verb/Bunshin_Follow
				verbs += /verb/Bunshin_Dispear
			else
				if(usr:clones.len<8)
					usr:clones += c
				else
					if(c)
						del(c)

		LoseClone(mob/Shadowclone/c)
			if(usr:clones)
				usr:clones -= c
				if(!usr:clones.len)
					verbs -= /verb/Bunshin_Attack
					verbs -= /verb/Bunshin_Follow
					verbs -= /verb/Bunshin_Dispear
					usr:clones = null
					usr:clone_target = null
			c.owner = null
			c.target = null

		Die()
			if(usr:clones)
				for(var/mob/Shadowclone/c in usr:clones)
					c.owner = null
					c.target = null
				usr:clone_target = null
				usr:clones = null
				verbs -= /verb/Bunshin_Attack
				verbs -= /verb/Bunshin_Follow
				verbs -= /verb/Bunshin_Dispear
			..()
		DeathCheck()
			if(src.client == null && Health<=0)
				del(src)
			else if(src.client != null && src:Stamina <= 0)
				if(src.client != null)
					if(src == usr)
						world << "<font size='3' color='gray'>[usr] decided to kill himself!</font>"
						src.Die()
					else
						world << "<font size='3' color='gray'>[src] has been killed by [usr]!</font>"
						src.Die()

	Treestump
		icon = 'treeStump.dmi'
		Health = 1000000000

	Bunshin
		icon = 'player.dmi'
		icon_state = "male"

	Chicken
		icon = 'chicken.dmi'
		Health = 1

		Die()
			var/tempLoc = src.loc
			new/Item/Feather(src.loc)
			loc = locate(35,93,1) // pustka
			sleep(20)
			loc = tempLoc
		Del()
			Die()

	Shadowclone
		icon = 'player.dmi'
		icon_state = "male"

		//Cross()
		//	world << "test"

		Move()
			if(speeding <= 0)
				speeding = 1
				..()
				sleep(rundelay)
				speeding = 0
			else
				return
		var/tmp
			speeding = 0
			rundelay = 2
			kage
			mob/target
			mob/Player/owner
			Tai
		proc
			AI()
				set waitfor = 0
				var/tdist
				while(loc&&owner)
					if(target)
						tdist = get_dist(src,target)
						if(tdist<=1)
							AI_attack()
						else if(tdist<=12)
							AI_chase()
						else
							target = null
					else
						target = null
						AI_follow()
					sleep(1) // TICK_LAG
				Die()

			AI_chase()
				var/tdist = get_dist(src,target)
				while(loc&&target&&tdist<=12)
					if(tdist<=1)
						AI_attack(target)
						return
					else
						step_to(src,target)
					sleep(world.tick_lag)
					tdist = get_dist(src,target)

			AI_attack()
				var/tdist = get_dist(src,target)
				while(loc&&target&&tdist<=1)
					tdist = get_dist(src,target)
					if(kage && tdist <=1 )
						F_damage(target, round(Tai/10), "#ffffff")
						target.Health -= round(Tai/10)
						target.DeathCheck()
						owner.TaiExp++
						if(owner.TaiExp>=owner.TaiExpNeed)
							var/gain = rand(1,5)
							owner.Tai += gain
							owner.TaiExp -= owner.TaiExpNeed
					sleep(10)

			AI_follow()
				var/odist = get_dist(src,owner)
				while(loc&&owner&&!target)
					odist = get_dist(src,owner)
					if(odist>=2)
						step_to(src,owner)
					sleep(world.tick_lag)

		Del()
			if(owner)
				owner.LoseClone(src)
			..()

		New(atom/newloc,mob/Player/owner)
			if(newloc == null)
				return
			..()
			src.owner = owner
			src.target = owner.clone_target
			AI()