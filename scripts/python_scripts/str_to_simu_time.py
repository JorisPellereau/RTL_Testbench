import sys
import os
import subprocess

#print(sys.argv[1])


def str_to_simu_time(str_in, unity = "ns"):

    value = 0

    simu_time_list = []
    # Split str

    str_in = str_in.split("\n") # Get a list without \n

    for simu_time in str_in:
        simu_time_list.append(simu_time.split(" ")) # Extract simu time and unity

    
    for simu_and_time in simu_time_list:
        if(simu_and_time[1] == unity):
            value += int(simu_and_time[0])

        # Unity different from extected unity
        else:
            print("Error: current_unity : %s different from expected unity : %s" %(simu_and_time[1], unity))
            
    value_unity = str(value)+unity
    return (value_unity)


(value_unity) = str_to_simu_time(sys.argv[1])

print("%s" %(value_unity))
#subprocess.call(["export", "simu_time=" + value_unity])
