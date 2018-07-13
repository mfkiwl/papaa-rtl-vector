import numpy as np
import sys
import os
n = int(sys.argv[1])
a = np.random.randint(1, 10, (n,n), dtype=np.uint8)
a_sp = np.split(a,n)
b = np.random.randint(1, 10, (n,n), dtype=np.uint8)
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

if not os.path.exists("./mm_test_%d" % (n)):
    os.mkdir ("./mm_test_%d" % (n) , 0755);

for i in range (0,n):
    np.savetxt('./mm_test_%d/mat_a_r%d.hex' % (n,i), a_sp[i], delimiter='\n', fmt='%x')

for i in range (0,n):
    np.savetxt('./mm_test_%d/mat_b_c%d.hex' % (n,i), b_sp[i], delimiter='\n', fmt='%x')

for i in range (0,n):
    np.savetxt('./mm_test_%d/res_c%d.hex' % (n,i), c_sp[i], delimiter='\n', fmt='%x')
