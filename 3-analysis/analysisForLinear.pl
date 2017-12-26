`mkdir ../0-result/Linear/analysis`;
`mkdir ../0-result/Linear/analysis/DT`;
`mkdir ../0-result/Linear/analysis/UD`;
`mkdir ../0-result/Linear/analysis/ND`;
`mkdir ../0-result/Linear/analysis/FC`;

    my $TF = "TF2";
    my $bench = "";
    foreach( @ARGV )
    {
        if( $_ =~ /dims/ )
        {
            $bench = $_;
            print "##### Run : $bench\n";
        }
        else {
            $TF = "TF".$_;
        }
    }

    if( $bench !=~ "dims" )
    {
        print "##### Run : All\n";
    }
    print "##### Time Frame   : ".$TF."\n";


    @STR_DT  = <../0-result/Linear/tmax/DT/STR/$bench*.dt>;
    @STF_DT  = <../0-result/Linear/tmax/DT/STF/$bench*.dt>;
    @STR_UD  = <../0-result/Linear/tmax/UD/STR/$bench*.ud>;
    @STF_UD  = <../0-result/Linear/tmax/UD/STF/$bench*.ud>;
    @STR_AU  = <../0-result/Linear/tmax/AU/STR/$bench*.au>;
    @STF_AU  = <../0-result/Linear/tmax/AU/STF/$bench*.au>;
    @STR_ND  = <../0-result/Linear/tmax/ND/STR/$bench*.nd>;
    @STF_ND  = <../0-result/Linear/tmax/ND/STF/$bench*.nd>;
    @STR_LOG = <../0-result/Linear/tmax/LOG/STR/$bench*.log>;
    @STF_LOG = <../0-result/Linear/tmax/LOG/STF/$bench*.log>;

    for(my $i=0;$i<@STR_DT;$i++)
    {  
        @temp = split('/', $STR_DT[$i]);
        @temp = split(/_str/, $temp[6]);
        my $netlist = $temp[0];
        print $netlist."\n";
        open( str_dt, "<".$STR_DT[$i] ) or die "Can't open ".$STR_DT[$i];
        open( stf_dt, "<".$STF_DT[$i] ) or die "Can't open ".$STF_DT[$i];

        open( str_ud, "<".$STR_UD[$i] ) or die "Can't open ".$STR_UD[$i];
        open( stf_ud, "<".$STF_UD[$i] ) or die "Can't open ".$STF_UD[$i];

        open( str_au, "<".$STR_AU[$i] ) or die "Can't open ".$STR_AU[$i];
        open( stf_au, "<".$STF_AU[$i] ) or die "Can't open ".$STF_AU[$i];
        
        open( str_nd, "<".$STR_ND[$i] ) or die "Can't open ".$STR_ND[$i];
        open( stf_nd, "<".$STF_ND[$i] ) or die "Can't open ".$STF_ND[$i];

        open( str_log, "<".$STR_LOG[$i] ) or die "Can't open ".$STR_LOG[$i];
        open( stf_log, "<".$STF_LOG[$i] ) or die "Can't open ".$STF_LOG[$i];

        # Count total faults and run time from log file
        $totalFault = 0;
        $runTime = 0.0;
        while(<str_log>)
        {
            chmod $_;
            if($_ =~ /total\ faults/)
            {
                @temp = split(' ', $_);
                $totalFault = $totalFault + $temp[2];
            }
            if($_ =~ /Total\ CPU\ time/)
            {
                @temp = split(' ', $_);
                $runTime = $runTime + $temp[3];
                last;
            }
        }
        while(<stf_log>)
        {
            chmod $_;
            if($_ =~ /total\ faults/)
            {
                @temp = split(' ', $_);
                $totalFault = $totalFault + $temp[2];
            }
            if($_ =~ /Total\ CPU\ time/)
            {
                @temp = split(' ', $_);
                $runTime = $runTime + $temp[3];
                last;
            }
        }
        #$totalFault = $totalFault / 2;
        #print $totalFault;


        open( FOUT_DT, "> ../0-result/Linear/analysis/DT/".$netlist."_".$TF.".dt") or die "Can't write total.dt";
        open( FOUT_UD, "> ../0-result/Linear/analysis/UD/".$netlist."_".$TF.".ud") or die "Can't write total.ud";
        open( FOUT_ND, "> ../0-result/Linear/analysis/ND/".$netlist."_".$TF.".nd") or die "Can't write total.nd";
        open( FOUT_FC, "> ../0-result/Linear/analysis/FC/".$netlist."_".$TF.".fc") or die "Can't write total.fc";

        # total fault, here only sum DT, UD, AU, and ND (AU is classified to ND)
        @total_str_fault = ();
        @str_V_dt = ();
        @str_V_ud = ();
        @str_V_nd = ();
        while(<str_dt>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@total_str_fault, $temp[2]);
            push(@str_V_dt, $temp[2]);
        }
        while(<str_ud>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@total_str_fault, $temp[2]);
            push(@str_V_ud, $temp[2]);
        }
        while(<str_au>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@total_str_fault, $temp[2]);
            push(@str_V_nd, $temp[2]);
        }
        while(<str_nd>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@total_str_fault, $temp[2]);
            push(@str_V_nd, $temp[2]);
        }
        @total_stf_fault = @total_str_fault;

        @str_E_dt = ();
        @stf_V_dt = ();
        @stf_E_dt = ();
        @str_E_ud = ();
        @stf_V_ud = ();
        @stf_E_ud = ();
        @str_E_nd = ();
        @stf_V_nd = ();
        @stf_E_nd = ();

        ### For DT
        while(<stf_dt>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@stf_V_dt, $temp[2]);
        }

        ### For UD
        while(<stf_ud>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@stf_V_ud, $temp[2]);
        }
        
        ### For AU
        ### AU is classified to ND
        while(<stf_au>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@stf_V_nd, $temp[2]);
        }
        
        ### For ND
        while(<stf_nd>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@stf_V_nd, $temp[2]);
        }

        @total_str_dt = ();
        @total_stf_dt = ();
        @total_str_ud = ();
        @total_stf_ud = ();
        @total_str_nd = ();
        @total_stf_nd = ();

        foreach(@total_str_fault)
        {
            if($_ ~~ @str_V_dt)
            {
                push(@total_str_dt, $_);
                next;
            }
            if($_ ~~ @str_E_dt)
            {
                push(@total_str_dt, $_);
                next;
            }
            if($_ ~~ @str_V_ud)
            {
                if($_ ~~ @str_E_ud)
                {
                    push(@total_str_ud, $_);
                    next;
                }
            }
            push(@total_str_nd, $_);
        }

        foreach(@total_stf_fault)
        {
            if($_ ~~ @stf_V_dt)
            {
                push(@total_stf_dt, $_);
                next;
            }
            if($_ ~~ @stf_E_dt)
            {
                push(@total_stf_dt, $_);
                next;
            }
            if($_ ~~ @stf_V_ud)
            {
                if($_ ~~ @stf_E_ud)
                {
                    push(@total_stf_ud, $_);
                    next;
                }
            }
            push(@total_stf_nd, $_);
        }
        # Print out the result
        for(my $j=0;$j<@total_str_dt;$j++)
        {
            print FOUT_DT "str ".$total_sa0_dt[$j]."\n";
        }
        for(my $j=0;$j<@total_stf_dt;$j++)
        {
            print FOUT_DT "stf ".$total_sa1_dt[$j]."\n";
        }
        for(my $j=0;$j<@total_str_ud;$j++)
        {
            print FOUT_UD "str ".$total_sa0_ud[$j]."\n";
        }
        for(my $j=0;$j<@total_stf_ud;$j++)
        {
            print FOUT_UD "stf ".$total_sa1_ud[$j]."\n";
        }
        for(my $j=0;$j<@total_str_nd;$j++)
        {
            print FOUT_ND "str ".$total_sa0_nd[$j]."\n";
        }
        for(my $j=0;$j<@total_stf_nd;$j++)
        {
            print FOUT_ND "stf ".$total_sa1_nd[$j]."\n";
        }

        print FOUT_FC "Total fault        = ". $totalFault."\n";
        print FOUT_FC "Detected fault     = ". (@total_str_dt+@total_stf_dt)."\n";
        print FOUT_FC "Untestable fault   = ". (@total_str_ud+@total_stf_ud). "\n";
        print FOUT_FC "Undetectable fault = ". (@total_str_nd+@total_stf_nd). "\n";
        print FOUT_FC "Fault coverage     = ". (@total_str_dt+@total_stf_dt) / ($totalFault) * 100 . "%\n";
        print FOUT_FC "Test coverage      = ". (@total_str_dt+@total_stf_dt)/ ( $totalFault-@total_sa0_ud-@total_sa1_ud  ) * 100 ."%\n";
        print FOUT_FC "ATPG runtime       = ".$runTime." s\n";

        close(str_dt);
        close(stf_dt);

        close(str_ud);
        close(stf_ud);

        close(str_au);
        close(stf_au);
        
        close(str_nd);
        close(stf_nd);

        close(str_log);
        close(stf_log);

        close(FOUT_DT);
        close(FOUT_UD);
        close(FOUT_ND);
        close(FOUT_FC);
    }
