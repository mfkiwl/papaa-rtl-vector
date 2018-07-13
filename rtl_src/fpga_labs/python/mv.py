import numpy as np
import sys
import os
n = int(sys.argv[1])
a = np.random.randint(1, 10, (n,n), dtype=np.uint8)
a_sp = np.split(a,n)
b = np.random.randint(1, 10, (n,1), dtype=np.uint8)
c = np.matmul(a,b)
print("matrix a")
print(a)
print("\n ============ \n")
print("vector b")
print(b)
print("\n ============ \n")
print("result")
print(c)
print("\n ============ \n")

if not os.path.exists("./mv_test_%d" % (n)):
    os.mkdir ("./mv_test_%d" % (n) , 0755);

for i in range (0,n):
    np.savetxt('./mv_test_%d/mat_a_r%d.hex' % (n,i), a_sp[i], delimiter='\n', fmt='%u')

np.savetxt('./mv_test_%d/vec_b.hex' % (n), b, delimiter='\n', fmt='%u')

np.savetxt('./mv_test_%d/res_c.hex' % (n), c, delimiter='\n', fmt='%u')
