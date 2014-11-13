build:
	fig build

shell:
	fig run env

describe:
	fig run env cat /tmp/installed.txt
