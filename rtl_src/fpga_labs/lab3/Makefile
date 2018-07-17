diff:
	for number in `seq 1 9` ; do \
		if diff --ignore-all-space "../python/mm_test/res_c$$number.hex" "../python/mm_test/sim_res_c$$number.hex" >/dev/null; then\
			echo "**** PASS ****";\
		else\
			echo "**** FAIL ****";\
		fi ; \
	done

hw:
	vivado -mode tcl -s matrix_mult.tcl
