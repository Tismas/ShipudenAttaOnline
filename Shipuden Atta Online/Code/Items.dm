#include "playerProc.dm"
#include "playerVars.dm"
Item
	parent_type = /obj
	density = 0
	var
		amount = 1
		baseName
		kind

	verb/Get()
		set src in oview(1)
		var/amt
		if(istype(src))
			var/Item/X=locate(src.type) in usr.contents-src
			if(X)
				amt = src.amount
				src.amount+=X.amount
				UpdateName()
				del X
		Pickup_proc(usr, amt)
		usr.Inventory()

	verb/Drop()
		set src in usr
		/var/amt
		if(amount>1)
			amt=max(0,min(100000,input("How many [name] do you wish to drop? Maximum amount: [min(100000,amount)]","Item drop",1) as num|null))
		else
			amt=1
		if(!(src in usr)||!amt) return 0
		var/turf/XX = get_step(usr,turn(usr.dir,180))
		if(!XX)XX=usr.loc
		if(amt>=amount).=Move(XX)
		else
			var/Item/X = type
			X = new X(usr.loc)
			X.amount = amt
			X.UpdateName()
			amount-=amt
			.=1
		UpdateName()
		usr.Inventory()
		usr << "<font color='gray' size='1'>You dropped [amt] [src.baseName]\s."

	proc/Pickup_proc(mob/M, amt)
		if(!(M in oview(1,src))) return
		.=Move(M)
		M << "<font color='gray' size='1'>You picked up [amt] [src.baseName]\s."

	proc/UpdateName()
		if(src.amount == 1)
			src.name = "[src.baseName]"
		else
			src.name = "[src.baseName] ([src.amount])"

	//Item list
	Feather
		icon = 'feather.dmi'
		baseName = "Feather"
		kind = "Item"

	Rock
		icon = 'rock.dmi'
		baseName = "Rock"
		kind = "Item"

		var
			owner
		verb
			Throw()
				if(amount>0)
					amount--

					UpdateName()

					var/origin = get_step(src,dir)
					var/maxDist = 8
					var rock = new/Item/Rock(src.loc)
					rock:dir = usr.dir
					rock:owner = usr
					while(rock && get_dist(origin,rock:loc) < maxDist)
						step(rock,rock:dir,32)
						sleep(1)
					del(rock)
					usr.Inventory()

	Sword
		icon = 'bed.dmi'
		baseName = "Sword"
		kind = "Weapon"

	Shuriken
		icon = 'shuriken.dmi'
		baseName = "Shuriken"
		kind = "Weapon"

		var
			owner
		verb
			Throw()
				if(amount>0)
					amount--

					UpdateName()

					var/origin = get_step(src,dir)
					var/maxDist = 10
					var shuriken = new/Item/Shuriken(src.loc)
					shuriken:dir = usr.dir
					shuriken:owner = usr
					while(shuriken && get_dist(origin,shuriken:loc) < maxDist)
						step(shuriken,shuriken:dir,32)
						sleep(1)
					del(shuriken)
					usr.Inventory()

	New()
		..()
		mouse_drag_pointer = icon(src.icon, src.icon_state)