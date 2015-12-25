// File Directories
#define FILE_DIR Code
#define FILE_DIR Assets
#define FILE_DIR Assets/Icons
#define FILE_DIR Assets/Icons/New

// Includy moich plikow
#include "Code/mobs.dm"
#include "Code/playerCommands.dm"
#include "Code/playerJutsus.dm"
#include "Code/objects.dm"
#include "Code/turfs.dm"
#include "Code/playerVars.dm"
#include "Code/playerProc.dm"
#include "Code/Items.dm"

// character
#include <deadron/characterhandling>

// dmg flick
#include "F_Damage.dm"
#include "Cache.dm"
#ifndef F_damage_layer
#define F_damage_layer 10000
#endif
#ifndef F_damage_numWidth
#define F_damage_numWidth 7
#endif
#ifndef F_damage_icon
#define F_damage_icon 'F_damageFade.dmi'
#endif

/*
	Project created by Tismas on 16/12/2015
 */

var
	TimeToGeninExam
	TimeToGeninExamEnd

	TimeToChuninExam
	TimeToChuninExamEnd

world
	name = "Shipuuden Atta Online"
	fps = 30
	icon_size = 32
	view = 9

	mob = /mob/creating_character

	New()
		TimeToGeninExam = 10
		TimeToGeninExamEnd = 60
		ExamHandler()
		..()

	proc
		ExamHandler()
			if(TimeToGeninExam>0)
				TimeToGeninExam--
			var/mob/Player/M
			if(TimeToGeninExam == 300 || TimeToGeninExam == 240 || TimeToGeninExam == 180 || TimeToGeninExam == 120 || TimeToGeninExam == 60)
				for(M in world.contents)
					if(M.Rank == "Academy Student")
						M << "<font color='red'><b>Genin exam will take place in [TimeToGeninExam/60] minutes!</b></font>"
			else if(TimeToGeninExam == 0 && TimeToGeninExamEnd > 0)
				if(TimeToGeninExamEnd == 60)
					for(M in world.contents)
						if(M.Rank == "Academy Student")
							M << "<font color='red'><b>Genin exam has started!</b></font>"
				TimeToGeninExamEnd--
			else if(TimeToGeninExamEnd == 0)
				TimeToGeninExam = 1800
				TimeToGeninExamEnd = 60
				for(M in world.contents)
					if(M.Rank == "Academy Student")
						M << "<font color='red'><b>Next genin exam will take place in 30 minutes! </b></font>"
			// Who handler przy okazji
			var/OnlinePlayers = {"<style> *{color = 'green'; text-align:center; background-color = 'black';}</style>"}
			for(M in world.contents)
				OnlinePlayers += "<b>[M.name]</b>"
				M << output(OnlinePlayers,"Who.Who")
			spawn(10)
				ExamHandler()

client
	base_num_characters_allowed = 3

mob
	step_size = 32
	Cross(atom/movable/m)
		if(istype(m,/obj/katon))
			usr = m:owner
			Health -= m:owner:Nin
			F_damage(src,m:owner:Nin,"#ffffff")
			del(m)				// Jesli DeathCheck przed del to jesli zabije to leci dalej
			DeathCheck()
		if(istype(m,/Item/Rock))
			usr = m:owner
			Health -= round(m:owner:Tai/2)
			F_damage(src,m:owner:Tai/2,"#ffffff")
			del(m)
			DeathCheck()
		..()

obj
	step_size = 32