# Automated PCHB Generation

my @CUT=<inputs/*.v>;
foreach( @ARGV )
{
	@CUT =<inputs/$_.v>;
}

`mkdir outputs`;

    `make`;
    foreach(@CUT)
    {
        chomp $_;
        @temp = split('/',$_);
        @temp = split(/.v/, $temp[1]);
        print $temp[0]."\n";
        my $netlist = $temp[0].".v";
        my $modNetlist = $temp[0]."_PCHB.v";
        #print "netlist = ".$netlist."\n";
        #print "modNetlist = ".$modNetlist."\n";
        #print "modFaultlist = ".$modFaultlist."\n";
        `./bin/Timeframe 1 inputs/$netlist outputs/$modNetlist`;
    }
