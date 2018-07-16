import numpy as np
import sys
import os
n = int(sys.argv[1])
a = np.random.randint(1, 10, (n,n), dtype=np.uint16)
a_sp = np.split(a,n)
b = np.random.randint(1, 10, (n,1), dtype=np.uint16)
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

if not os.path.exists("./mv_test"):
    os.mkdir ("./mv_test" , 0755);

for i in range (0,n):
    np.savetxt('./mv_test/mat_a_r%d.hex' % (i), a_sp[i], delimiter='\n', fmt='%x')

np.savetxt('./mv_test/vec_b.hex', b, delimiter='\n', fmt='%x')

np.savetxt('./mv_test/res_c.hex', c, delimiter='\n', fmt='%x')
