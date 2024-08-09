my %temp;
while (<>) {
	if (/^text:(\S+)/ && !defined($temp{$1})) {
		$temp{$1} = 1;
		print;
	}
}
