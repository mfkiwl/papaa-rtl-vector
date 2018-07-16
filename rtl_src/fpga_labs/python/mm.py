import numpy as np
import sys
import os
n = int(sys.argv[1])
a = np.random.randint(1, 10, (n,n), dtype=np.uint16)
a_sp = np.split(a,n)
b = np.random.randint(1, 10, (n,n), dtype=np.uint16)
b_sp = np.split(b,n,axis=1)
c = np.matmul(a,b)
c_sp = np.split(c,n,axis=1)
print("matrix a")
print(a)
print("\n ============ \n")
print("matrix b")
print(b)
print("\n ============ \n")
print("result")
print(c)
print("\n ============ \n")

if not os.path.exists("./mm_test"):
    os.mkdir ("./mm_test" , 0755);

for i in range (0,n):
    np.savetxt('./mm_test/mat_a_r%d.hex' % (i), a_sp[i], delimiter='\n', fmt='%x')

for i in range (0,n):
    np.savetxt('./mm_test/mat_b_c%d.hex' % (i), b_sp[i], delimiter='\n', fmt='%x')

for i in range (0,n):
    np.savetxt('./mm_test/res_c%d.hex' % (i), c_sp[i], delimiter='\n', fmt='%x')
