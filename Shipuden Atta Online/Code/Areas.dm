proc
	WaterWalking()
		while(usr:WaterTraining)
			usr:LoopCount++
			if(usr:LoopCount>1)
				usr:LoopCount--
				return
			if(usr:Chakra<=0)
				var/loss = rand(50,100)
				usr << "<font size='1' color='cyan'>You're drawning! You lost </font><font size='1' color='red'>[loss] </font><font size='1' color='cyan'>HP</font>"
				usr:Stamina -= loss
				usr:DeathCheck()
			else
				var/randomG = rand(1,3)
				if(randomG == 1)
					var/gain = rand(1,10)
					usr:MaxChakra += gain
					usr << "<font size='1' color='cyan'>You gained [gain] chakra</font>"
				if(usr:ChakraControl < 100)
					var/random = rand(1,100/usr:ChakraControl)
					if(random == 1)
						usr << "<font size='1' color='cyan'>You're feeling it! \[5/5\]</font>"
						usr:Chakra -= 5
						if(rand(1,20) == 10)
							usr:ChakraControl++
					else
						var/loss = rand(1,10)
						if(loss > usr:Chakra)
							loss = usr:Chakra
						if(loss>5)
							usr << "<font size='1' color='cyan'>You used too much chakra! \[[loss]/5\]</font>"
						if(loss<5)
							usr << "<font size='1' color='cyan'>You used too little chakra! \[[loss]/5\]</font>"
						usr:Chakra -= loss
				else
					usr << "<font size='1' color='cyan'>You're feeling it! \[5/5\]</font>"
					usr:Chakra -= 5
			if(usr:Chakra<0)
				usr:Chakra = 0
			if(usr:LoopCount>1)
				return
			sleep(10)
			usr:LoopCount = 0

area
	Water
		Entered()
			usr:WaterTraining = 1
			WaterWalking()
			..()
		Exited()
			usr:WaterTraining = 0
			..()

	StaminaMountain
		Entered()
			usr:isOnMountain = 1
			..()
		Exited()
			usr:isOnMountain = 0
			..()

	LeafVillage
		name = "Leaf Village"

	GeninExamArea
		Entered()
			usr << "<font color='gray' size='1'>When the exam starts you will have one minute to complete 10 tasks</font>"
			usr << "<font color='gray' size='1'>You will have to give at least 8 correct answers to pass the exam.</font>"
			usr << "<font color='gray' size='1'>After exam start you won't be able to leave, when exam ends you will be teleported.</font>"