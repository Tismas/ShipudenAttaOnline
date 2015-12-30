#include "playerVars.dm"

obj
	Exam
		icon = 'exam.dmi'
		verb
			Take_Exam()
				set src in view(1)

				if(TimeToGeninExam>1 || usr:examinTaken)
					return

				//exam happening
				var points = 0
				var answer = input(usr, "Which one is taijutsu?", "Genin Exam") in list("Hand to Hand Combat","Illusion","Elemental techniques","Eye based techniques")
				if(answer == "Hand to Hand Combat")
					points++
				answer = input(usr, "Which one is ninjutsu?", "Genin Exam") in list("Hand to Hand Combat","Illusion","Elemental techniques","Eye based techniques")
				if(answer == "Elemental techniques")
					points++
				answer = input(usr, "Which one is genjutsu?", "Genin Exam") in list("Hand to Hand Combat","Illusion","Elemental techniques","Eye based techniques")
				if(answer == "Illusion")
					points++
				answer = input(usr, "Which one is doujutsu?", "Genin Exam") in list("Hand to Hand Combat","Illusion","Elemental techniques","Eye based techniques")
				if(answer == "Eye based techniques")
					points++
				answer = input(usr, "What is the highest rank?", "Genin Exam") in list("Jounin","Chunin","Kage","Academy Student")
				if(answer == "Kage")
					points++
				answer = input(usr, "What is the lowest rank?", "Genin Exam") in list("Jounin","Chunin","Kage","Academy Student")
				if(answer == "Academy Student")
					points++
				answer = input(usr, "Which one stands for fire?", "Genin Exam") in list("Raiton","Suiton","Doton","Katon")
				if(answer == "Katon")
					points++
				answer = input(usr, "Which one stands for earth?", "Genin Exam") in list("Raiton","Suiton","Doton","Katon")
				if(answer == "Doton")
					points++
				answer = input(usr, "Which one stands for lighting?", "Genin Exam") in list("Raiton","Suiton","Doton","Katon")
				if(answer == "Raiton")
					points++
				answer = input(usr, "Which one stands for water?", "Genin Exam") in list("Raiton","Suiton","Doton","Katon")
				if(answer == "Suiton")
					points++

				usr:examinTaken = 1
				while(TimeToGeninExamEnd > 1)
					sleep(1)
				usr:examinTaken = 0
				if(points<8)
					usr.loc = locate(2,17,1)
					usr << "<font color='gray' size='1'>You have failed genin exam! [points]/10</font>"
				else
					usr.loc = locate(42,144,1)
					world << "<font color='red' size='3'>[usr] just became genin!</font>"
					usr << "<font color='gray' size='1'>Congratulations! You've earned [points]/10 points</font>"
					usr:Rank = "Genin"
					usr:TaiCap = usr:GeninCap
					usr:NinCap = usr:GeninCap
					usr:GenCap = usr:GeninCap
					if(usr:Speciality == "Tai")
						usr:TaiCap = usr:GeninCapSpec
					else if(usr:Speciality == "Nin")
						usr:NinCap = usr:GeninCapSpec
					else if(usr:Speciality == "Gen")
						usr:GenCap = usr:GeninCapSpec
					else
						usr:TaiCap = usr:GeninCapAll
						usr:NinCap = usr:GeninCapAll
						usr:GenCap = usr:GeninCapAll
	katon
		icon = 'katon.dmi'
		var
			owner
		New(atom/newloc, atom/newdir, mob/newOwner)
			loc = newloc
			dir = newdir
			owner = newOwner
			..()
	Yen
		icon = 'money.dmi'
		var
			amount
		New(atom/newloc,amt)
			loc = newloc
			amount = amt
			..()
		verb
			Get()
				set src in view(1)
				usr << "<font size='1' color='gray'>You picked up [amount] gold.</font>"
				usr:Money += amount
				del(src)
	Tree
		icon = 'tree.dmi'
		density = 1
	Sign
		icon = 'sign.dmi'