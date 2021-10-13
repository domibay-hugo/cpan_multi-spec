#!/usr/bin/perl

# @author Bodo (Hugo) Barwich
# @version 2021-08-18
# @package RPM Packaging for Perl
# @subpackage parse_package-data.pl

# This Module parses the Package Dependencies from the distributed META Files
#
#---------------------------------
# Requirements:
# - The Perl Package "perl-Data-Dump" must be installed
# - The Perl Package "perl-YAML" must be installed
# - The Perl Package "perl-JSON" must be installed
# - The Perl Package "perl-Path-Tiny" must be installed
#
#---------------------------------
# Configurations:
# -r=\"{{ release }}\" --dir=\"{{ source_directory }}\""
#
#---------------------------------
# Features:
#



#==============================================================================
# Exectuting Section


use warnings;
use strict;

use Data::Dump qw(dump);

#use Cwd qw(abs_path);
use Path::Tiny;
use JSON;
use YAML;



#-------------------------------------
#Read the Script Parameters

my $srqpkg = '';
my $srqrel = '';
my $srqmndir = '';

my $iqt = 0;
my $idbg = 0;


if(scalar(@ARGV) > 0)
{
  my $sargky = '';
  my $sargvl = '';


  foreach (@ARGV)
  {
    #print "arg: '$_'\n";

    if(index($_ , '--') == 0)
    {
      #print "prm dsh: '$_'\n";

      $srqpkg = '' if($srqpkg eq 'p');
      $srqrel = '' if($srqrel eq 'r');
      $srqmndir = '' if($srqmndir eq 'd');

      ($sargky, $sargvl) = split(/=/, $_ , 2);

      $sargky = lc substr($sargky, 2);

      #print "prm dsh 1: ky '$sargky'; vl: '"; print $sargvl if(defined $sargvl); print "'\n";

      if($sargky eq 'package')
      {
        $srqpkg = 'p';
      }
      elsif($sargky eq 'release')
      {
        $srqrel = 'r';
      }
      elsif($sargky =~ qr/(main-)?dir(ectory)?/)
      {
        $srqmndir = 'd';
      } #if($sargky eq 'users')

      if(defined $sargvl)
      {
        #The Parameter has an Equal Sign

        if($srqpkg eq 'p')
        {
          $srqpkg = $sargvl;
        }
        elsif($srqrel eq 'r')
        {
          $srqrel = $sargvl;
        }
        elsif($srqmndir eq 'd')
        {
          $srqmndir = $sargvl;
        } #if($srqrel eq 'r')
      } #if(defined $sargvl)
    }
    elsif(index($_ , '-') == 0)
    {
      #print "prm dsh: '$_'\n";

      $srqpkg = '' if($srqpkg eq 'p');
      $srqrel = '' if($srqrel eq 'r');
      $srqmndir = '' if($srqmndir eq 'd');

      ($sargky, $sargvl) = split(/=/, $_ , 2);

      $sargky = lc substr($sargky, 1);

      #print "prm dsh 1: ky '$sargky'; vl: '"; print $sargvl if(defined $sargvl); print "'\n";

      while($sargky =~ /(.)/g)
      {
        if($1 eq 'p')
        {
          $srqpkg = 'p';
        }
        elsif($1 eq 'r')
        {
          $srqrel = 'r';
        }
        elsif($1 =~ qr/[qb]/)
        {
          $iqt = 1;
        }
        elsif($1 =~ qr/[dv]/)
        {
          $idbg = 1;
        }
      } #while($sarg =~ /(.)/g)

      if(defined $sargvl)
      {
        #The Parameter has an Equal Sign

        if($srqpkg eq 'p')
        {
          $srqpkg = $sargvl;
        }
        elsif($srqrel eq 'r')
        {
          $srqrel = $sargvl;
        }
      } #if(defined $sargvl)
    }
    else  #The Parameter does not have a Dash Sign
    {
      #print "prm any: '$_'\n";

      if($_ =~ qr/^-?\d+$/)
      {
        #The Parameter is a Number
      }
      else  #The Parameter isn't a Number
      {
        #Parameter any Value

        if($srqpkg eq 'p')
        {
          $srqpkg = $_ ;
        }
        elsif($srqrel eq 'r')
        {
          $srqrel = $_ ;
        }
        elsif($srqmndir eq 'd')
        {
          $srqmndir = $_ ;
        } #if($srqrel eq 'r')
      } #if($_ =~ qr/^-?\d+$/)
    }  #if(index($sarg, "-") == 0)
  }  #foreach $sarg (@ARGV)
}  #if(scalar(@ARGV) > 0)

if($idbg > 0
  && $iqt < 1)
{
  print "rq pkg: '$srqpkg'; rq rel: '$srqrel'; rq dir: '$srqmndir'\n";
  print "qt: '$iqt'; dbg: '$idbg'\n";
} #if($idbg > 0 && $iqt < 1)

$srqmndir .= '/' unless($srqmndir =~ qr#/$#);


#-------------------------------------
#Parse the Package Build Configuration

my $rhshpkgcnf = undef;
my %hshrscnf = ('builder' => '', 'arch' => 'noarch', 'config' => 'yaml');
my %hshftbld = ();
my @arrftsrtd = undef;
my $spkgcnf = undef;
my $sdocfls = undef;
my $sdocfl = undef;
my $sdocflxt = undef;

my $spkgdir = $srqmndir . $srqrel;
my $ixscnt = 0;

my $ierr = 0;


$spkgdir = `readlink -f ${srqmndir}${srqrel}`;
#$spkgdir = abs_path($srqmndir . $srqrel);

chomp $spkgdir;

if($idbg > 0
  && $iqt < 1)
{
  print "pkg dir 1 dmp:\n" . dump($spkgdir); print "\n";
} #if($idbg > 0 && $iqt < 1)

unless(defined $spkgdir)
{
  $spkgdir = $srqmndir . $srqrel;
  $ierr = 0 + $!;

  print STDERR "Package '$srqpkg': Directory '$spkgdir' cannot be recognized!\n"
    , "Message [$ierr]: '$!'\n";
}

unless(defined $spkgdir
  && $spkgdir ne '')
{
  $spkgdir = $srqmndir . $srqrel;

  print STDERR "Package '$srqpkg': Source Directory '$spkgdir' does not exist!\n";

  exit 2;
} #unless(defined $spkgdir && $spkgdir ne '')

$spkgdir .= '/' unless($spkgdir =~ qr#/$#);

unless(-d $spkgdir)
{
  print STDERR "Package '$srqpkg': Source Directory '$spkgdir' does not exist!\n";

  exit 2;
} #unless(-d $spkgdir)

unless(chdir $spkgdir)
{
  print STDERR "Package '$srqpkg': Source Directory '$spkgdir' cannot be accessed!\n";

  exit 1;
}

if(-f 'Makefile.PL')
{
  $hshrscnf{'builder'} = 'make';
}
elsif(-f 'Build.PL')
{
  $hshrscnf{'builder'} = 'build';
}

$ixscnt = `find ./ -name "*.xs" | wc -l`;

chomp $ixscnt;

$ixscnt = 0 if($ixscnt eq '');

$hshrscnf{'arch'} = 'x86_64' if($ixscnt);


if(-f 'META.yml')
{
  $spkgcnf = path('META.yml')->slurp;
}
elsif(-f 'META.json')
{
  $spkgcnf = path('META.json')->slurp;

  $hshrscnf{'config'} = 'json';
}
else  #No Meta Data File included
{
  print STDERR "Package '$srqpkg': Meta Data File does not exist.\n";
}

if(defined $spkgcnf)
{
  #------------------------
  #Check for Syntax Errors
  #And Parse the Text Content

  if(index($_ , '---') == 0)
  {
    $hshrscnf{'config'} = 'yaml';
  }

  if(index($_ , '{') == 0)
  {
    $hshrscnf{'config'} = 'json';
  }

  if($hshrscnf{'config'} eq 'yaml')
  {
    $rhshpkgcnf = YAML::Load $spkgcnf;
  }
  elsif($hshrscnf{'config'} eq 'json')
  {
    $rhshpkgcnf = JSON::decode_json($spkgcnf);
  }
} #if(defined $spkgcnf)


if($idbg > 0
  && $iqt < 1)
{
  print "pkg cnf in 0 dmp:\n" . dump($rhshpkgcnf); print "\n";
}

if(defined $rhshpkgcnf)
{
  $hshrscnf{'release.version'} = $rhshpkgcnf->{'version'};
  $hshrscnf{'distribution'} = $rhshpkgcnf->{'name'};
  $hshrscnf{'summary'} = $rhshpkgcnf->{'abstract'};
} #if(defined $rhshpkgcnf)

$hshrscnf{'license'} = '';
$hshrscnf{'docs'} = [];
$hshrscnf{'examples'} = 0;
$hshrscnf{'requires'}{'build'} = [];
$hshrscnf{'requires'}{'runtime'} = [];
$hshrscnf{'recommends'} = [];
$hshrscnf{'provides'} = [];

if(-f 'MANIFEST')
{
  #------------------------
  #Parse MANIFEST File List

  my %hshexfls = ('MANIFEST' => 0);
  my %hshexflxts = ('.ini' => 0, '.h' => 0, '.c' => 0, '.xs' => 0
    , '.PL' => 0, '.pl' => 0, '.pm' => 0, '.psgi' => 0);


  $sdocfls = path('MANIFEST')->slurp;

  $sdocfls =~ s/^#.*$//gm;

  $hshrscnf{'examples'} = 1 if($sdocfls =~ qr#examples/#i);

  $sdocfls =~ s#^.*/.*$##gm;
  $sdocfls =~ s/^\s*$//gm;
  $sdocfls =~ s#\n\n#\n#gs;

  print "doc fls 1: '$sdocfls'\n" if($idbg > 0 && $iqt < 1);

  while($sdocfls =~ m#^([^[:space:]\.]+)(\.[a-z0-9\.]*)?$#gmi)
  {
    $sdocfl = $1;
    $sdocflxt = $2 || '';

    print "doc fl: '$sdocfl', '$sdocflxt'\n" if($idbg > 0 && $iqt < 1);

    if(index($sdocfl, '/') == -1)
    {
      unless(defined $hshexfls{$sdocfl})
      {
        if($sdocflxt ne '')
        {
          push @{$hshrscnf{'docs'}}, ($sdocfl . $sdocflxt)
            unless(defined $hshexflxts{$sdocflxt});
        }
        else  #File without an Extension
        {
          if($sdocfl =~ qr/licen[sc]e/i)
          {
            $hshrscnf{'license'} = $sdocfl ;
          }
          else
          {
            push @{$hshrscnf{'docs'}}, $sdocfl ;
          }
        } #if($sdocflxt ne '')
      } #unless(defined $hshexfls{$sdocfl})
    }
    else  #Sub Directory File
    {
      $hshrscnf{'examples'} = 1
        if(index($sdocfl, 'examples') != -1);

    } #if(index($sdocfl, '/') == -1)
  } #while($sdocfls =~ m#([^\.]+)(\..*)?$#gm)
} #if(-f 'MANIFEST')

if(defined $rhshpkgcnf->{'prereqs'})
{
  #------------------------
  #Parse JSON Structure

  if(defined $rhshpkgcnf->{'prereqs'}->{'build'}
    && defined $rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'}})
    {
      if(defined $hshftbld{$_})
      {
        $hshftbld{$_} = $rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'}->{$_}
          if($rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'}->{$_} > $hshftbld{$_});

      }
      else
      {
        $hshftbld{$_} = $rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'}->{$_};
      }
    } #foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'}})
  } #if(defined $rhshpkgcnf->{'prereqs'}->{'build'}
    # && defined $rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'})

  if(defined $rhshpkgcnf->{'prereqs'}->{'configure'}
    && defined $rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'}})
    {
      if(defined $hshftbld{$_})
      {
        $hshftbld{$_} = $rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'}->{$_}
          if($rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'}->{$_} > $hshftbld{$_});

      }
      else
      {
        $hshftbld{$_} = $rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'}->{$_};
      }
    } #foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'}})
  } #if(defined $rhshpkgcnf->{'prereqs'}->{'configure'}
    # && defined $rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'})

  if(defined $rhshpkgcnf->{'prereqs'}->{'test'}
    && defined $rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'}})
    {
      if(defined $hshftbld{$_})
      {
        $hshftbld{$_} = $rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'}->{$_}
          if($rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'}->{$_} > $hshftbld{$_});

      }
      else
      {
        $hshftbld{$_} = $rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'}->{$_};
      }
    } #foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'}})
  } #if(defined $rhshpkgcnf->{'prereqs'}->{'test'}
    # && defined $rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'})

  if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'})
  {
    if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'requires'})
    {
      foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'runtime'}->{'requires'}})
      {
        push @{$hshrscnf{'requires'}{'runtime'}}, ({'feature' => $_
          , 'version' => $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'requires'}->{$_}});
      }
    } #if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'}
      # && defined $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'requires'})

    if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'recommends'})
    {
      foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'runtime'}->{'recommends'}})
      {
        push @{$hshrscnf{'recommends'}}, ({'feature' => $_
          , 'version' => $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'recommends'}->{$_}});
      }
    } #if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'recommends'})
  } #if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'})
}
else  #Package does not have the 'prereqs' Structure
{
  #------------------------
  #Parse YAML Structure

  if(defined $rhshpkgcnf->{'build_requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'build_requires'}})
    {
      if(defined $hshftbld{$_})
      {
        $hshftbld{$_} = $rhshpkgcnf->{'build_requires'}->{$_}
          if($rhshpkgcnf->{'build_requires'}->{$_} > $hshftbld{$_});

      }
      else
      {
        $hshftbld{$_} = $rhshpkgcnf->{'build_requires'}->{$_}
      }
    } #foreach (keys %{$rhshpkgcnf->{'build_requires'}})
  } #if(defined $rhshpkgcnf->{'build_requires'})

  if(defined $rhshpkgcnf->{'configure_requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'configure_requires'}})
    {
      if(defined $hshftbld{$_})
      {
        $hshftbld{$_} = $rhshpkgcnf->{'configure_requires'}->{$_}
          if($rhshpkgcnf->{'configure_requires'}->{$_} > $hshftbld{$_});

      }
      else
      {
        $hshftbld{$_} = $rhshpkgcnf->{'configure_requires'}->{$_}
      }
    } #foreach (keys %{$rhshpkgcnf->{'configure_requires'}})
  } #if(defined $rhshpkgcnf->{'configure_requires'})

  if(defined $rhshpkgcnf->{'requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'requires'}})
    {
      push @{$hshrscnf{'requires'}{'runtime'}}, ({'feature' => $_
          , 'version' => $rhshpkgcnf->{'requires'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'requires'})

  if(defined $rhshpkgcnf->{'recommends'})
  {
    foreach (keys %{$rhshpkgcnf->{'recommends'}})
    {
      push @{$hshrscnf{'recommends'}}, ({'feature' => $_
          , 'version' => $rhshpkgcnf->{'recommends'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'recommends'})
} #if(defined $rhshpkgcnf->{'prereqs'})

if(defined $rhshpkgcnf->{'provides'})
{
  foreach (keys %{$rhshpkgcnf->{'provides'}})
  {
    push @{$hshrscnf{'provides'}}, ({'feature' => $_
        , 'version' => $rhshpkgcnf->{'provides'}->{$_}->{'version'}});
  }
} #if(defined $rhshpkgcnf->{'configure_requires'})

@arrftsrtd = sort {$a cmp $b} (keys %hshftbld);

foreach (@arrftsrtd)
{
  push @{$hshrscnf{'requires'}{'build'}}, ({'feature' => $_ , 'version' => $hshftbld{$_}});
}

if($idbg > 0
  && $iqt < 1)
{
  print "pkg cnf 1 dmp:\n" . dump(%hshrscnf) ; print "\n";
}


#------------------------
#Clear empty Values

foreach (keys %hshrscnf)
{
  delete $hshrscnf{$_} unless(defined $hshrscnf{$_});
}

if($idbg > 0
  && $iqt < 1)
{
  print "pkg cnf 2 dmp:\n" . dump(%hshrscnf) ; print "\n";
}



#-------------------------------------
#Report the Package Configuration Result

if($hshrscnf{'builder'} ne '')
{
  print encode_json \%hshrscnf;
}
else
{
  print STDERR "Package '$srqpkg': Build System was not recognized!\n";

  $ierr =  2;
}

#Communicate Error Code
exit $ierr;
