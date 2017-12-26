###################  Create directory  #####################
`mkdir ../0-result/ISCAS/tmax`;
`mkdir ../0-result/ISCAS/tmax/DT`;
`mkdir ../0-result/ISCAS/tmax/PT`;
`mkdir ../0-result/ISCAS/tmax/UD`;
`mkdir ../0-result/ISCAS/tmax/AU`;
`mkdir ../0-result/ISCAS/tmax/ND`;
`mkdir ../0-result/ISCAS/tmax/LOG`;

`mkdir ../0-result/ISCAS/tmax/DT/STR`;
`mkdir ../0-result/ISCAS/tmax/DT/STF`;
`mkdir ../0-result/ISCAS/tmax/PT/STR`;
`mkdir ../0-result/ISCAS/tmax/PT/STF`;
`mkdir ../0-result/ISCAS/tmax/UD/STR`;
`mkdir ../0-result/ISCAS/tmax/UD/STF`;
`mkdir ../0-result/ISCAS/tmax/AU/STR`;
`mkdir ../0-result/ISCAS/tmax/AU/STF`;
`mkdir ../0-result/ISCAS/tmax/ND/STR`;
`mkdir ../0-result/ISCAS/tmax/ND/STF`;
`mkdir ../0-result/ISCAS/tmax/LOG/STR`;
`mkdir ../0-result/ISCAS/tmax/LOG/STF`;

my $TF = "2";
my $bench = "";
foreach( @ARGV )
{
    if( $_ =~ /dims/ )
    {
        $bench = $_;
        print "##### Run : $bench\n";
    }
    else {
        $TF = $_;
    }
}

if( $bench !=~ "dims" )
{
    print "##### Run : All\n";
}
print "##### Time Frame   : ".$TF."\n";

######################  Read lib  #####################
$STR_LIB = "";
$STF_LIB = "";
$MODEL_LIB = "";

@LIBRARY = <../library_delay_expand$TF/*.v>;
foreach(@LIBRARY)
{
    chomp $_;
    if($_ =~ /str/)
    {
        $STR_LIB = $_;
    }
    if($_ =~ /stf/)
    {
        $STF_LIB = $_;
    }
    if($_ =~ /lib_model_expand/)
    {
        $MODEL_LIB = $_;
    }
}

    ###########  Read netlist and faultlist and run ATPG  ########
    ######  Start with STR  ######
    @ISCAS = <../0-result/ISCAS/modNetlist/STR/$bench*.v>;
    @FAULTLIST = <../0-result/ISCAS/modFaultlist/STR/$bench*.fl>;

    for(my $i=0;$i<@ISCAS;$i++)
    {
        my $fault = $FAULTLIST[$i];
        my $cir_path = $ISCAS[$i];
        @temp = split('/', $cir_path);
        @temp = split(/_mod/, $temp[5]);
        my $netlist = $temp[0];
        @temp = split('\.', $temp[1]);
        print $netlist.$temp[0]."\n";
        my $dt_path = "../0-result/ISCAS/tmax/DT/STR/".$netlist.$temp[0].".dt";
        my $pt_path = "../0-result/ISCAS/tmax/PT/STR/".$netlist.$temp[0].".pt";
        my $ud_path = "../0-result/ISCAS/tmax/UD/STR/".$netlist.$temp[0].".ud";
        my $au_path = "../0-result/ISCAS/tmax/AU/STR/".$netlist.$temp[0].".au";
        my $nd_path = "../0-result/ISCAS/tmax/ND/STR/".$netlist.$temp[0].".nd";
        my $log_path = "../0-result/ISCAS/tmax/LOG/STR/".$netlist.$temp[0].".log";

        open(FIN, " < tmax.tcl") or die "Can't read tmax.script";
        open(FOUT, " > tmax_copy3.tcl") or die " Can't write tmax_copy3.script";
        while(<FIN>)
        {
            if($_ =~ /search/)
            {
                $_ = "set PATH ".$cir_path."\n";
            }
            if($_ =~ /circuit/)
            {
                $_ = "set DESIGN ".$netlist."\n";
            }
            if($_ =~ /simple_lib/)
            {
                $_ = "set LIBRARY_SIMPLE ".$STR_LIB."\n";
            }
            if($_ =~ /model_lib/)
            {
                $_ = "set LIBRARY_MODEL ".$MODEL_LIB."\n";
            }
            if($_ =~ /faultlist/)
            {
                $_ = "set FAULT ".$fault."\n";
            }
            if($_ =~ /output_dt/)
            {
                $_ = "set DT ".$dt_path."\n";
            }
            if($_ =~ /output_pt/)
            {
                $_ = "set PT ".$pt_path."\n";
            }
            if($_ =~ /output_ud/)
            {
                $_ = "set UD ".$ud_path."\n";
            }
            if($_ =~ /output_au/)
            {
                $_ = "set AU ".$au_path."\n";
            }
            if($_ =~ /output_nd/)
            {
                $_ = "set ND ".$nd_path."\n";
            }
            print FOUT $_;

        }
        close(FIN);
        close(FOUT);
        `tmax -64 -s -nogui -tcl tmax_copy3.tcl > $log_path`;
    }

    ######  Then STF  ######
    @ISCAS = <../0-result/ISCAS/modNetlist/STF/$bench*.v>;
    @FAULTLIST = <../0-result/ISCAS/modFaultlist/STF/$bench*.fl>;

    for(my $i=0;$i<@ISCAS;$i++)
    {
        my $fault = $FAULTLIST[$i];
        my $cir_path = $ISCAS[$i];
        @temp = split('/', $cir_path);
        @temp = split(/_mod/, $temp[5]);
        my $netlist = $temp[0];
        @temp = split('\.', $temp[1]);
        print $netlist.$temp[0]."\n";
        my $dt_path = "../0-result/ISCAS/tmax/DT/STF/".$netlist.$temp[0].".dt";
        my $pt_path = "../0-result/ISCAS/tmax/PT/STF/".$netlist.$temp[0].".pt";
        my $ud_path = "../0-result/ISCAS/tmax/UD/STF/".$netlist.$temp[0].".ud";
        my $au_path = "../0-result/ISCAS/tmax/AU/STF/".$netlist.$temp[0].".au";
        my $nd_path = "../0-result/ISCAS/tmax/ND/STF/".$netlist.$temp[0].".nd";
        my $log_path = "../0-result/ISCAS/tmax/LOG/STF/".$netlist.$temp[0].".log";

        open(FIN, " < tmax.tcl") or die "Can't read tmax.script";
        open(FOUT, " > tmax_copy3.tcl") or die " Can't write tmax_copy3.script";
        while(<FIN>)
        {
            if($_ =~ /search/)
            {
                $_ = "set PATH ".$cir_path."\n";
            }
            if($_ =~ /circuit/)
            {
                $_ = "set DESIGN ".$netlist."\n";
            }
            if($_ =~ /simple_lib/)
            {
                $_ = "set LIBRARY_SIMPLE ".$STF_LIB."\n";
            }
            if($_ =~ /model_lib/)
            {
                $_ = "set LIBRARY_MODEL ".$MODEL_LIB."\n";
            }
            if($_ =~ /faultlist/)
            {
                $_ = "set FAULT ".$fault."\n";
            }
            if($_ =~ /output_dt/)
            {
                $_ = "set DT ".$dt_path."\n";
            }
            if($_ =~ /output_pt/)
            {
                $_ = "set PT ".$pt_path."\n";
            }
            if($_ =~ /output_ud/)
            {
                $_ = "set UD ".$ud_path."\n";
            }
            if($_ =~ /output_au/)
            {
                $_ = "set AU ".$au_path."\n";
            }
            if($_ =~ /output_nd/)
            {
                $_ = "set ND ".$nd_path."\n";
            }
            print FOUT $_;

        }
        close(FIN);
        close(FOUT);
        `tmax -64 -s -nogui -tcl tmax_copy3.tcl > $log_path`;
    }

`rm tmax_copy3.tcl`;
