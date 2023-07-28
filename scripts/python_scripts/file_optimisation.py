# Python
# File optimisation script
import sys


# == File optimisation ==
# Optimized Collect file
# Return packet of 32 bits integer in HEXA
def file_optimisation(file_in, file_out):

    # == Init Variables ==
    input_file_length = 0
    lines             = []
    return_list       = []
    tmp_line_len      = 0
    
    f = open(file_in, "r") # Open in read only
    lines = f.readlines()  # Get All lines in files
    f.close()              # Close File

    input_file_length = len(lines) # Get Number of line from file

    print("Input File length - %s : %d" %(file_in, input_file_length))
    
    for line_i in range(0, len(lines)):
        lines[line_i] = lines[line_i].strip() #Remove \n


    # List with unique value and the moment a they appears
    lines_opti       = [] # 
    lines_opti_index = [] # Line Number of the Unique line
    cnt_tmp          = 0
    previous_line    = lines[0]
    
    # Loop for each Lines
    for line_i in range(0, len(lines)):

        if(lines[line_i] == previous_line):
            cnt_tmp += 1

            # # Manage Last lines
            if(line_i == len(lines) - 1):
                lines_opti.append(previous_line)
                lines_opti_index.append(cnt_tmp)
            
        else:
            if(cnt_tmp == 0):
                cnt_tmp = 1
                
            lines_opti.append(previous_line)
            lines_opti_index.append(cnt_tmp)
            cnt_tmp = 1 # RAZ Counter
            previous_line = lines[line_i] # Update previous
            
        
    # Pad with "0" in order to have 32 bits bit packets
    tmp_line_len      = len(lines_opti[0])
    nb_entire_32b_pkt = tmp_line_len / 8
    pkt_remain        = tmp_line_len % 8 # a value [0:7]
    nb_pkt_32b        = nb_entire_32b_pkt
    if(pkt_remain != 0):
        nb_pkt_32b += 1

    
    nb_0_to_add = 8 - pkt_remain
    
        
    print("nb_pkt_32b : %d - pkt_remain : %d - nb_0_to_add : %d" %(nb_pkt_32b, pkt_remain, nb_0_to_add))
    

    data_out = []
    for line in range(0, len(lines_opti)):
        # Add extra 0 if needed
        lines_opti[line] = "0"*nb_0_to_add + lines_opti[line]
        data_out.append("{0} {1:08X}".format(lines_opti[line], (lines_opti_index[line]))) # Create output List to write in file
        return_list.append([lines_opti[line], lines_opti_index[line]])              # Returned List

    data_out_to_file = "\n".join(data_out)
    
    f = open(file_out, "w")
    f.write(data_out_to_file)
    f.close()

    # Print Info
    print("Output File - %s : %d" %(file_out, len(data_out_to_file)))
    print("file_optimisation Done.")

    return return_list

# Re Construct File from file_optimisation
def file_optimisation_inv(data_in, file_out):
    print("data_in infos: ")
    print("len(data_in) : %d" %(len(data_in)))
    
    line_index = 0
    data_out = []

    data_value = 0
    previous_data_value = 0
    
    curr_line_index    = 0
    somme_index = 0
    for i in range(0, len(data_in)):

        #print("data_value : %s" %(data_value))
        data_value   = data_in[i][0] # Get data_value
        curr_line_nb = data_in[i][1]
        somme_index = somme_index + curr_line_nb
        for j in range(0, curr_line_nb):
            data_out.append(data_value)
        
    print("somme_index : %d" %(somme_index))
    data_out_to_file = "\n".join(data_out)
    f = open(sys.argv[3], "w")
    f.write(data_out_to_file)
    f.close()
        
    
    print("Output File - %s : %d" %(sys.argv[3], len(data_out)))
    print("file_optimisation_inv Done.")
    
print(sys.argv)
# == Run File Optimisation ==
data_out_file = file_optimisation(sys.argv[1], sys.argv[2])

if(len(sys.argv) > 3):
    file_optimisation_inv(data_out_file, sys.argv[3])
