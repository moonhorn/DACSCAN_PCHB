`mkdir ../0-result/ISCAS/analysis`;
`mkdir ../0-result/ISCAS/analysis/DT`;
`mkdir ../0-result/ISCAS/analysis/UD`;
`mkdir ../0-result/ISCAS/analysis/ND`;
`mkdir ../0-result/ISCAS/analysis/FC`;

if(!$ARGV[0])
{
    @SA0_BEGV_DT  = <../0-result/ISCAS/tmax/DT/SA0/BEGV/s38417*.dt>;
    @SA0_BEGE_DT  = <../0-result/ISCAS/tmax/DT/SA0/BEGE/s38417*.dt>;
    @SA1_BEGV_DT  = <../0-result/ISCAS/tmax/DT/SA1/BEGV/s38417*.dt>;
    @SA1_BEGE_DT  = <../0-result/ISCAS/tmax/DT/SA1/BEGE/s38417*.dt>;
    @SA0_BEGV_UD  = <../0-result/ISCAS/tmax/UD/SA0/BEGV/s38417*.ud>;
    @SA0_BEGE_UD  = <../0-result/ISCAS/tmax/UD/SA0/BEGE/s38417*.ud>;
    @SA1_BEGV_UD  = <../0-result/ISCAS/tmax/UD/SA1/BEGV/s38417*.ud>;
    @SA1_BEGE_UD  = <../0-result/ISCAS/tmax/UD/SA1/BEGE/s38417*.ud>;
    @SA0_BEGV_AU  = <../0-result/ISCAS/tmax/AU/SA0/BEGV/s38417*.au>;
    @SA0_BEGE_AU  = <../0-result/ISCAS/tmax/AU/SA0/BEGE/s38417*.au>;
    @SA1_BEGV_AU  = <../0-result/ISCAS/tmax/AU/SA1/BEGV/s38417*.au>;
    @SA1_BEGE_AU  = <../0-result/ISCAS/tmax/AU/SA1/BEGE/s38417*.au>;
    @SA0_BEGV_ND  = <../0-result/ISCAS/tmax/ND/SA0/BEGV/s38417*.nd>;
    @SA0_BEGE_ND  = <../0-result/ISCAS/tmax/ND/SA0/BEGE/s38417*.nd>;
    @SA1_BEGV_ND  = <../0-result/ISCAS/tmax/ND/SA1/BEGV/s38417*.nd>;
    @SA1_BEGE_ND  = <../0-result/ISCAS/tmax/ND/SA1/BEGE/s38417*.nd>;
    @SA0_BEGV_LOG = <../0-result/ISCAS/tmax/LOG/SA0/BEGV/s38417*.log>;
    @SA0_BEGE_LOG = <../0-result/ISCAS/tmax/LOG/SA0/BEGE/s38417*.log>;
    @SA1_BEGV_LOG = <../0-result/ISCAS/tmax/LOG/SA1/BEGV/s38417*.log>;
    @SA1_BEGE_LOG = <../0-result/ISCAS/tmax/LOG/SA1/BEGE/s38417*.log>;

    for(my $i=0;$i<@SA0_BEGV_DT;$i++)
    { 
        @temp = split('/', $SA0_BEGV_DT[$i]);
        @temp = split(/_sa0/, $temp[7]);
        my $netlist = $temp[0];
        print $netlist."\n";
        open( sa0_begV_dt, "<".$SA0_BEGV_DT[$i] ) or die "Can't open ".$SA0_BEGV_DT[$i];
        open( sa0_begE_dt, "<".$SA0_BEGE_DT[$i] ) or die "Can't open ".$SA0_BEGE_DT[$i];
        open( sa1_begV_dt, "<".$SA1_BEGV_DT[$i] ) or die "Can't open ".$SA1_BEGV_DT[$i];
        open( sa1_begE_dt, "<".$SA1_BEGE_DT[$i] ) or die "Can't open ".$SA1_BEGE_DT[$i];

        open( sa0_begV_ud, "<".$SA0_BEGV_UD[$i] ) or die "Can't open ".$SA0_BEGV_UD[$i];
        open( sa0_begE_ud, "<".$SA0_BEGE_UD[$i] ) or die "Can't open ".$SA0_BEGE_UD[$i];
        open( sa1_begV_ud, "<".$SA1_BEGV_UD[$i] ) or die "Can't open ".$SA1_BEGV_UD[$i];
        open( sa1_begE_ud, "<".$SA1_BEGE_UD[$i] ) or die "Can't open ".$SA1_BEGE_UD[$i];

        open( sa0_begV_au, "<".$SA0_BEGV_AU[$i] ) or die "Can't open ".$SA0_BEGV_AU[$i];
        open( sa0_begE_au, "<".$SA0_BEGE_AU[$i] ) or die "Can't open ".$SA0_BEGE_AU[$i];
        open( sa1_begV_au, "<".$SA1_BEGV_AU[$i] ) or die "Can't open ".$SA1_BEGV_AU[$i];
        open( sa1_begE_au, "<".$SA1_BEGE_AU[$i] ) or die "Can't open ".$SA1_BEGE_AU[$i];
        
        open( sa0_begV_nd, "<".$SA0_BEGV_ND[$i] ) or die "Can't open ".$SA0_BEGV_ND[$i];
        open( sa0_begE_nd, "<".$SA0_BEGE_ND[$i] ) or die "Can't open ".$SA0_BEGE_ND[$i];
        open( sa1_begV_nd, "<".$SA1_BEGV_ND[$i] ) or die "Can't open ".$SA1_BEGV_ND[$i];
        open( sa1_begE_nd, "<".$SA1_BEGE_ND[$i] ) or die "Can't open ".$SA1_BEGE_ND[$i];

        open( sa0_begV_log, "<".$SA0_BEGV_LOG[$i] ) or die "Can't open ".$SA0_BEGV_LOG[$i];
        open( sa0_begE_log, "<".$SA0_BEGE_LOG[$i] ) or die "Can't open ".$SA0_BEGE_LOG[$i];
        open( sa1_begV_log, "<".$SA1_BEGV_LOG[$i] ) or die "Can't open ".$SA1_BEGV_LOG[$i];
        open( sa1_begE_log, "<".$SA1_BEGE_LOG[$i] ) or die "Can't open ".$SA1_BEGE_LOG[$i];

        # Count total faults and run time from log file
        $totalFault = 0;
        $tempCount = 0;
        $runTime = 0.0;
        while(<sa0_begV_log>)
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
        print ($totalFault-$tempCount);
        print "\n";
        $tempCount = $totalFault;

        while(<sa0_begE_log>)
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
        print ($totalFault-$tempCount);
        print "\n";
        $tempCount = $totalFault;
        while(<sa1_begV_log>)
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
        print ($totalFault-$tempCount);
        print "\n";
        $tempCount = $totalFault;
        while(<sa1_begE_log>)
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
        print ($totalFault-$tempCount);
        print "\n";
        $tempCount = $totalFault;
        $totalFault = $totalFault / 2;


        open( FOUT_DT, "> ../0-result/ISCAS/analysis/DT/".$netlist."_total.dt") or die "Can't write total.dt";
        open( FOUT_UD, "> ../0-result/ISCAS/analysis/UD/".$netlist."_total.ud") or die "Can't write total.ud";
        open( FOUT_ND, "> ../0-result/ISCAS/analysis/ND/".$netlist."_total.nd") or die "Can't write total.nd";
        open( FOUT_FC, "> ../0-result/ISCAS/analysis/FC/".$netlist."_total.fc") or die "Can't write total.fc";

        # total fault, here only sum DT, UD, AU, and ND (AU is classified to ND)
        @total_sa0_fault = ();
        @sa0_V_dt = ();
        @sa0_V_ud = ();
        @sa0_V_nd = ();
        while(<sa0_begV_dt>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@total_sa0_fault, $temp[2]);
            push(@sa0_V_dt, $temp[2]);
        }
        while(<sa0_begV_ud>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@total_sa0_fault, $temp[2]);
            push(@sa0_V_ud, $temp[2]);
        }
        while(<sa0_begV_au>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@total_sa0_fault, $temp[2]);
            push(@sa0_V_nd, $temp[2]);
        }
        while(<sa0_begV_nd>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@total_sa0_fault, $temp[2]);
            push(@sa0_V_nd, $temp[2]);
        }
        @total_sa1_fault = @total_sa0_fault;

        @sa0_E_dt = ();
        @sa1_V_dt = ();
        @sa1_E_dt = ();
        @sa0_E_ud = ();
        @sa1_V_ud = ();
        @sa1_E_ud = ();
        @sa0_E_nd = ();
        @sa1_V_nd = ();
        @sa1_E_nd = ();

        ### For DT
        while(<sa0_begE_dt>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa0_E_dt, $temp[2]);
        }
        while(<sa1_begV_dt>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa1_V_dt, $temp[2]);
        }
        while(<sa1_begE_dt>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa1_E_dt, $temp[2]);
        }

        ### For UD
        while(<sa0_begE_ud>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa0_E_ud, $temp[2]);
        }
        while(<sa1_begV_ud>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa1_V_ud, $temp[2]);
        }
        while(<sa1_begE_ud>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa1_E_ud, $temp[2]);
        }

        ### For AU
        ### AU is classified to ND
        while(<sa0_begE_au>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa0_E_nd, $temp[2]);
        }
        while(<sa1_begV_au>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa1_V_nd, $temp[2]);
        }
        while(<sa1_begE_au>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa1_E_nd, $temp[2]);
        }
        ### For ND
        while(<sa0_begE_nd>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa0_E_nd, $temp[2]);
        }
        while(<sa1_begV_nd>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa1_V_nd, $temp[2]);
        }
        while(<sa1_begE_nd>)
        {
            if($_ =~ /Warning/)
            {
                next;
            }
            my @temp = split(' ', $_);
            push(@sa1_E_nd, $temp[2]);
        }

        @total_sa0_dt = ();
        @total_sa1_dt = ();
        @total_sa0_ud = ();
        @total_sa1_ud = ();
        @total_sa0_nd = ();
        @total_sa1_nd = ();

        foreach(@total_sa0_fault)
        {
            if($_ ~~ @sa0_V_dt)
            {
                push(@total_sa0_dt, $_);
                next;
            }
            if($_ ~~ @sa0_E_dt)
            {
                push(@total_sa0_dt, $_);
                next;
            }
            if($_ ~~ @sa0_V_ud)
            {
                if($_ ~~ @sa0_E_ud)
                {
                    push(@total_sa0_ud, $_);
                    next;
                }
            }
            push(@total_sa0_nd, $_);
        }

        foreach(@total_sa1_fault)
        {
            if($_ ~~ @sa1_V_dt)
            {
                push(@total_sa1_dt, $_);
                next;
            }
            if($_ ~~ @sa1_E_dt)
            {
                push(@total_sa1_dt, $_);
                next;
            }
            if($_ ~~ @sa1_V_ud)
            {
                if($_ ~~ @sa1_E_ud)
                {
                    push(@total_sa1_ud, $_);
                    next;
                }
            }
            push(@total_sa1_nd, $_);
        }
        # Print out the result
        for(my $j=0;$j<@total_sa0_dt;$j++)
        {
            print FOUT_DT "sa0 ".$total_sa0_dt[$j]."\n";
        }
        for(my $j=0;$j<@total_sa1_dt;$j++)
        {
            print FOUT_DT "sa1 ".$total_sa1_dt[$j]."\n";
        }
        for(my $j=0;$j<@total_sa0_ud;$j++)
        {
            print FOUT_UD "sa0 ".$total_sa0_ud[$j]."\n";
        }
        for(my $j=0;$j<@total_sa1_ud;$j++)
        {
            print FOUT_UD "sa1 ".$total_sa1_ud[$j]."\n";
        }
        for(my $j=0;$j<@total_sa0_nd;$j++)
        {
            print FOUT_ND "sa0 ".$total_sa0_nd[$j]."\n";
        }
        for(my $j=0;$j<@total_sa1_nd;$j++)
        {
            print FOUT_ND "sa1 ".$total_sa1_nd[$j]."\n";
        }

        print FOUT_FC "Total fault        = ". $totalFault."\n";
        print FOUT_FC "Detected fault     = ". (@total_sa0_dt+@total_sa1_dt)."\n";
        print FOUT_FC "Untestable fault   = ". (@total_sa0_ud+@total_sa1_ud). "\n";
        print FOUT_FC "Undetectable fault = ". (@total_sa0_nd+@total_sa1_nd). "\n";
        print FOUT_FC "Fault coverage     = ". (@total_sa0_dt+@total_sa1_dt) / ($totalFault) * 100 . "%\n";
        print FOUT_FC "Test coverage      = ". (@total_sa0_dt+@total_sa1_dt)/ ( $totalFault-@total_sa0_ud-@total_sa1_ud  ) * 100 ."%\n";
        print FOUT_FC "ATPG runtime       = ".$runTime." s\n";

        close(sa0_begV_dt);
        close(sa0_begE_dt);
        close(sa1_begV_dt);
        close(sa1_begE_dt);

        close(sa0_begV_ud);
        close(sa0_begE_ud);
        close(sa1_begV_ud);
        close(sa1_begE_ud);

        close(sa0_begV_au);
        close(sa0_begE_au);
        close(sa1_begV_au);
        close(sa1_begE_au);
        
        close(sa0_begV_nd);
        close(sa0_begE_nd);
        close(sa1_begV_nd);
        close(sa1_begE_nd);

        close(sa0_begV_log);
        close(sa0_begE_log);
        close(sa1_begV_log);
        close(sa1_begE_log);

        close(FOUT_DT);
        close(FOUT_UD);
        close(FOUT_ND);
        close(FOUT_FC);
    }
}
