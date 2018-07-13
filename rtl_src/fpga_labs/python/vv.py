import numpy as np
import sys
import os
n = int(sys.argv[1])
a = np.random.randint(1, 10, (1,n), dtype=np.uint8)
b = np.random.randint(1, 10, (n,1), dtype=np.uint8)
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

if not os.path.exists("./vv_test_%d" % (n)):
    os.mkdir ("./vv_test_%d" % (n) , 0755);

np.savetxt('./vv_test_%d/vec_a.hex' % (n), a, delimiter='\n', fmt='%u')

np.savetxt('./vv_test_%d/vec_b.hex' % (n), b, delimiter='\n', fmt='%u')

np.savetxt('./vv_test_%d/res_c.hex' % (n), c, delimiter='\n', fmt='%u')
