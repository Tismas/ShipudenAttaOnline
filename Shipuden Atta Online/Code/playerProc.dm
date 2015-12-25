#include "playerVars.dm"
mob
	proc
		Inventory()
			var
				i=0
				j=0
			src << output("","ItemsGrid")
			for(var/Item/I in contents)
				if(I.amount>0 && I.kind == "Item")
					if(i%3==0)
						++j
						i=0
					src << output(I,"ItemsGrid:[++i],[j]")
			i = 0
			j = 0
			src << output("","WeaponsGrid")
			for(var/Item/I in contents)
				if(I.amount>0 && I.kind == "Weapon")
					if(i%3==0)
						++j
						i=0
					src << output(I,"WeaponsGrid:[++i],[j]")

	Player
		proc
			CheckExpCaps()
				if(TaiExp > TaiExpNeed)
					TaiExp -= TaiExpNeed
					Tai += rand(1,9)
				if(NinExp > NinExpNeed)
					NinExp -= NinExpNeed
					Nin += rand(1,9)
				if(GenExp > GenExpNeed)
					GenExp -= GenExpNeed
					Gen += rand(1,9)
			AddExp(kind)
				if(kind == "Tai")
					if(Tai <= TaiCap)
						TaiExp += rand(20,60)
					else if(Speciality == "Tai")
						TaiExp += rand(10,40)
					else
						TaiExp += rand(20,50)
				if(kind == "Nin")
					if(Nin <= NinCap)
						NinExp += rand(20,60)
					else if(Speciality == "Nin")
						NinExp += rand(10,40)
					else
						TaiExp += rand(20,50)
				if(kind == "Gen")
					if(Gen <= GenCap)
						GenExp += rand(20,60)
					else if(Speciality == "Gen")
						GenExp += rand(10,40)
					else
						TaiExp += rand(20,50)


			AddChakraCC()
				var/random = rand(1,30)
				if(random == 5 && usr:ChakraControl <100)
					usr:ChakraControl++
				if(random == 5 || random == 7)
					usr:MaxChakra += rand(1,5)
					usr << "Your chakra increased!"

			DrainChakra(loss)
				if(ChakraControl == 100)
					Chakra -= loss
					return 1
				else
					var/random = rand(1,100-ChakraControl)
					var/drain = loss
					if(random != 1)
						while(drain == loss || drain < 0)
							drain = rand(loss-round((100-ChakraControl)/4),loss+round((100-ChakraControl)/4))
					src.Chakra -= drain
					if(drain<loss)
						usr << "<font size='1' color='gray'>Your justsu failed \[[drain]/[loss]\]</font>"
						return 0
					else
						usr << "<font size='1' color='gray'>Success! \[[drain]/[loss]\]</font>"
						return 1