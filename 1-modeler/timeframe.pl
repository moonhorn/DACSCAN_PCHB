# Automated Timeframe Generation

my $SI = "SI";
my $TF = "1";
my $ENL = "3";
my $Ftype = "SAF";
my @CUT=<inputs/*.v>;
# Read in parameter
foreach( @ARGV )
{
    if( $_ =~ /-NOSI/ )
	{
        $SI = "NOSI";
    }
	elsif( $_ =~ /s/ )
	{
		@CUT=<inputs/*.v>;
    }
	elsif( $_ =~ /-TDF/ )
	{
		$Ftype = "TDF";
	}
    elsif( $_ =~ /-remove/ )
    {
        `rm -rf ../0-result/`;
    }
	elsif( $_ =~ /-ENL/ )
    {
        $_ =~ s/-ENL//g;
		$ENL = $_;
    }
	elsif( $_ =~ /-TF/ )
    {
        $_ =~ s/-TF//g;
		$TF = $_;
    }
	else
    {
        $TF = $_;
    }
}
# System Message
if( $Ftype !~ "SAF" )
{
	print "##### Fault Type: TDF\n";
}
else
{
	print "##### Fault Type: SAF\n";
}
if( $SI !~ "NOSI" ){
	print "##### Scan Isolator: ON\n";
}
else
{
	print "##### Scan Isolator: OFF\n";
}
my $TFE = int($ENL)*int($TF);
print "##### Timeframe = ".$TF." * ".$ENL." = ".$TFE." \n";

# Establish directory
`mkdir ../library_delay_expand$TFE`;
`mkdir ../0-result/`;
`mkdir ../0-result/modNetlist/`;
`mkdir ../0-result/modNetlist/STR/`;
`mkdir ../0-result/modNetlist/STF/`;
`mkdir ../0-result/modFaultlist/`;
`mkdir ../0-result/modFaultlist/STR/`;
`mkdir ../0-result/modFaultlist/STF/`;

	`make`;
    `./bin/Timeframe 2 $Ftype $TFE $ENL inputs/MODEL_BASE ../library_delay_expand$TFE/dims_lib_model_delay_stf.v ../library_delay_expand$TFE/dims_lib_model_delay_str.v ../library_delay_expand$TFE/pchb_lib_model_expand.v`;
    `cp ../original_library/NangateOpenCellLibrary.v ../library_delay_expand$TFE`;
	foreach(@CUT)
    {
        chomp $_;
        @temp = split('/',$_);
        @temp = split(/.v/, $temp[1]);
        my $netlist = $temp[0].".v";
        my $modNetlistSTF = $temp[0]."_PCHB_mod_stf.v";
        my $modNetlistSTR = $temp[0]."_PCHB_mod_str.v";
		my $modFaultlistSTF = $temp[0]."_PCHB_mod_stf.fl";
		my $modFaultlistSTR = $temp[0]."_PCHB_mod_str.fl";
		print "netlist = ".$netlist."\n";
        `./bin/Timeframe 3 $SI $Ftype $TF $ENL inputs/$netlist ../0-result/modNetlist/STF/$modNetlistSTF ../0-result/modNetlist/STR/$modNetlistSTR ../0-result/modFaultlist/STF/$modFaultlistSTF ../0-result/modFaultlist/STR/$modFaultlistSTR`;
    }

