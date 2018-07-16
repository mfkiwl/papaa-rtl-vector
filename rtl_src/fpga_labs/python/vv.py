import numpy as np
import sys
import os
n = int(sys.argv[1])
a = np.random.randint(1, 10, (1,n), dtype=np.uint16)
b = np.random.randint(1, 10, (n,1), dtype=np.uint16)
c = np.matmul(a,b)
print("vector a")
print(a)
print("\n ============ \n")
print("vector b")
print(b)
print("\n ============ \n")
print("result")
print(c)
print("\n ============ \n")

if not os.path.exists("./vv_test"):
    os.mkdir ("./vv_test" , 0755);

np.savetxt('./vv_test/vec_a.hex', a, delimiter='\n', fmt='%x')

np.savetxt('./vv_test/vec_b.hex', b, delimiter='\n', fmt='%x')

np.savetxt('./vv_test/res_c.hex', c, delimiter='\n', fmt='%x')
