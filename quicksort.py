import numpy as np
## Lomuto partition scheme

#--------------------------------------------
def quicksort(arr_in, lo, hi):

    # Ensure indices are in correct order
    if lo >= hi or lo < 0:
        return #we are not calling partition()
    
    # Partition array and get the pivot index
    p = partition(arr_in, lo, hi) 
      
    # Sort the two partitions
    quicksort(arr_in, lo, p - 1) # Left side of pivot
    quicksort(arr_in, p + 1, hi) # Right side of pivot
#--------------------------------------------
def partition(arr_in, lo, hi):

    #.append("part")

    pivot = arr_in[hi] # Choose the last element as the pivot
    i = lo - 1 # Temporary pivot index

    for j in range(lo, hi):
        # If the current element is less than or equal to the pivot
        if arr_in[j] <= pivot:
            # Move the temporary pivot index forward
            i += 1
            # Swap the current element with the element at the temporary pivot index
            arr_in[i], arr_in[j] = arr_in[j], arr_in[i]

    # Move the pivot element to the correct pivot position (between the smaller and larger elements)
    i += 1
    arr_in[i], arr_in[hi] = arr_in[hi], arr_in[i]
    return i # the pivot index

#--------------------------------------------
arr = [3,7,8,5,2,1,9,5,4]
ind_lo = 0
ind_hi = len(arr) - 1
b = quicksort(arr, ind_lo, ind_hi)
'''
arr = [3,4,9,3,8,1,2,5,7,9,5,3,6,9,5]
arr2 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
arr3 = np.array(15*[0])
arr4 = [14,7,6,9,4,1,10,6,12,0,0,0,5,11,9]

l = list()
ind_lo = 0
ind_hi = len(arr) - 1
b = quicksort(arr, ind_lo, ind_hi)
print(len(l))
l = list()
b = quicksort(arr2, ind_lo, ind_hi)
print(len(l))
l = list()
b = quicksort(arr3, ind_lo, ind_hi)
print(len(l))
l = list()
b = quicksort(arr4, ind_lo, ind_hi)
print(len(l))'''