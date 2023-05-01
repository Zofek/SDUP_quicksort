## Lomuto partition scheme

#--------------------------------------------
def quicksort(arr_in, lo, hi):
    print("quicksort")
    # Ensure indices are in correct order
    if lo >= hi or lo < 0:
        return #nie wykonujemy partition
    
    # Partition array and get the pivot index
    p = partition(arr_in, lo, hi) 
      
    # Sort the two partitions
    quicksort(arr_in, lo, p - 1) # Left side of pivot
    quicksort(arr_in, p + 1, hi) # Right side of pivot
#--------------------------------------------
def partition(arr_in, lo, hi):

    print("part")  

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
#arr = [3,4,1,6,8,9,3]
arr = [0,3,0,4]
arr2 = [1,3,3,3]
ind_lo = 0
ind_hi = len(arr) - 1
a = quicksort(arr, ind_lo, ind_hi)
print(arr)